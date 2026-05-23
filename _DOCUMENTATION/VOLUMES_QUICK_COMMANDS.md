# 🧹 Docker Volumes - Commandes Rapides

## 📊 VOIR

```bash
# Tous les volumes
docker volume ls

# Volumes nommés (production - À CONSERVER)
docker volume ls --filter "label=com.docker.compose.project"

# Volumes orphelins (À SUPPRIMER)
docker volume ls --filter "label!=com.docker.compose.project"

# Détails d'un volume
docker volume inspect devopspfe_postgres_data

# Espace disque utilisé
docker system df
docker system df -v
```

## ✅ NETTOYER (SAFE)

```bash
# Option 1: Supprimer les orphelins (700MB libérés)
docker volume prune -f

# Option 2: Supprimer tous les inutilisés (1.2GB libérés)
docker system prune --volumes -f

# Option 3: Supprimer UN volume spécifique
docker volume rm 1a0f9b95eca14964e97928dae3d5bc7cd530939ed599d813580fd72a3f4e7412
```

## ❌ DANGER (Data Loss!)

```bash
# Supprimer TOUS les volumes
docker volume prune -af

# Supprimer tout (images + conteneurs + volumes)
docker system prune -af --volumes

# Supprimer les CI volumes (attention!)
docker volume rm education-platform-ci_elasticsearch_data
docker volume rm education-platform-ci_postgres_data
docker volume rm education-platform-ci_minio_data
docker volume rm education-platform-ci_prometheus_data
docker volume rm education-platform-ci_rabbitmq_data
docker volume rm education-platform-ci_redis_data
docker volume rm education-platform-ci_grafana_data
```

## 💾 BACKUP

```bash
# Backup PostgreSQL volume
docker run --rm \
  -v devopspfe_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres_backup.tar.gz /data

# Restore PostgreSQL volume
docker run --rm \
  -v devopspfe_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres_backup.tar.gz -C /

# Backup Elasticsearch volume
docker run --rm \
  -v devopspfe_elasticsearch_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/elasticsearch_backup.tar.gz /data
```

## 🎯 RECOMMANDATION PFE

```bash
# ✅ FAIRE: Nettoyer les orphelins (SAFE)
docker volume prune -f
# Résultat: ~700MB libérés, production data preserved

# Optionnel: Supprimer les CI volumes (si pas utilisés)
# (voir commandes DANGER plus haut)
```

## 📋 Volumes À CONSERVER

```
devopspfe_elasticsearch_data   ← Logs (500MB)
devopspfe_grafana_data         ← Dashboards (50MB)
devopspfe_minio_data           ← Storage (100MB)
devopspfe_postgres_data        ← Database (200MB) 🔴 CRITICAL
devopspfe_prometheus_data      ← Metrics (50MB)
devopspfe_rabbitmq_data        ← Messages (50MB)
devopspfe_redis_data           ← Cache (10MB)
```

---

**Quick Cleanup:**
```bash
docker volume prune -f && docker system df
```

**Status de Stockage:**
```bash
docker system df
```
