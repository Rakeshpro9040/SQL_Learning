/*
REGEXP_LIKE:
https://www.techonthenet.com/oracle/regexp_like.php
*/
select
    REGEXP_LIKE ( expression, pattern [, match_parameter ] )
from dual;

/*
match_parameter: i - case-insensitive
*/

select * from contacts_totn;

with temp as
(
    select 'Anderson' col from dual
    union
    select 'Andersan' from dual
    union
    select 'Bndersan' from dual
    union
    select 'Andersan P' from dual
)
select *
from temp
where 
--regexp_like(col, 'Anders(o|a)n', 'i') --contains o or a in between
--regexp_like(col, '^A', 'i') --starts with A
regexp_like(col, 'n$', 'i') --ends with n
;

/*
REGEXP_INSTR:
https://www.techonthenet.com/oracle/functions/regexp_instr.php
*/

select
    REGEXP_INSTR(P_ /*SOURCE_CHAR*/,
                    P_ /*PATTERN*/,
                    P_ /*POSITION*/,
                    P_ /*OCCURRENCE*/,
                    P_ /*RETURN_OPT*/,
                    P_ /*MATCH_PARAM*/,
                    P_ /*SUBEXPR*/)
from dual;

/*
return_option: If a return_option of 0 is provided, the position of the first character of the occurrence of pattern is returned. If a return_option of 1 is provided, the position of the character after the occurrence of pattern is returned. If omitted, it defaults to 0.
*/

with temp as
(
    select 'TechOnTheNet is a great resource' col from dual
    union
    select 'The example shows how to use the REGEXP_INSTR function' from dual
    union
    select 'Anderson' col from dual
    union
    select 'Andersan' from dual
    union
    select 'TechOnTheNet' col from dual
)
select 
    col, 
    regexp_instr(col, 't', 1, 2, 0, 'i') col1, --find position of second t
    regexp_instr(col, 'ow', 1, 1, 0, 'i') col2, --find 1st occurance of 'ow'
    regexp_instr(col, 'a|e|i|o|u', 1, 2, 0, 'i') col3,
    regexp_instr(col, 'The', 1, 1, 1, 'i') col4 --display the position of 'N' after 'The' in 'TechOnTheNet'
from temp;

/*
REGEXP_REPLACE:
https://www.techonthenet.com/oracle/functions/regexp_replace.php
*/

select
REGEXP_REPLACE( string, pattern [, replacement_string [, start_position [, nth_appearance [, match_parameter ] ] ] ] )
from dual;

with temp as
(
    select 'TechOnTheNet is a great resource' col from dual
    union
    select '2, 5, and 10 are numbers in this example' from dual
)
select 
    col, 
    REGEXP_REPLACE (col, '^\S*', 'CheckYourMath') col1, --Replace the first non blank string
    REGEXP_REPLACE (col, '\d', '#') col2 --Replace each and every number with #
from temp;

/*
REGEXP_SUBSTR:
https://www.techonthenet.com/oracle/functions/regexp_substr.php
*/

select
REGEXP_SUBSTR( string, pattern [, start_position [, nth_appearance [, match_parameter [, sub_expression ] ] ] ] )
from dual;

with temp as
(
    select 'TechOnTheNet is a great resource' col from dual
    union
    select '2, 5, and 10 are numbers in this example' from dual
)
select 
    col, 
    REGEXP_SUBSTR (col, '(\S*)(\s)') col1, --Extract the first non blank string
    REGEXP_SUBSTR (col, '(\d)(\d)') col2 --Extract the first double digit number
from temp;