
terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Сеть

resource "docker_network" "main" {
  name   = var.network_name
  driver = "bridge"

  ipam_config {
    subnet  = var.network_subnet
    gateway = var.network_gateway
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "environment"
    value = var.environment
  }
}

# Образы Docker

resource "docker_image" "postgres" {
  name         = var.pg_image
  keep_locally = true
}

resource "docker_image" "kafka" {
  name         = var.kafka_image
  keep_locally = true
}

resource "docker_image" "minio" {
  name         = var.minio_image
  keep_locally = true
}

resource "docker_image" "kong" {
  name         = var.kong_image
  keep_locally = true
}

resource "docker_image" "prometheus" {
  name         = var.prometheus_image
  keep_locally = true
}

resource "docker_image" "grafana" {
  name         = var.grafana_image
  keep_locally = true
}

resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = true
}


# Хранилище
# PostgreSQL volumes
resource "docker_volume" "pg_clinic_data" {
  name = "${var.project}-pg-clinic-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "domain"
    value = "clinic"
  }
}

resource "docker_volume" "pg_fintech_data" {
  name = "${var.project}-pg-fintech-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "domain"
    value = "fintech"
  }
}

resource "docker_volume" "pg_ops_data" {
  name = "${var.project}-pg-ops-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "domain"
    value = "operations"
  }
}

resource "docker_volume" "pg_medical_data" {
  name = "${var.project}-pg-medical-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "domain"
    value = "medical"
  }
}

# Kafka volumes
resource "docker_volume" "kafka_data" {
  count = var.kafka_broker_count
  name  = "${var.project}-kafka-data-${count.index + 1}"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "kafka"
  }
}

# MinIO volume
resource "docker_volume" "minio_data" {
  name = "${var.project}-minio-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "s3"
  }
}

# Prometheus volume
resource "docker_volume" "prometheus_data" {
  name = "${var.project}-prometheus-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "monitoring"
  }
}

# Grafana volume
resource "docker_volume" "grafana_data" {
  name = "${var.project}-grafana-data"

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "monitoring"
  }
}


# PostgreSQL: Клинический домен
resource "docker_container" "pg_clinic" {
  name  = "${var.project}-pg-clinic"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=clinic",
    "POSTGRES_USER=clinic_user",
    "POSTGRES_PASSWORD=${var.pg_password}",
  ]

  ports {
    internal = 5432
    external = var.pg_clinic_port
  }

  volumes {
    volume_name    = docker_volume.pg_clinic_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U clinic_user -d clinic"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "postgresql"
  }
  labels {
    label = "domain"
    value = "clinic"
  }
}

# PostgreSQL: Финтех домен
resource "docker_container" "pg_fintech" {
  name  = "${var.project}-pg-fintech"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=fintech",
    "POSTGRES_USER=fintech_user",
    "POSTGRES_PASSWORD=${var.pg_password}",
  ]

  ports {
    internal = 5432
    external = var.pg_fintech_port
  }

  volumes {
    volume_name    = docker_volume.pg_fintech_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U fintech_user -d fintech"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "postgresql"
  }
  labels {
    label = "domain"
    value = "fintech"
  }
}

# PostgreSQL: Операционный домен
resource "docker_container" "pg_ops" {
  name  = "${var.project}-pg-ops"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=operations",
    "POSTGRES_USER=ops_user",
    "POSTGRES_PASSWORD=${var.pg_password}",
  ]

  ports {
    internal = 5432
    external = var.pg_ops_port
  }

  volumes {
    volume_name    = docker_volume.pg_ops_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ops_user -d operations"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "postgresql"
  }
  labels {
    label = "domain"
    value = "operations"
  }
}

# PostgreSQL: Домен медицинских данных
resource "docker_container" "pg_medical" {
  name  = "${var.project}-pg-medical"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=medical",
    "POSTGRES_USER=medical_user",
    "POSTGRES_PASSWORD=${var.pg_password}",
  ]

  ports {
    internal = 5432
    external = var.pg_medical_port
  }

  volumes {
    volume_name    = docker_volume.pg_medical_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U medical_user -d medical"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "postgresql"
  }
  labels {
    label = "domain"
    value = "medical"
  }
}

