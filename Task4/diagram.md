# Диаграмма инфраструктуры «Будущее 2.0» - Docker Deployment

### Сводная таблица: Terraform vs Ручное vs Не эмулируется

| Компонент                     | Тип ресурс а   | Управление   | Terraform-ресурс              | Комментарий                   |
|-------------------------------|----------------|:------------:|-------------------------------|-------------------------------|
| **Docker Network**            | Network        |  Terraform   | `docker_network.main`         | Bridge-сеть 172.28.0.0/16     |
| **Docker Images** (7 шт.)     | Image          |  Terraform   | `docker_image.*`              | Pull при `terraform apply`    |
| **Docker Volumes** (10 шт.)   | Volume/Disk    |  Terraform   | `docker_volume.*`             | Persistent storage для данных |
| **PostgreSQL** (4 контейнера) | Container/VM   |  Terraform   | `docker_container.pg_*`       | По одному на домен            |
| **Kafka** (3 брокера)         | Container/VM   |  Terraform   | `docker_container.kafka`      | KRaft кластер, count=3        |
| **MinIO** (1 контейнер)       | Container/VM   |  Terraform   | `docker_container.minio`      | S3-совместимое хранилище      |
| **Kong API Gateway**          | Container/VM   |  Terraform   | `docker_container.kong`       | DB-less mode                  |
| **Prometheus**                | Container/VM   |  Terraform   | `docker_container.prometheus` | Мониторинг                    |
| **Grafana**                   | Container/VM   |  Terraform   | `docker_container.grafana`    | Визуализация                  |
| **Nginx**                     | Container/VM   |  Terraform   | `docker_container.nginx`      | Reverse proxy / ALB           |
| S3 Buckets                    | Storage config |   Вручную    | —                             | Создать в MinIO Console       |
| Kong Routes                   | App config     |   Вручную    | —                             | kong.yml или Admin API        |
| Prometheus targets            | App config     |   Вручную    | —                             | prometheus.yml (mount)        |
| Grafana Dashboards            | App config     |   Вручную    | —                             | Импорт JSON / provisioning    |
| Nginx upstream                | App config     |   Вручную    | —                             | nginx.conf (mount)            |
| SQL-схемы БД                  | Data schema    |   Вручную    | —                             | SQL-миграции (Flyway/Alembic) |
| Kafka Topics                  | Data config    |   Вручную    | —                             | `kafka-topics.sh --create`    |
| GPU Node                      | Compute        |     Нет      | —                             | Не эмулируется в Docker       |
| Data Lakehouse                | Platform       |     Нет      | —                             | Databricks/Snowflake — SaaS   |
| DataHub                       | Platform       |     Нет      | —                             | Отдельное развёртывание       |
| Apache Airflow                | Platform       |     Нет      | —                             | Отдельное развёртывание       |
| Great Expectations            | Tool           |     Нет      | —                             | Отдельное развёртывание       |
