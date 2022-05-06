/*
https://towardsdatascience.com/understanding-hierarchies-in-oracle-43f85561f3d9
https://livesql.oracle.com/apex/livesql/file/tutorial_GQMLEEPG5ARVSIFGQRD3SES92.html

Schema: OT
*/

CREATE TABLE ENTITIES(PARENT_ENTITY VARCHAR2(20 BYTE),CHILD_ENTITY VARCHAR2(20 BYTE),VAL Number);

Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values (NULL,'a',100);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('a', 'af',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('a', 'ab',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('a', 'ax',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('ab', 'abc',10);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('ab', 'abd',10);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('ab', 'abe',10);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('abe', 'abes',1);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('abe', 'abet',1);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values (NULL,'b',100);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('b', 'bg',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('b', 'bh',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('b', 'bi',50);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('bi', 'biq',10);
Insert into ENTITIES (PARENT_ENTITY, CHILD_ENTITY,VAL) Values ('bi', 'biv',10);
COMMIT;

select * from entities;

SELECT parent_entity,child_entity
FROM entities
START WITH parent_entity is NULL
CONNECT BY PRIOR child_entity= parent_entity;
--Read this one like: child_entity AS parent_entity starting from parent_entity is NULL (Top to Bottom)

SELECT parent_entity,child_entity
FROM entities
START WITH parent_entity is NULL 
CONNECT BY child_entity= PRIOR parent_entity;
--Read this one like: parent_entity AS child_entity starting from parent_entity is NULL (Bottom to Top) 
--As there are no parents for this, it results only bottom records

SELECT parent_entity,child_entity
FROM entities
START WITH  child_entity = 'abet'
CONNECT BY child_entity= PRIOR parent_entity;

--LEVEL
SELECT level, parent_entity,child_entity
FROM entities
START WITH parent_entity is NULL
CONNECT BY PRIOR child_entity= parent_entity;

--Tree Structure
SELECT LPAD(child_entity,Length(child_entity) + LEVEL * 10-10,'-') tree
FROM entities
START WITH parent_entity is NULL
CONNECT BY PRIOR child_entity= parent_entity;

--Pruning Branches
SELECT parent_entity,child_entity
FROM entities
START WITH parent_entity is NULL 
CONNECT BY PRIOR child_entity = parent_entity and child_entity !='ab';
--Here we are cutting the branch 'ab'

--NOCYCLE AND CONNECT_BY_ISCYCLE
--Below insert will create a loop in the hierarchy (circular)
--insert into entities values(‘abet’,’a’);
--Use NOCYCLE to stop the traverse once the circular hierarchy starts
--Use CONNECT_BY_ISCYCLE to identify such records

--SYS_CONNECT_BY_PATH
SELECT parent_entity,child_entity,SYS_CONNECT_BY_PATH(child_entity,'~') PATH
FROM entities
START WITH parent_entity is NULL 
CONNECT BY NOCYCLE PRIOR child_entity = parent_entity;

--connect_by_isleaf
--Leaf means which does not any childs
SELECT parent_entity,child_entity,
SYS_CONNECT_BY_PATH(child_entity,'~') PATH,
connect_by_isleaf is_leaf,
connect_by_root val --Returns val from root node
FROM entities
START WITH parent_entity is NULL 
CONNECT BY PRIOR child_entity = parent_entity;

--ORDER SIBLINGS BY
SELECT parent_entity,child_entity,val
FROM entities
START WITH parent_entity is NULL 
CONNECT BY NOCYCLE PRIOR child_entity = parent_entity
ORDER SIBLINGS BY VAL;