#!/bin/bash
set -e

echo "🚀 RetailFlux API"
echo "================="

# Wait for the database to be ready
echo "⏳ Waiting for database connection..."
while ! pg_isready -h "${POSTGRES_HOST:-localhost}" -p "${POSTGRES_PORT:-5432}" -U "${POSTGRES_USER}" -q; do
  echo "  Database not ready, waiting 3 seconds..."
  sleep 3
done
echo "✅ Database connection established."

# Move to the API directory
cd /app/src/api

# Debug: Check Python and uvicorn availability
echo "🔍 Debug: Python path and uvicorn check:"
echo "  Python: $(which python)"
echo "  PATH: $PATH"
python -c "import uvicorn; print(f'  uvicorn version: {uvicorn.__version__}')" || echo "  ❌ uvicorn not found in Python"
echo ""

# Get the command
MODE=${1:-${API_MODE:-start}}

case "$MODE" in
    "start")
        echo "🌐 Starting RetailFlux API server..."
        exec python -m uvicorn main:app \
            --host "${API_HOST:-0.0.0.0}" \
            --port "${API_PORT:-8000}" \
            --workers "${API_WORKERS:-1}" \
            --timeout-keep-alive "${API_TIMEOUT:-5}"
        ;;
    "dev")
        echo "🔧 Starting API in development mode..."
        exec python -m uvicorn main:app \
            --host "${API_HOST:-0.0.0.0}" \
            --port "${API_PORT:-8000}" \
            --reload \
            --log-level debug
        ;;
    "migrate")
        echo "📊 Running database migrations..."
        cd /app/src
        exec alembic upgrade head
        ;;
    "shell")
        echo "🐚 Starting Python shell..."
        exec python -c "
import sys
sys.path.insert(0, '/app/src')
from shared.config import *
from shared.database import *
print('RetailFlux API Shell - All modules imported')
print('Available: database_settings, ai_settings, db_manager')
import IPython
IPython.start_ipython(argv=[])
"
        ;;
    *)
        echo "❓ Unknown mode: $MODE"
        echo "Available modes: start, dev, migrate, shell"
        exit 1
        ;;
esac