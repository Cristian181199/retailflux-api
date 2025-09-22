# Dokploy Deployment Guide - RetailFlux API 🚀

Esta guía te ayudará a desplegar la RetailFlux API en Dokploy con configuración optimizada para producción.

## 📋 Prerrequisitos

- ✅ Dokploy configurado y funcionando
- ✅ Base de datos PostgreSQL existente en Dokploy (misma que usa el webscraper)
- ✅ Variables de entorno de base de datos configuradas a nivel de proyecto
- ✅ Repositorio GitHub: `https://github.com/Cristian181199/retailflux-api`

## 🗄️ Variables de Entorno Requeridas

### En Dokploy UI (Configuración del Servicio)

#### **Base de Datos (referenciar del proyecto)**
```bash
POSTGRES_HOST=${{project.POSTGRES_HOST}}
POSTGRES_PORT=${{project.POSTGRES_PORT}}
POSTGRES_DB=${{project.POSTGRES_DB}}
POSTGRES_USER=${{project.POSTGRES_USER}}
POSTGRES_PASSWORD=${{project.POSTGRES_PASSWORD}}
```

#### **Configuración de la API**
```bash
# Configuración del servidor
API_HOST=0.0.0.0
API_PORT=8000
API_WORKERS=2
API_TIMEOUT=30
API_MODE=start

# Configuración de la aplicación
API_TITLE=RetailFlux API
API_DESCRIPTION=AI-powered supermarket product search and recommendations API
API_VERSION=2.0.0
API_DEBUG=false

# CORS (ajustar según tus dominios)
CORS_ORIGINS=https://your-domain.com,https://www.your-domain.com

# Base de datos
SQLALCHEMY_ECHO=false
DB_POOL_SIZE=15
DB_MAX_OVERFLOW=25

# Variables de aplicación
APP_ENV=production
PYTHONPATH=/app/src
```

#### **AI Features (Opcional)**
```bash
OPENAI_API_KEY=your_openai_api_key_here
ENABLE_AI_FEATURES=true
GENERATE_EMBEDDINGS=true
EMBEDDING_MODEL=text-embedding-3-small
EMBEDDING_DIMENSION=1536
SIMILARITY_THRESHOLD=0.8
MAX_SEARCH_RESULTS=50
```

#### **Seguridad (Opcional para futuras funciones)**
```bash
JWT_SECRET_KEY=your_very_secure_jwt_secret_key_here
JWT_ALGORITHM=HS256
```

## 🐳 Configuración del Servicio en Dokploy

### 1. Crear Nuevo Servicio

1. **Ir a tu proyecto en Dokploy**
2. **Crear nuevo servicio** → "Application"
3. **Configurar origen**:
   - **Source Type**: GitHub
   - **Repository**: `Cristian181199/retailflux-api`
   - **Branch**: `main`

### 2. Configuración Docker

```yaml
# Dokploy detectará automáticamente el Dockerfile
# El Dockerfile ya está optimizado para producción con multi-stage build
```

### 3. Configurar Variables de Entorno

En la sección **Environment Variables** del servicio, agregar todas las variables listadas arriba.

### 4. Configuración de Red

- **Port Mapping**: 8000:8000 (para acceso externo)
- **Internal Network**: Conectar con la red donde está tu base de datos
- **Domain**: Configurar dominio personalizado si es necesario

### 5. Configuración de Recursos

```yaml
# Recursos recomendados para la API
CPU: 1-2 vCPU
Memory: 1-2GB RAM
Storage: 1GB (mínimo)
```

## ⚙️ Despliegue del Servicio

### 1. Primera Ejecución

```bash
# El servicio se desplegará en modo "start" por defecto
# Esto iniciará el servidor FastAPI en producción
```

### 2. Verificar el Deployment

1. **Check Logs**: Deberías ver:
   ```
   🚀 RetailFlux API
   =================
   ⏳ Waiting for database connection...
   ✅ Database connection established.
   🌐 Starting RetailFlux API server...
   INFO:     Started server process [1]
   INFO:     Waiting for application startup.
   INFO:     Application startup complete.
   INFO:     Uvicorn running on http://0.0.0.0:8000
   ```

2. **Verificar API**: Accede a:
   - **Health Check**: `https://your-domain.com/health`
   - **API Docs**: `https://your-domain.com/docs`
   - **API Info**: `https://your-domain.com/`

