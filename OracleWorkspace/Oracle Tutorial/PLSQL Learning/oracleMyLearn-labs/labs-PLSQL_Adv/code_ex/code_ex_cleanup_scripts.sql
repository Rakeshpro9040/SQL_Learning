-- Cleanup commands:
-- Lesson 4 
-- Use OE
drop type typ_item_nst force;
drop type typ_item force;

drop type typ_ProjectList force;
drop type typ_Project force; 

-- Lesson 6

-- Execute in OE
ALTER TABLE customers DROP (video,resume,picture);
-- Execute as SYS
DROP DIRECTORY resume_files;
DROP SEQUENCE lob_seq;

-- Execute in OE
DROP TABLE customer_profiles_sf;

-- Lesson 8
DROP TABLE bulk_bind_example_tbl;

-- Lesson 11
DROP TYPE typ_cr_card_nst FORCE;
DROP TYPE typ_cr_card FORCE;
ALTER TABLE customers DROP COLUMN credit_cards;

-- Lesson 13
DROP TABLE t;