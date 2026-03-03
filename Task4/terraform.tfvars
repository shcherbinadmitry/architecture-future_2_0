# ---- Общие ----
project     = "future20"
environment = "dev"

# ---- Сеть ----
network_name    = "future20-network"
network_subnet  = "172.28.0.0/16"
network_gateway = "172.28.0.1"

# ---- PostgreSQL ----
pg_image        = "postgres:16-alpine"
pg_password     = "ChangeMe!Str0ng"
pg_clinic_port  = 5433
pg_fintech_port = 5434
pg_ops_port     = 5435
pg_medical_port = 5436

# ---- Kafka ----
kafka_image        = "apache/kafka:3.7.0"
kafka_broker_count = 3
kafka_base_port    = 9092

# ---- MinIO (S3) ----
minio_image         = "minio/minio:latest"
minio_api_port      = 9010
minio_console_port  = 9011
minio_root_user     = "minioadmin"
minio_root_password = "minioadmin123"
s3_buckets = [
  "medical-images",
  "ml-models",
  "data-lakehouse",
  "backups"
]

# ---- Kong API Gateway ----
kong_image          = "kong:3.6"
kong_proxy_port     = 8000
kong_proxy_ssl_port = 8443
kong_admin_port     = 8001

# ---- Мониторинг ----
prometheus_image = "prom/prometheus:v2.51.0"
prometheus_port  = 9099
grafana_image    = "grafana/grafana:10.4.0"
grafana_port     = 3000

# ---- Airflow ----
airflow_image = "apache/airflow:2.8.4"
airflow_port  = 8080

# ---- Nginx (Reverse Proxy / ALB) ----
nginx_image      = "nginx:1.25-alpine"
nginx_http_port  = 80
nginx_https_port = 443

# ---- Docker volumes ----
volumes_path = "/tmp/future20-data"
