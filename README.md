# Toy-Store-DB-Project

## О проекте

Учебный проект реляционной базы данных для магазина игрушек на PostgreSQL.  
Репозиторий содержит полный SQL-набор для демонстрации в портфолио: создание схемы, заполнение тестовыми данными, представления, хранимая процедура и аналитические запросы.

## Технологии

- PostgreSQL
- SQL / PLpgSQL
- DBeaver

## Структура репозитория

- `models/`
- `models/physical_model.png` - физическая ER-модель
- `scripts/`
- `scripts/ddl_schema.sql` - DDL: создание таблиц, FK, индексов
- `scripts/dml_data.sql` - DML: тестовые данные
- `scripts/views.sql` - представления для отчетности
- `scripts/process.sql` - хранимая процедура обработки возврата
- `scripts/query.sql` - аналитические SQL-запросы

## Что реализовано

- Нормализованная схема с ключевыми сущностями:
- `client`, `employee`, `courier`, `supplier`, `toy`, `toy_categories`
- `Order`, `toy_in_order`, `payment`, `reviews`
- Складской и магазинный контур:
- `warehouse`, `toys_in_warehouse`, `toy_store`, `toy_store_toy`
- Пользователи системы:
- `system_roles`, `system_users`

## Как запустить

1. Создай пустую базу PostgreSQL.
2. Выполни `scripts/ddl_schema.sql`.
3. Выполни `scripts/dml_data.sql`.
4. Выполни `scripts/views.sql`.
5. Выполни `scripts/process.sql`.
6. Используй `scripts/query.sql` для аналитики.

## Пример запуска процедуры

```sql
CALL sorokin_va.sp_process_toy_return(1, 2, 1);
```
