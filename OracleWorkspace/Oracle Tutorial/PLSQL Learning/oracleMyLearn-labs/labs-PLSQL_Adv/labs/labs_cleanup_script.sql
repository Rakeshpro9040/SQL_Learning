-- Use OE
-- Lesson 05
DROP TYPE typ_cr_card_nst FORCE;
DROP TYPE typ_cr_card FORCE;
ALTER TABLE customers DROP COLUMN credit_cards;

-- Lesson 6:
DROP TABLE review_table;

-- Lesson 10
DROP FUNCTION get_table_md RETURN CLOB;

Lesson 12:
-- Use PDB1-sys
DROP PUBLIC SYNONYM orders;
DROP PUBLIC SYNONYM order_items;
DROP CONTEXT sales_orders_ctx;