### 3. Respuesta Esperada del Health Check

```json
{
  "status": "ok",
  "database": "ok",
  "ai_embeddings": "ok",
  "timestamp": "2025-09-22T15:00:00Z"
}
```

## 🔍 Endpoints Principales

Una vez desplegada, tu API tendrá estos endpoints disponibles:

### **Core API**
- `GET /` - Información de la API
- `GET /health` - Health check
- `GET /docs` - Documentación interactiva (Swagger UI)

### **Products API**
- `GET /api/v1/products/` - Lista de productos
- `GET /api/v1/products/{id}` - Producto específico
- `GET /api/v1/products/{id}/similar` - Productos similares
- `GET /api/v1/products/by-price-range/` - Filtrar por precio

### **Search API**
- `GET /api/v1/search/` - Búsqueda general
- `GET /api/v1/search/semantic` - Búsqueda semántica con AI
- `GET /api/v1/search/hybrid` - Búsqueda híbrida

## 🧪 Testing de la API

### Test Básico de Funcionamiento

```bash
# Health check
curl https://your-domain.com/health

# Información de la API
curl https://your-domain.com/

# Buscar productos
curl "https://your-domain.com/api/v1/products/?limit=5"

# Búsqueda semántica (si AI está habilitado)
curl "https://your-domain.com/api/v1/search/semantic?query=organic bread"
```

### Test desde Frontend

```javascript
// Test de conexión desde JavaScript
const testAPI = async () => {
  const response = await fetch('https://your-domain.com/health');
  const data = await response.json();
  console.log('API Status:', data);
};

testAPI();
```

## 🛠️ Troubleshooting

### Error de Conexión a Base de Datos

1. **Verificar variables de entorno** (usar sintaxis `${{project.VARIABLE}}`)
2. **Comprobar que la BD esté corriendo**
3. **Revisar conectividad de red entre servicios**

```bash
# Test manual de conexión
docker exec [container_name] pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
```

### Error 500 en los Endpoints

1. **Revisar logs del contenedor**
2. **Verificar importaciones de Python**
3. **Comprobar variables de entorno de AI**

### Performance Issues

```bash
# Aumentar workers y recursos
API_WORKERS=4
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=30
```

### CORS Errors

```bash
# Actualizar CORS origins
CORS_ORIGINS=https://your-frontend.com,https://your-app.com
```

## 📊 Optimización para Producción

### Variables Recomendadas para Producción

```bash
# Performance
API_WORKERS=4
API_TIMEOUT=60
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=30

# Security
API_DEBUG=false
SQLALCHEMY_ECHO=false

# AI optimizado
SIMILARITY_THRESHOLD=0.85
MAX_SEARCH_RESULTS=20
```

### SSL/HTTPS Configuration

En Dokploy:
1. **Configurar dominio personalizado**
2. **Habilitar SSL automático**
3. **Verificar certificados**

### Performance Monitoring

Monitorear estos endpoints:
- `/health` - Estado del sistema
- `/docs` - Documentación siempre accesible
- Logs de Dokploy para errores

## 🔄 CI/CD Pipeline

La API se despliega automáticamente:
1. **Push a main** → Trigger GitHub Actions
2. **Build Docker image** → Push a GHCR
3. **Dokploy detecta cambios** → Auto-redeploy

### Manual Redeploy

En Dokploy:
1. **Ir al servicio API**
2. **Click "Redeploy"**
3. **Verificar logs**

## 🔗 Integración con otros Servicios

### Con el WebScraper

La API y el WebScraper comparten:
- **Misma base de datos**
- **Mismos modelos de datos**
- **Variables de entorno del proyecto**

### Con Frontend

```javascript
// Configuración típica de frontend
const API_BASE_URL = 'https://your-api.com/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});
```

## 🎯 Verificación Final

1. ✅ **API desplegada** y respondiendo en el dominio
2. ✅ **Health check** retorna status "ok"
3. ✅ **Documentación** accesible en `/docs`
4. ✅ **Base de datos** conectada correctamente
5. ✅ **Logs limpios** sin errores
6. ✅ **SSL configurado** (si aplica)

## 🚀 Next Steps

1. **Configurar monitoreo** de la API
2. **Establecer alertas** para errores
3. **Configurar backup** de la configuración
4. **Documentar** endpoints personalizados

¡Tu RetailFlux API estará lista para servir datos de productos con capacidades de IA! 🌟