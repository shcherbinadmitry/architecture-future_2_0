---
title: "Data Lake"
ring: assess
quadrant: platforms-and-operations
tags: [данные, хранилище]
---

## Data Lake

**Статус:** Изучаем (в контексте Data Lakehouse)

**Назначение:** Хранилище неструктурированных и полуструктурированных данных. Рассматривается как компонент Data Lakehouse.

**Оценка:**
- Чистый Data Lake (без ACID) - **не рекомендуется** (проблема «data swamp»)
- Data Lakehouse (Lake + Warehouse) - **рекомендуется** (Delta Lake / Iceberg)

**Бизнес-сценарии:**
- ️ Хранение медицинских снимков (Object Storage как часть Lakehouse)
- ️ Хранение логов и неструктурированных данных

**Решение:** Используем Data Lakehouse (Databricks/Snowflake) вместо чистого Data Lake. Это обеспечивает гибкость Lake + надёжность Warehouse.
