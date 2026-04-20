BEGIN;

-- Создание отдельной схемы проекта.
CREATE SCHEMA IF NOT EXISTS sorokin_va;

-- Справочник адресов.
CREATE TABLE IF NOT EXISTS sorokin_va.address (
    id_address bigint PRIMARY KEY,
    address varchar(30) NOT NULL
);

-- Справочник должностей сотрудников.
CREATE TABLE IF NOT EXISTS sorokin_va.job_title (
    id_job_title bigint PRIMARY KEY,
    description text NOT NULL
);

-- Поставщики товаров.
CREATE TABLE IF NOT EXISTS sorokin_va.supplier (
    id_supplier bigint PRIMARY KEY,
    name_of_organizations text NOT NULL,
    telephone varchar(15) NOT NULL,
    address varchar(30) NOT NULL
);

-- Категории игрушек.
CREATE TABLE IF NOT EXISTS sorokin_va.toy_categories (
    id_toys_category bigint PRIMARY KEY,
    name varchar(15) NOT NULL,
    description text
);

-- Склады хранения.
CREATE TABLE IF NOT EXISTS sorokin_va.warehouse (
    id_warehouse bigint PRIMARY KEY,
    telephone varchar(15) NOT NULL,
    address varchar(30) NOT NULL
);

-- Розничные магазины.
CREATE TABLE IF NOT EXISTS sorokin_va.toy_store (
    id_toy_store bigint PRIMARY KEY,
    phone varchar(15) NOT NULL,
    address varchar(30) NOT NULL
);

-- Курьеры для доставки заказов.
CREATE TABLE IF NOT EXISTS sorokin_va.courier (
    id_courier bigint PRIMARY KEY,
    name varchar(15) NOT NULL,
    surname varchar(15) NOT NULL,
    telephone varchar(15) NOT NULL,
    registration_address varchar(23) NOT NULL,
    date_of_employment date NOT NULL,
    end_date_of_the_contract date NOT NULL
);

-- Сотрудники магазина.
CREATE TABLE IF NOT EXISTS sorokin_va.employee (
    id_employee bigint PRIMARY KEY,
    id_job_title bigint NOT NULL REFERENCES sorokin_va.job_title(id_job_title),
    name varchar(15) NOT NULL,
    surname varchar(15) NOT NULL,
    telephone varchar(15) NOT NULL,
    registration_address bigint NOT NULL REFERENCES sorokin_va.address(id_address),
    date_of_employment date NOT NULL,
    end_date_of_the_contract date NOT NULL
);

-- Клиенты.
CREATE TABLE IF NOT EXISTS sorokin_va.client (
    id_client bigint PRIMARY KEY,
    telephone varchar(15) NOT NULL,
    surname varchar(15) NOT NULL,
    name varchar(15) NOT NULL,
    id_address bigint NOT NULL REFERENCES sorokin_va.address(id_address)
);

-- Карточки товаров.
CREATE TABLE IF NOT EXISTS sorokin_va.toy (
    id_toy bigint PRIMARY KEY,
    id_toys_category bigint NOT NULL REFERENCES sorokin_va.toy_categories(id_toys_category),
    name text NOT NULL,
    id_supplier bigint NOT NULL REFERENCES sorokin_va.supplier(id_supplier),
    description text NOT NULL,
    price double precision NOT NULL
);

-- Индексы для ускорения типовых фильтров по товарам.
CREATE INDEX IF NOT EXISTS idx_toy_name ON sorokin_va.toy (name);
CREATE INDEX IF NOT EXISTS idx_toy_name_lower ON sorokin_va.toy ((lower(name)));
CREATE INDEX IF NOT EXISTS idx_toy_out_of_price_299 ON sorokin_va.toy (id_toy);
CREATE INDEX IF NOT EXISTS idx_toy_supplier ON sorokin_va.toy (id_supplier);

-- Заказы. Имя таблицы зарезервировано, поэтому используется "Order".
CREATE TABLE IF NOT EXISTS sorokin_va."Order" (
    id_order bigint PRIMARY KEY,
    id_employee bigint NOT NULL REFERENCES sorokin_va.employee(id_employee),
    id_client bigint NOT NULL REFERENCES sorokin_va.client(id_client),
    id_courier bigint NOT NULL REFERENCES sorokin_va.courier(id_courier),
    id_address bigint REFERENCES sorokin_va.address(id_address),
    sum double precision NOT NULL,
    date_of_formation date NOT NULL,
    order_status varchar(5) NOT NULL,
    online_order varchar(5) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_order_client ON sorokin_va."Order" (id_client);

-- Отзывы клиентов о товарах.
CREATE TABLE IF NOT EXISTS sorokin_va.reviews (
    id_reviews serial PRIMARY KEY,
    id_client bigint NOT NULL REFERENCES sorokin_va.client(id_client),
    id_toys bigint NOT NULL REFERENCES sorokin_va.toy(id_toy),
    content text NOT NULL,
    rating smallint NOT NULL
);

-- Состав заказа (позиции заказа).
CREATE TABLE IF NOT EXISTS sorokin_va.toy_in_order (
    id_toy_in_order serial PRIMARY KEY,
    id_toy bigint REFERENCES sorokin_va.toy(id_toy),
    id_order bigint REFERENCES sorokin_va."Order"(id_order)
);

CREATE INDEX IF NOT EXISTS idx_tio_order ON sorokin_va.toy_in_order (id_order);
CREATE INDEX IF NOT EXISTS idx_tio_toy ON sorokin_va.toy_in_order (id_toy);

-- Остатки товаров по складам.
CREATE TABLE IF NOT EXISTS sorokin_va.toys_in_warehouse (
    toy_in_warehouse_id serial PRIMARY KEY,
    id_toy bigint NOT NULL REFERENCES sorokin_va.toy(id_toy),
    id_warehouse bigint NOT NULL REFERENCES sorokin_va.warehouse(id_warehouse)
);

-- Ассортимент товаров по магазинам.
CREATE TABLE IF NOT EXISTS sorokin_va.toy_store_toy (
    id_toy_store_toy serial PRIMARY KEY,
    id_toy_store bigint NOT NULL REFERENCES sorokin_va.toy_store(id_toy_store),
    id_toy bigint NOT NULL REFERENCES sorokin_va.toy(id_toy)
);

-- Платежи по заказам.
CREATE TABLE IF NOT EXISTS sorokin_va.payment (
    id_payment serial PRIMARY KEY,
    id_order bigint NOT NULL REFERENCES sorokin_va."Order"(id_order),
    order_date date NOT NULL
);

-- Роли пользователей системы.
CREATE TABLE IF NOT EXISTS sorokin_va.system_roles (
    role_id integer GENERATED BY DEFAULT AS IDENTITY (MINVALUE 0 START WITH 0) PRIMARY KEY,
    role_name varchar(50) NOT NULL UNIQUE
);

-- Системные пользователи и привязка к сотрудникам.
CREATE TABLE IF NOT EXISTS sorokin_va.system_users (
    user_id integer GENERATED BY DEFAULT AS IDENTITY (MINVALUE 0 START WITH 0) PRIMARY KEY,
    username varchar(100) NOT NULL UNIQUE,
    password_hash text NOT NULL,
    role_id integer NOT NULL REFERENCES sorokin_va.system_roles(role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    id_employee bigint REFERENCES sorokin_va.employee(id_employee) ON DELETE SET NULL ON UPDATE CASCADE
);

COMMIT;
