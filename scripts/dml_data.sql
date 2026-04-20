BEGIN;

SET search_path TO sorokin_va, public;

-- Полная очистка таблиц перед загрузкой тестовых данных.
-- RESTART IDENTITY: сбрасывает sequence.
-- CASCADE: учитывает зависимости внешних ключей.
TRUNCATE TABLE
    sorokin_va.system_users,
    sorokin_va.system_roles,
    sorokin_va.payment,
    sorokin_va.toy_store_toy,
    sorokin_va.toys_in_warehouse,
    sorokin_va.toy_in_order,
    sorokin_va.reviews,
    sorokin_va."Order",
    sorokin_va.toy,
    sorokin_va.client,
    sorokin_va.employee,
    sorokin_va.courier,
    sorokin_va.toy_store,
    sorokin_va.warehouse,
    sorokin_va.toy_categories,
    sorokin_va.supplier,
    sorokin_va.job_title,
    sorokin_va.address
RESTART IDENTITY CASCADE;

-- Базовые справочники.
INSERT INTO sorokin_va.address (id_address, address) VALUES
    (1, 'Lenina 10, Moscow'),
    (2, 'Tverskaya 18, Moscow'),
    (3, 'Nevsky 44, Saint-Petersburg'),
    (4, 'Gagarina 5, Kazan'),
    (5, 'Mira 22, Novosibirsk');

INSERT INTO sorokin_va.job_title (id_job_title, description) VALUES
    (1, 'Sales manager'),
    (2, 'Warehouse operator'),
    (3, 'Administrator');

INSERT INTO sorokin_va.supplier (id_supplier, name_of_organizations, telephone, address) VALUES
    (1, 'ToyFactory LLC', '+79990000001', 'Industrial 7, Moscow'),
    (2, 'HappyKids Trade', '+79990000002', 'Central 12, Tula'),
    (3, 'PlayBox Import', '+79990000003', 'Logistic 3, Smolensk');

INSERT INTO sorokin_va.toy_categories (id_toys_category, name, description) VALUES
    (1, 'Dolls', 'Classic and modern dolls'),
    (2, 'Cars', 'Toy cars and tracks'),
    (3, 'Puzzles', 'Educational puzzle toys'),
    (4, 'Blocks', 'Building block sets');

-- Локации хранения и продаж.
INSERT INTO sorokin_va.warehouse (id_warehouse, telephone, address) VALUES
    (1, '+79991110001', 'Warehouse Zone A, Moscow'),
    (2, '+79991110002', 'Warehouse Zone B, Kazan');

INSERT INTO sorokin_va.toy_store (id_toy_store, phone, address) VALUES
    (1, '+79992220001', 'Arbat 15, Moscow'),
    (2, '+79992220002', 'Baumana 9, Kazan');

-- Участники бизнес-процессов.
INSERT INTO sorokin_va.courier (
    id_courier, name, surname, telephone, registration_address, date_of_employment, end_date_of_the_contract
) VALUES
    (1, 'Ivan', 'Petrov', '+79993330001', 'Moscow, South 1', '2024-01-10', '2027-01-10'),
    (2, 'Sergey', 'Volkov', '+79993330002', 'Moscow, West 8', '2024-03-05', '2027-03-05'),
    (3, 'Nikita', 'Sokolov', '+79993330003', 'Kazan, Center 2', '2025-02-01', '2028-02-01');

INSERT INTO sorokin_va.employee (
    id_employee, id_job_title, name, surname, telephone, registration_address, date_of_employment, end_date_of_the_contract
) VALUES
    (1, 1, 'Anna', 'Smirnova', '+79994440001', 1, '2023-09-01', '2027-09-01'),
    (2, 2, 'Oleg', 'Ivanov', '+79994440002', 2, '2024-04-11', '2027-04-11'),
    (3, 3, 'Maria', 'Kuznetsova', '+79994440003', 3, '2022-12-20', '2027-12-20');

INSERT INTO sorokin_va.client (id_client, telephone, surname, name, id_address) VALUES
    (1, '+79995550001', 'Orlov', 'Pavel', 4),
    (2, '+79995550002', 'Fedorova', 'Elena', 5),
    (3, '+79995550003', 'Semenov', 'Ilya', 1),
    (4, '+79995550004', 'Morozova', 'Olga', 2),
    (5, '+79995550005', 'Belov', 'Artem', 3);

