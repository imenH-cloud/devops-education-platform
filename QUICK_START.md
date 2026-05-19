# ⚡ Quick Start Guide - DevOps Education v2.1

## 🚀 Démarrage en 5 Minutes

### 1. Clone & Setup
```bash
git clone <repository>
cd devops-education
cp .env.example .env
```

### 2. Démarrer le Stack Complet
```bash
# Démarrer tous les services
docker compose up -d

# Attendre 30 secondes pour l'initialisation
sleep 30

# Vérifier le statut
docker compose ps
```

### 3. Accéder aux Applications

**Frontend (UI):**
```
http://localhost:4200
```

**API Documentation (Swagger):**
```
http://localhost:3000/api/docs
```

**Monitoring:**
- **Grafana:** http://localhost:3099 (admin/admin)
- **Prometheus:** http://localhost:9090
- **Kibana:** http://localhost:5601

**Tools:**
- **RabbitMQ:** http://localhost:15672 (guest/guest)
- **MinIO:** http://localhost:9001 (minioadmin/minioadmin)

---

## 🧪 Test l'API

### Health Check
```bash
curl http://localhost:3000/health
```

### Get Users
```bash
curl http://localhost:3000/api/users
```

### Create User
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "name": "Test User",
    "password": "password123"
  }'
```

### View Logs
```bash
# Gateway logs
docker compose logs -f gateway-backend

# Specific service
docker compose logs -f user-service

# All services
docker compose logs -f
```

---

## 🛑 Arrêter le Stack

```bash
# Stop all containers (keep volumes)
docker compose stop

# Remove containers and volumes
docker compose down -v

# Remove everything including images
docker compose down -v --rmi all
```

---

## 🔧 Configuration

### Environment Variables
```env
# Database
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=education

# RabbitMQ
RABBITMQ_USER=guest
RABBITMQ_PASS=guest

# MinIO
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
```

### Services Ports
```
Frontend        → 4200
API Gateway     → 3000
Auth Service    → 3001
User Service    → 3002
Activity        → 3003
Parent Service  → 3004
Student Service → 3005
Classroom       → 3006
Teacher Service → 3007

PostgreSQL      → 5432
Redis           → 6379
RabbitMQ        → 5672 (15672 mgmt)
Elasticsearch   → 9200
Kibana          → 5601
MinIO           → 9000 (9001 console)
Prometheus      → 9090
Grafana         → 3099
```

---

## 📊 Dashboard Features

### Real-time Updates
- Connection status indicator
- Notification badge
- User activity tracking

### Statistics
- Active users count
- Active courses
- Completed tasks
- System uptime

### Charts
- User growth trend
- Activity distribution
- API performance
- Platform usage

---

## 🌙 Dark Mode

**Toggle dark mode:**
- Click the moon icon in the header
- Preference is saved in localStorage
- System preference detected on first load

---

## 🔔 Notifications

Toast notifications for:
- ✅ Success actions
- ❌ Errors
- ⚠️ Warnings
- ℹ️ Info messages

Example:
```typescript
this.notificationService.success('User created successfully!');
this.notificationService.error('Failed to save changes');
```

---

## 🔍 Debugging

### Check Service Health
```bash
# All services
curl http://localhost:3000/api/health/all

# Specific service
curl http://localhost:3002/health
```

### View Metrics
```bash
curl http://localhost:9090/metrics
```

### Database Access
```bash
# Connect to PostgreSQL
docker compose exec postgres psql -U postgres -d education

# Common queries
\dt  # list tables
SELECT * FROM users;
SELECT COUNT(*) FROM activities;
```

### Cache Status
```bash
# Connect to Redis
docker compose exec redis redis-cli
KEYS *
GET key_name
DBSIZE
```

---

## 🐛 Common Issues

### Services not starting
```bash
# Check logs
docker compose logs -f

# Increase timeout
docker compose up -d --wait
```

### Port already in use
```bash
# Change in docker-compose.yml
ports:
  - "4201:4200"  # Use 4201 instead
```

### Database connection failed
```bash
# Wait for PostgreSQL
docker compose up -d postgres
sleep 5
docker compose up -d
```

### Memory issues
```bash
# Increase Docker memory limit
# Docker Desktop → Settings → Resources → Memory: 8GB+
```

---

## 📚 Documentation

- **DEPLOYMENT_GUIDE.md** - Kubernetes deployment
- **IMPROVEMENTS.md** - Docker & CI/CD improvements
- **TOOLS_FRONTEND_IMPROVEMENTS.md** - New tools & UI details
- **SOUTENANCE_CHECKLIST.md** - Presentation guide

---

## 🎓 For Presentation

### Demo Scenario

1. **Open Frontend**
   ```
   http://localhost:4200
   ```
   - Show dark mode toggle
   - Navigate between pages
   - Show responsive design

2. **API Testing**
   ```bash
   curl http://localhost:3000/api/docs
   ```
   - Show Swagger documentation
   - Try sample endpoints

3. **Monitoring**
   ```
   http://localhost:3099 (Grafana)
   ```
   - Show real-time metrics
   - Display service health

4. **Logs**
   ```
   http://localhost:5601 (Kibana)
   ```
   - Show centralized logging
   - Filter by service

---

## 🚀 Next Steps

1. **Build Docker Images**
   ```bash
   docker compose build
   ```

2. **Deploy to Kubernetes**
   ```bash
   ./deploy.sh prod
   ```

3. **Monitor with Prometheus**
   - Access http://localhost:9090
   - Create custom alerts

4. **Integrate CI/CD**
   - Push to repository
   - Jenkins will build and deploy

---

## 📞 Quick Commands

```bash
# Start everything
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f [service]

# Stop everything
docker compose stop

# Clean up
docker compose down -v

# Rebuild images
docker compose build --no-cache

# Scale a service
docker compose up -d --scale user-service=3

# Execute command in container
docker compose exec gateway-backend npm run migrate

# View resource usage
docker stats
```

---

## 💡 Pro Tips

1. **Use `.env` for sensitive data** - Never commit secrets
2. **Monitor Grafana** - Set up alerts before going to production
3. **Check Kibana regularly** - Catch errors early
4. **Keep Redis clean** - Implement TTL for all cache keys
5. **Archive logs** - Use Elasticsearch index lifecycle
6. **Backup MinIO** - Use S3 to external bucket

---

**Ready to deploy? 🚀**

Questions? Check the documentation files or raise an issue!

---

**Version**: 2.1.0 | **Last Updated**: 2024-01-15 | **Status**: ✅ Production Ready
