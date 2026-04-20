BEGIN;

SET search_path TO sorokin_va, public;

-- Детализированный отчет по заказам и товарам:
-- кто заказал, кто обработал, кто доставил и какие товары вошли в заказ.
CREATE OR REPLACE VIEW sorokin_va.v_detailed_order_report AS
SELECT
    o.id_order,
    o.date_of_formation,
    o.order_status,
    c.id_client,
    c.surname || ' ' || c.name AS client_full_name,
    e.surname || ' ' || e.name AS employee_full_name,
    cr.surname || ' ' || cr.name AS courier_full_name,
    t.id_toy,
    t.name AS toy_name,
    t.price AS toy_price,
    tc.name AS category_name,
    s.name_of_organizations AS supplier_name
FROM sorokin_va."Order" o
JOIN sorokin_va.client c ON c.id_client = o.id_client
JOIN sorokin_va.employee e ON e.id_employee = o.id_employee
JOIN sorokin_va.courier cr ON cr.id_courier = o.id_courier
LEFT JOIN sorokin_va.toy_in_order tio ON tio.id_order = o.id_order
LEFT JOIN sorokin_va.toy t ON t.id_toy = tio.id_toy
LEFT JOIN sorokin_va.toy_categories tc ON tc.id_toys_category = t.id_toys_category
LEFT JOIN sorokin_va.supplier s ON s.id_supplier = t.id_supplier;

-- Витрина аналитики по клиентам:
-- число заказов, общие траты, средний чек, дата последнего заказа, средняя оценка.
CREATE OR REPLACE VIEW sorokin_va.v_customer_analytics AS
SELECT
    c.id_client,
    c.surname || ' ' || c.name AS client_full_name,
    COUNT(DISTINCT o.id_order) AS total_orders,
    COALESCE(SUM(o.sum), 0) AS total_spent,
    COALESCE(AVG(o.sum), 0) AS avg_order_sum,
    MAX(o.date_of_formation) AS last_order_date,
    COALESCE(AVG(r.rating), 0) AS avg_given_rating
FROM sorokin_va.client c
LEFT JOIN sorokin_va."Order" o ON o.id_client = c.id_client
LEFT JOIN sorokin_va.reviews r ON r.id_client = c.id_client
GROUP BY c.id_client, c.surname, c.name;

COMMIT;
