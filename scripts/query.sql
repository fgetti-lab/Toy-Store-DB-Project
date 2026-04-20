SET search_path TO sorokin_va, public;

-- 1. Топ клиентов по сумме заказов.
-- Показывает клиентов с наибольшей выручкой для магазина.
SELECT
    c.id_client,
    c.surname || ' ' || c.name AS client_full_name,
    COUNT(o.id_order) AS orders_count,
    SUM(o.sum) AS total_spent
FROM sorokin_va.client c
JOIN sorokin_va."Order" o ON o.id_client = c.id_client
GROUP BY c.id_client, c.surname, c.name
ORDER BY total_spent DESC;

-- 2. Продажи по категориям игрушек.
-- Позволяет оценить самые прибыльные товарные категории.
SELECT
    tc.name AS category_name,
    COUNT(tio.id_toy_in_order) AS sold_items,
    SUM(t.price) AS category_revenue
FROM sorokin_va.toy_in_order tio
JOIN sorokin_va.toy t ON t.id_toy = tio.id_toy
JOIN sorokin_va.toy_categories tc ON tc.id_toys_category = t.id_toys_category
GROUP BY tc.name
ORDER BY category_revenue DESC;

-- 3. Средний рейтинг по каждой игрушке.
-- Показывает качество восприятия товара клиентами.
SELECT
    t.id_toy,
    t.name AS toy_name,
    ROUND(AVG(r.rating)::numeric, 2) AS avg_rating,
    COUNT(r.id_reviews) AS reviews_count
FROM sorokin_va.toy t
LEFT JOIN sorokin_va.reviews r ON r.id_toys = t.id_toy
GROUP BY t.id_toy, t.name
ORDER BY avg_rating DESC NULLS LAST, reviews_count DESC;

-- 4. Эффективность сотрудников по обработанным заказам.
-- Помогает сравнить нагрузку и вклад сотрудников в продажи.
SELECT
    e.id_employee,
    e.surname || ' ' || e.name AS employee_full_name,
    COUNT(o.id_order) AS orders_processed,
    SUM(o.sum) AS total_order_sum
FROM sorokin_va.employee e
LEFT JOIN sorokin_va."Order" o ON o.id_employee = e.id_employee
GROUP BY e.id_employee, e.surname, e.name
ORDER BY orders_processed DESC, total_order_sum DESC NULLS LAST;

-- 5. Товары без отзывов.
-- Используется для выявления позиций, которым не хватает обратной связи.
SELECT
    t.id_toy,
    t.name,
    t.price
FROM sorokin_va.toy t
LEFT JOIN sorokin_va.reviews r ON r.id_toys = t.id_toy
WHERE r.id_reviews IS NULL
ORDER BY t.name;
