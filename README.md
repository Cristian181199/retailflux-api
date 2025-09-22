# RetailFlux API 🚀

> AI-powered REST API for German supermarket product search and recommendations

[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://docker.com)
[![Python](https://img.shields.io/badge/Python-3.12-green)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-red)](https://fastapi.tiangolo.com)
[![AI](https://img.shields.io/badge/AI-Enabled-purple)](https://openai.com)

## 🎯 Overview

RetailFlux API is a modern, production-ready REST API that provides intelligent product search and recommendations for German supermarket data. Built with FastAPI, SQLAlchemy, and AI capabilities, it offers:

- **RESTful API endpoints** for product management
- **AI-powered semantic search** with OpenAI embeddings
- **Vector similarity search** using pgvector
- **Hybrid search** combining text and semantic matching
- **Product recommendations** based on similarity
- **Multi-store support** with comprehensive filtering
- **Real-time health monitoring** and metrics

## 🏗️ Architecture

```
retailflux-api/
├── src/
│   ├── api/                    # FastAPI application
│   │   ├── main.py            # Application entry point
│   │   ├── routers/           # API endpoint routes
│   │   │   ├── products.py    # Product CRUD operations
│   │   │   ├── search.py      # Search functionality
│   │   │   └── ai.py          # AI-powered features
│   │   ├── middleware/        # Custom middleware
│   │   └── requirements.txt   # API-specific dependencies
│   └── shared/                # Shared components
│       ├── database/          # SQLAlchemy models & repos
│       ├── config/           # Configuration management
│       └── ai/               # AI functionality
├── .github/workflows/         # CI/CD pipelines
├── Dockerfile                 # Production container
├── entrypoint.sh             # API startup script
└── DOKPLOY_DEPLOYMENT.md     # Deployment guide
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- PostgreSQL with pgvector extension
- OpenAI API key (optional, for AI features)

### 1. Clone & Environment Setup

```bash
# Clone repository
git clone https://github.com/your-username/retailflux-api.git
cd retailflux-api

# Create environment file
cp .env.example .env
```

### 2. Configure Environment

Edit `.env` file:

```bash
# Database Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=products_db
POSTGRES_USER=cristian
POSTGRES_PASSWORD=your_secure_password

# API Configuration
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=1

# AI Features (Optional)
OPENAI_API_KEY=your_openai_api_key
ENABLE_AI_FEATURES=true
```

### 3. Run with Docker

```bash
# Build and run
docker build -t retailflux-api .
docker run -p 8000:8000 --env-file .env retailflux-api

# API will be available at http://localhost:8000
```

### 4. Local Development

```bash
# Install dependencies
pip install -r src/api/requirements.txt
pip install -r src/shared/requirements.txt

# Set Python path
export PYTHONPATH="$PWD/src"

# Run development server
cd src/api
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## 📡 API Endpoints

### **Products**
- `GET /api/v1/products/` - List products with pagination and filters
- `GET /api/v1/products/{id}` - Get specific product
- `GET /api/v1/products/{id}/similar` - Get similar products (AI-powered)
- `GET /api/v1/products/by-price-range/` - Filter by price range

### **Search**
- `GET /api/v1/search/` - General product search
- `GET /api/v1/search/semantic` - AI semantic search
- `GET /api/v1/search/hybrid` - Combined text + semantic search

### **AI Features**
- `GET /api/v1/ai/recommendations/{product_id}` - AI product recommendations
- `GET /api/v1/ai/embeddings/{product_id}` - Get product embeddings
- `POST /api/v1/ai/similarity` - Custom similarity search

### **System**
- `GET /` - API information and features
- `GET /health` - Health check endpoint
- `GET /docs` - Interactive API documentation (Swagger UI)

## 🔍 Usage Examples

### Basic Product Search

```bash
# Get products with pagination
curl "http://localhost:8000/api/v1/products/?skip=0&limit=10"

# Filter by store and category
curl "http://localhost:8000/api/v1/products/?store_id=1&category_id=5&in_stock_only=true"

# Search by price range
curl "http://localhost:8000/api/v1/products/by-price-range/?min_price=1.0&max_price=10.0"
```

### AI-Powered Search

```bash
# Semantic search
curl "http://localhost:8000/api/v1/search/semantic?query=organic bread"

# Get similar products
curl "http://localhost:8000/api/v1/products/123/similar?limit=5"

# Hybrid search (text + AI)
curl "http://localhost:8000/api/v1/search/hybrid?query=healthy breakfast&limit=10"
```

### Health Check

```bash
curl "http://localhost:8000/health"
```

Response:
```json
{
  "status": "ok",
  "database": "ok",
  "ai_embeddings": "ok",
  "timestamp": "2025-09-22T15:00:00Z"
}
```

## 🤖 AI Capabilities

### Semantic Search
- **OpenAI embeddings** for understanding product context
- **Vector similarity** using PostgreSQL pgvector
- **Multi-language support** (German/English)
- **Contextual understanding** beyond keyword matching

### Product Recommendations
- **Content-based filtering** using product features
- **Similarity scoring** based on embeddings
- **Category-aware recommendations**
- **Price-sensitive suggestions**

## 🗄️ Database Integration

### Models
- **Products**: Complete product information with AI embeddings
- **Categories**: Hierarchical category structure
- **Stores**: Multi-store support
- **Manufacturers**: Brand and manufacturer data

### Vector Search
```sql
-- Example: Find similar products using pgvector
SELECT name, price_amount, 
       embedding <=> '[0.1,0.2,...]' AS similarity
FROM products 
ORDER BY embedding <=> '[0.1,0.2,...]' 
LIMIT 10;
```

## 🐳 Docker Configuration

### Production Container
- **Multi-stage build** for minimal image size
- **Non-root user** for security
- **Health checks** integrated
- **Environment-based configuration**

### Container Modes
```bash
# Production API server
docker run -e API_MODE=start retailflux-api

# Development with hot reload
docker run -e API_MODE=dev retailflux-api

# Database migrations
docker run -e API_MODE=migrate retailflux-api

# Python shell for debugging
docker run -e API_MODE=shell -it retailflux-api
```

## 📊 Monitoring & Performance

### Metrics Available
- **API response times**
- **Database connection health**
- **AI service availability**
- **Request/error rates**
- **Resource usage**

### Performance Features
- **Connection pooling** for database
- **Async/await** for concurrent requests
- **Pagination** for large datasets
- **Caching** for frequently accessed data
- **Rate limiting** protection

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_HOST` | API server host | `0.0.0.0` |
| `API_PORT` | API server port | `8000` |
| `API_WORKERS` | Uvicorn workers | `1` |
| `POSTGRES_HOST` | Database host | `localhost` |
| `POSTGRES_PORT` | Database port | `5432` |
| `OPENAI_API_KEY` | OpenAI API key | - |
| `ENABLE_AI_FEATURES` | Enable AI functionality | `true` |

### Advanced Configuration
```python
# Custom configuration in shared/config/settings.py
API_SETTINGS = {
    'cors_origins': ['http://localhost:3000'],
    'max_search_results': 100,
    'similarity_threshold': 0.8,
    'cache_ttl': 300
}
```

## 🧪 Testing

```bash
# Run API tests
pytest src/tests/

# Test specific endpoints
pytest src/tests/test_products.py

# Load testing
locust -f tests/locustfile.py --host http://localhost:8000
```

## 🚢 Deployment

### Dokploy Deployment
See [DOKPLOY_DEPLOYMENT.md](DOKPLOY_DEPLOYMENT.md) for complete deployment guide.

### Production Checklist
- ✅ Environment variables configured
- ✅ Database migrations applied
- ✅ SSL/TLS certificates setup
- ✅ Health checks configured
- ✅ Monitoring enabled
- ✅ Backup strategy implemented

## 📚 API Documentation

### Interactive Documentation
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI Schema**: http://localhost:8000/openapi.json

### Response Formats
All endpoints return JSON with consistent structure:
```json
{
  "products": [...],
  "total": 150,
  "skip": 0,
  "limit": 20,
  "filters": {...}
}
```

## 🤝 Integration

### Frontend Integration
```javascript
// React/Vue.js example
const api = axios.create({
  baseURL: 'http://localhost:8000/api/v1',
  timeout: 5000
});

// Search products
const searchProducts = async (query) => {
  const response = await api.get(`/search/hybrid?query=${query}`);
  return response.data.products;
};
```

### Other Services
- **Compatible with RetailFlux WebScraper**
- **Shared database schema**
- **Microservices architecture ready**

## 🔒 Security

### Features
- **Input validation** using Pydantic
- **SQL injection protection** via SQLAlchemy ORM
- **CORS configuration** for browser security
- **Rate limiting** to prevent abuse
- **Non-root container** execution

### Best Practices
- Environment variables for secrets
- Regular security updates
- API key rotation
- Access logging

## 📈 Scalability

### Horizontal Scaling
```yaml
# Docker Compose scaling
services:
  api:
    image: retailflux-api
    deploy:
      replicas: 3
```

### Vertical Scaling
```bash
# Increase workers for CPU-bound tasks
API_WORKERS=4

# Database connection pooling
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=30
```

## 🙏 Acknowledgments

- **FastAPI** - Modern Python web framework
- **SQLAlchemy** - Database toolkit
- **OpenAI** - AI embeddings
- **pgvector** - Vector similarity search

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- 📧 Email: cristian181199@gmail.com
- 💻 GitHub Issues: [Create an issue](https://github.com/your-username/retailflux-api/issues)
- 📚 Documentation: http://localhost:8000/docs