# Apache Kafka
resource "docker_container" "kafka" {
  count = var.kafka_broker_count
  name  = "${var.project}-kafka-${count.index + 1}"
  image = docker_image.kafka.image_id

  restart = "unless-stopped"

  env = [
    "KAFKA_NODE_ID=${count.index + 1}",
    "KAFKA_PROCESS_ROLES=broker,controller",
    "KAFKA_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093,EXTERNAL://:${19092 + count.index}",
    "KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://${var.project}-kafka-${count.index + 1}:9092,EXTERNAL://localhost:${var.kafka_base_port + count.index}",
    "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT",
    "KAFKA_CONTROLLER_QUORUM_VOTERS=1@${var.project}-kafka-1:9093,2@${var.project}-kafka-2:9093,3@${var.project}-kafka-3:9093",
    "KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER",
    "KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT",
    "CLUSTER_ID=future20-kafka-cluster-0001",
    "KAFKA_LOG_RETENTION_HOURS=168",
    "KAFKA_NUM_PARTITIONS=3",
    "KAFKA_DEFAULT_REPLICATION_FACTOR=3",
    "KAFKA_MIN_INSYNC_REPLICAS=2",
    "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=3",
  ]

  ports {
    internal = 19092 + count.index
    external = var.kafka_base_port + count.index
  }

  volumes {
    volume_name    = docker_volume.kafka_data[count.index].name
    container_path = "/bitnami/kafka"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "kafka"
  }
  labels {
    label = "broker_id"
    value = tostring(count.index + 1)
  }
}

# Minio

resource "docker_container" "minio" {
  name  = "${var.project}-minio"
  image = docker_image.minio.image_id

  restart = "unless-stopped"

  command = ["server", "/data", "--console-address", ":${var.minio_console_port}"]

  env = [
    "MINIO_ROOT_USER=${var.minio_root_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_root_password}",
  ]

  ports {
    internal = 9000
    external = var.minio_api_port
  }

  ports {
    internal = var.minio_console_port
    external = var.minio_console_port
  }

  volumes {
    volume_name    = docker_volume.minio_data.name
    container_path = "/data"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  healthcheck {
    test         = ["CMD", "mc", "ready", "local"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "s3-storage"
  }
}

# API Gateway
resource "docker_container" "kong" {
  name  = "${var.project}-kong"
  image = docker_image.kong.image_id

  restart = "unless-stopped"

  env = [
    "KONG_DATABASE=off",
    "KONG_PROXY_ACCESS_LOG=/dev/stdout",
    "KONG_ADMIN_ACCESS_LOG=/dev/stdout",
    "KONG_PROXY_ERROR_LOG=/dev/stderr",
    "KONG_ADMIN_ERROR_LOG=/dev/stderr",
    "KONG_ADMIN_LISTEN=0.0.0.0:${var.kong_admin_port}",
    "KONG_PROXY_LISTEN=0.0.0.0:${var.kong_proxy_port}, 0.0.0.0:${var.kong_proxy_ssl_port} ssl",
    "KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml",
  ]

  ports {
    internal = var.kong_proxy_port
    external = var.kong_proxy_port
  }

  ports {
    internal = var.kong_proxy_ssl_port
    external = var.kong_proxy_ssl_port
  }

  ports {
    internal = var.kong_admin_port
    external = var.kong_admin_port
  }

  networks_advanced {
    name = docker_network.main.id
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "api-gateway"
  }
}

# Monitoring
resource "docker_container" "prometheus" {
  name  = "${var.project}-prometheus"
  image = docker_image.prometheus.image_id

  restart = "unless-stopped"

  ports {
    internal = 9090
    external = var.prometheus_port
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "monitoring"
  }
}

resource "docker_container" "grafana" {
  name  = "${var.project}-grafana"
  image = docker_image.grafana.image_id

  restart = "unless-stopped"

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin",
    "GF_USERS_ALLOW_SIGN_UP=false",
  ]

  ports {
    internal = 3000
    external = var.grafana_port
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name = docker_network.main.id
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "monitoring"
  }
}

# Reverse proxy
resource "docker_container" "nginx" {
  name  = "${var.project}-nginx"
  image = docker_image.nginx.image_id

  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.nginx_http_port
  }

  networks_advanced {
    name = docker_network.main.id
  }

  labels {
    label = "project"
    value = var.project
  }
  labels {
    label = "role"
    value = "reverse-proxy"
  }
}
