# ---- Общие ----
variable "project" {
  description = "Название проекта (используется как префикс)"
  type        = string
  default     = "future20"
}

variable "environment" {
  description = "Окружение (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ---- Сеть ----

variable "network_name" {
  description = "Имя Docker-сети"
  type        = string
  default     = "future20-network"
}

variable "network_subnet" {
  description = "CIDR подсети Docker-сети"
  type        = string
  default     = "172.28.0.0/16"
}

variable "network_gateway" {
  description = "Gateway Docker-сети"
  type        = string
  default     = "172.28.0.1"
}

# ---- PostgreSQL ----

variable "pg_image" {
  description = "Docker-образ PostgreSQL"
  type        = string
  default     = "postgres:16-alpine"
}

variable "pg_password" {
  description = "Пароль для PostgreSQL (все инстансы)"
  type        = string
  sensitive   = true
  default     = "ChangeMe!Str0ng"
}

variable "pg_clinic_port" {
  description = "Внешний порт PostgreSQL клинического домена"
  type        = number
  default     = 5433
}

variable "pg_fintech_port" {
  description = "Внешний порт PostgreSQL финтех домена"
  type        = number
  default     = 5434
}

variable "pg_ops_port" {
  description = "Внешний порт PostgreSQL операционного домена"
  type        = number
  default     = 5435
}

variable "pg_medical_port" {
  description = "Внешний порт PostgreSQL домена мед. данных"
  type        = number
  default     = 5436
}

# ---- Kafka ----

variable "kafka_image" {
  description = "Docker-образ Kafka (KRaft mode)"
  type        = string
  default     = "bitnami/kafka:3.7"
}

variable "kafka_broker_count" {
  description = "Количество Kafka брокеров"
  type        = number
  default     = 3
}

variable "kafka_base_port" {
  description = "Базовый внешний порт для Kafka брокеров (9092, 9093, 9094...)"
  type        = number
  default     = 9092
}

# ---- MinIO (S3-совместимое хранилище) ----

variable "minio_image" {
  description = "Docker-образ MinIO"
  type        = string
  default     = "minio/minio:latest"
}

variable "minio_api_port" {
  description = "Внешний порт MinIO API (S3)"
  type        = number
  default     = 9000
}

variable "minio_console_port" {
  description = "Внешний порт MinIO Console (UI)"
  type        = number
  default     = 9001
}

variable "minio_root_user" {
  description = "MinIO root user"
  type        = string
  default     = "minioadmin"
}

variable "minio_root_password" {
  description = "MinIO root password"
  type        = string
  sensitive   = true
  default     = "minioadmin123"
}

variable "s3_buckets" {
  description = "Список S3-бакетов для создания"
  type        = list(string)
  default = [
    "medical-images",
    "ml-models",
    "data-lakehouse",
    "backups"
  ]
}

# ---- Kong API Gateway ----

variable "kong_image" {
  description = "Docker-образ Kong"
  type        = string
  default     = "kong:3.6"
}

variable "kong_proxy_port" {
  description = "Внешний порт Kong Proxy (HTTP)"
  type        = number
  default     = 8000
}

variable "kong_proxy_ssl_port" {
  description = "Внешний порт Kong Proxy (HTTPS)"
  type        = number
  default     = 8443
}

variable "kong_admin_port" {
  description = "Внешний порт Kong Admin API"
  type        = number
  default     = 8001
}

# ---- Мониторинг ----

variable "prometheus_image" {
  description = "Docker-образ Prometheus"
  type        = string
  default     = "prom/prometheus:v2.51.0"
}

variable "prometheus_port" {
  description = "Внешний порт Prometheus"
  type        = number
  default     = 9090
}

variable "grafana_image" {
  description = "Docker-образ Grafana"
  type        = string
  default     = "grafana/grafana:10.4.0"
}

variable "grafana_port" {
  description = "Внешний порт Grafana"
  type        = number
  default     = 3000
}

# ---- Airflow ----

variable "airflow_image" {
  description = "Docker-образ Apache Airflow"
  type        = string
  default     = "apache/airflow:2.8.4"
}

variable "airflow_port" {
  description = "Внешний порт Airflow Webserver"
  type        = number
  default     = 8080
}

# ---- Nginx (Reverse Proxy / ALB) ----

variable "nginx_image" {
  description = "Docker-образ Nginx (reverse proxy)"
  type        = string
  default     = "nginx:1.25-alpine"
}

variable "nginx_http_port" {
  description = "Внешний HTTP порт Nginx"
  type        = number
  default     = 80
}

variable "nginx_https_port" {
  description = "Внешний HTTPS порт Nginx"
  type        = number
  default     = 443
}

# ---- Docker volumes base path ----

variable "volumes_path" {
  description = "Базовый путь для Docker volumes на хосте"
  type        = string
  default     = "/tmp/future20-data"
}
