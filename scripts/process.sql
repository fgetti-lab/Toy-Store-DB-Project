BEGIN;

SET search_path TO sorokin_va, public;

-- Процедура обработки возврата:
-- 1) Проверяет, что товар есть в составе заказа.
-- 2) При необходимости возвращает товар на склад.
-- 3) Помечает заказ статусом RET.
CREATE OR REPLACE PROCEDURE sorokin_va.sp_process_toy_return(
    p_order_id bigint,
    p_toy_id bigint,
    p_warehouse_id bigint DEFAULT 1
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists_in_order boolean;
    v_exists_in_wh boolean;
BEGIN
    -- Проверка наличия товара в указанном заказе.
    SELECT EXISTS (
        SELECT 1
        FROM sorokin_va.toy_in_order tio
        WHERE tio.id_order = p_order_id
          AND tio.id_toy = p_toy_id
    )
    INTO v_exists_in_order;

    IF NOT v_exists_in_order THEN
        RAISE EXCEPTION 'Toy % is not found in order %', p_toy_id, p_order_id;
    END IF;

    -- Проверка, есть ли уже запись об остатке этого товара на складе.
    SELECT EXISTS (
        SELECT 1
        FROM sorokin_va.toys_in_warehouse tiw
        WHERE tiw.id_toy = p_toy_id
          AND tiw.id_warehouse = p_warehouse_id
    )
    INTO v_exists_in_wh;

    -- Если записи нет, добавляем товар на склад.
    IF NOT v_exists_in_wh THEN
        INSERT INTO sorokin_va.toys_in_warehouse (id_toy, id_warehouse)
        VALUES (p_toy_id, p_warehouse_id);
    END IF;

    -- Обновляем статус заказа: возврат обработан.
    UPDATE sorokin_va."Order"
    SET order_status = 'RET'
    WHERE id_order = p_order_id;
END;
$$;

COMMIT;