-- Каталог товаров.
INSERT INTO sorokin_va.toy (
    id_toy, id_toys_category, name, id_supplier, description, price
) VALUES
    (1, 1, 'Classic Doll', 1, 'Soft body doll 30cm', 1490.00),
    (2, 2, 'Racing Car', 2, 'Metal toy racing car', 990.00),
    (3, 3, 'Animals Puzzle', 2, 'Puzzle 120 pieces', 790.00),
    (4, 4, 'City Blocks Set', 3, '120 colored blocks', 2390.00),
    (5, 2, 'Truck XL', 1, 'Large plastic truck', 1790.00),
    (6, 1, 'Princess Doll', 3, 'Dress-up doll with accessories', 1990.00);

-- Заказы и их состав.
INSERT INTO sorokin_va."Order" (
    id_order, id_employee, id_client, id_courier, id_address, sum, date_of_formation, order_status, online_order
) VALUES
    (1, 1, 1, 1, 4, 2480.00, '2026-03-10', 'NEW', 'yes'),
    (2, 1, 2, 2, 5, 2390.00, '2026-03-11', 'DONE', 'yes'),
    (3, 2, 3, 1, 1, 990.00, '2026-03-12', 'DONE', 'no'),
    (4, 3, 4, 3, 2, 3780.00, '2026-03-14', 'NEW', 'yes'),
    (5, 1, 5, 2, 3, 790.00, '2026-03-15', 'DONE', 'no');

INSERT INTO sorokin_va.toy_in_order (id_toy_in_order, id_toy, id_order) VALUES
    (1, 1, 1),
    (2, 2, 1),
    (3, 4, 2),
    (4, 2, 3),
    (5, 6, 4),
    (6, 5, 4),
    (7, 3, 5);

-- Остатки, ассортимент, оплаты и отзывы.
INSERT INTO sorokin_va.toys_in_warehouse (toy_in_warehouse_id, id_toy, id_warehouse) VALUES
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 2),
    (5, 5, 2),
    (6, 6, 2);

INSERT INTO sorokin_va.toy_store_toy (id_toy_store_toy, id_toy_store, id_toy) VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 1, 3),
    (4, 2, 4),
    (5, 2, 5),
    (6, 2, 6);

INSERT INTO sorokin_va.payment (id_payment, id_order, order_date) VALUES
    (1, 1, '2026-03-10'),
    (2, 2, '2026-03-11'),
    (3, 3, '2026-03-12'),
    (4, 4, '2026-03-14'),
    (5, 5, '2026-03-15');

INSERT INTO sorokin_va.reviews (id_reviews, id_client, id_toys, content, rating) VALUES
    (1, 1, 1, 'Good quality doll', 5),
    (2, 2, 4, 'Blocks are bright and durable', 5),
    (3, 3, 2, 'Car is nice but small', 4),
    (4, 5, 3, 'Puzzle pieces are a bit thin', 3);

-- Системные роли и пользователи приложения.
INSERT INTO sorokin_va.system_roles (role_id, role_name) VALUES
    (0, 'admin'),
    (1, 'manager'),
    (2, 'viewer');

INSERT INTO sorokin_va.system_users (user_id, username, password_hash, role_id, id_employee) VALUES
    (0, 'admin', '$2b$12$placeholder_admin_hash', 0, 3),
    (1, 'anna.manager', '$2b$12$placeholder_manager_hash', 1, 1),
    (2, 'oleg.viewer', '$2b$12$placeholder_viewer_hash', 2, 2);

-- Выравнивание sequence после ручной вставки id.
SELECT setval('sorokin_va.reviews_id_reviews_seq', COALESCE((SELECT MAX(id_reviews) FROM sorokin_va.reviews), 1), true);
SELECT setval('sorokin_va.toy_in_order_id_toy_in_order_seq', COALESCE((SELECT MAX(id_toy_in_order) FROM sorokin_va.toy_in_order), 1), true);
SELECT setval('sorokin_va.toys_in_warehouse_toy_in_warehouse_id_seq', COALESCE((SELECT MAX(toy_in_warehouse_id) FROM sorokin_va.toys_in_warehouse), 1), true);
SELECT setval('sorokin_va.toy_store_toy_id_toy_store_toy_seq', COALESCE((SELECT MAX(id_toy_store_toy) FROM sorokin_va.toy_store_toy), 1), true);
SELECT setval('sorokin_va.payment_id_payment_seq', COALESCE((SELECT MAX(id_payment) FROM sorokin_va.payment), 1), true);

SELECT setval(
    pg_get_serial_sequence('sorokin_va.system_roles', 'role_id'),
    COALESCE((SELECT MAX(role_id) FROM sorokin_va.system_roles), 1),
    true
);

SELECT setval(
    pg_get_serial_sequence('sorokin_va.system_users', 'user_id'),
    COALESCE((SELECT MAX(user_id) FROM sorokin_va.system_users), 1),
    true
);

COMMIT;
