# Multi-stage build for minimal production API image
# Stage 1: Build dependencies
FROM python:3.12-slim as builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements first for better caching
COPY src/api/requirements.txt /tmp/requirements-api.txt
COPY src/shared/requirements.txt /tmp/requirements-shared.txt

# Install Python dependencies in virtual environment
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements-api.txt \
    && pip install --no-cache-dir -r /tmp/requirements-shared.txt \
    && find /opt/venv -name "*.pyc" -delete \
    && find /opt/venv -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# Stage 2: Production image
FROM python:3.12-slim as production

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_ENV=production \
    PYTHONPATH=/app/src \
    PATH="/opt/venv/bin:$PATH"

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user
RUN groupadd -r apiuser && useradd -r -g apiuser apiuser

# Copy virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv

# Set work directory
WORKDIR /app

# Copy source code
COPY --chown=apiuser:apiuser src/ ./src/
COPY --chown=apiuser:apiuser entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && chown -R apiuser:apiuser /app

# Switch to non-root user
USER apiuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${API_PORT:-8000}/health || exit 1

# Expose port
EXPOSE 8000

# Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["start"]