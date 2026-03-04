
# ---- Сеть ----

output "network_name" {
  description = "Имя Docker-сети"
  value       = docker_network.main.name
}

output "network_id" {
  description = "ID Docker-сети"
  value       = docker_network.main.id
}

# ---- PostgreSQL ----

output "pg_clinic_connection" {
  description = "Строка подключения к PostgreSQL клинического домена"
  value       = "postgresql://clinic_user:****@localhost:${var.pg_clinic_port}/clinic"
}

output "pg_fintech_connection" {
  description = "Строка подключения к PostgreSQL финтех домена"
  value       = "postgresql://fintech_user:****@localhost:${var.pg_fintech_port}/fintech"
}

output "pg_ops_connection" {
  description = "Строка подключения к PostgreSQL операционного домена"
  value       = "postgresql://ops_user:****@localhost:${var.pg_ops_port}/operations"
}

output "pg_medical_connection" {
  description = "Строка подключения к PostgreSQL домена мед. данных"
  value       = "postgresql://medical_user:****@localhost:${var.pg_medical_port}/medical"
}

# ---- Kafka ----

output "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers для подключения"
  value       = join(",", [for i in range(var.kafka_broker_count) : "localhost:${var.kafka_base_port + i}"])
}

output "kafka_internal_bootstrap" {
  description = "Kafka bootstrap servers (внутри Docker-сети)"
  value       = join(",", [for i in range(var.kafka_broker_count) : "${var.project}-kafka-${i + 1}:9092"])
}

# ---- MinIO (S3) ----

output "minio_api_endpoint" {
  description = "MinIO S3 API endpoint"
  value       = "http://localhost:${var.minio_api_port}"
}

output "minio_console_url" {
  description = "MinIO Console URL (Web UI)"
  value       = "http://localhost:${var.minio_console_port}"
}

output "minio_credentials" {
  description = "MinIO credentials"
  value = {
    access_key = var.minio_root_user
    secret_key = "****(see terraform.tfvars)"
  }
}

output "s3_buckets" {
  description = "Список S3-бакетов (создать вручную в MinIO Console)"
  value       = var.s3_buckets
}

# ---- Kong API Gateway ----

output "kong_proxy_url" {
  description = "Kong Proxy URL (HTTP)"
  value       = "http://localhost:${var.kong_proxy_port}"
}

output "kong_admin_url" {
  description = "Kong Admin API URL"
  value       = "http://localhost:${var.kong_admin_port}"
}

# ---- Мониторинг ----

output "prometheus_url" {
  description = "Prometheus Web UI URL"
  value       = "http://localhost:${var.prometheus_port}"
}

output "grafana_url" {
  description = "Grafana Web UI URL (admin/admin)"
  value       = "http://localhost:${var.grafana_port}"
}

# ---- Nginx (ALB) ----

output "nginx_url" {
  description = "Nginx (Reverse Proxy / ALB) URL"
  value       = "http://localhost:${var.nginx_http_port}"
}

# ---- Сводка ----

output "infrastructure_summary" {
  description = "Сводка по инфраструктуре"
  value = {
    project     = var.project
    environment = var.environment
    network     = var.network_name

    containers = {
      postgresql = {
        clinic     = "${var.project}-pg-clinic (port ${var.pg_clinic_port})"
        fintech    = "${var.project}-pg-fintech (port ${var.pg_fintech_port})"
        operations = "${var.project}-pg-ops (port ${var.pg_ops_port})"
        medical    = "${var.project}-pg-medical (port ${var.pg_medical_port})"
      }
      kafka = [for i in range(var.kafka_broker_count) : "${var.project}-kafka-${i + 1} (port ${var.kafka_base_port + i})"]
      minio = "${var.project}-minio (API: ${var.minio_api_port}, Console: ${var.minio_console_port})"
      kong  = "${var.project}-kong (Proxy: ${var.kong_proxy_port}, Admin: ${var.kong_admin_port})"
      monitoring = {
        prometheus = "${var.project}-prometheus (port ${var.prometheus_port})"
        grafana    = "${var.project}-grafana (port ${var.grafana_port})"
      }
      nginx = "${var.project}-nginx (port ${var.nginx_http_port})"
    }

    urls = {
      minio_console = "http://localhost:${var.minio_console_port}"
      kong_proxy    = "http://localhost:${var.kong_proxy_port}"
      prometheus    = "http://localhost:${var.prometheus_port}"
      grafana       = "http://localhost:${var.grafana_port}"
      nginx         = "http://localhost:${var.nginx_http_port}"
    }

    total_containers = 4 + var.kafka_broker_count + 1 + 1 + 2 + 1
  }
}
