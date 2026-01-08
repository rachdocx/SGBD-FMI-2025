CREATE TABLE LOG_DDL (
    id_log NUMBER GENERATED ALWAYS AS IDENTITY,
    tip_operatie VARCHAR2(20) NOT NULL,
    tip_obiect VARCHAR2(20),
    nume_obiect VARCHAR2(100) NOT NULL,
    utilizator VARCHAR2(50) NOT NULL,
    data_operatie TIMESTAMP DEFAULT SYSTIMESTAMP,

    CONSTRAINT pk_log_ddl PRIMARY KEY (id_log)
);

CREATE OR REPLACE TRIGGER trg_log_ddl
AFTER ALTER OR DROP ON SCHEMA
DECLARE
    v_tip_operatie VARCHAR2(20);
    v_tip_obiect VARCHAR2(20);
    v_nume_obiect VARCHAR2(100);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    v_tip_operatie := ORA_SYSEVENT();
    v_tip_obiect := ORA_DICT_OBJ_TYPE();
    v_nume_obiect := ORA_DICT_OBJ_NAME();

    INSERT INTO LOG_DDL (tip_operatie, tip_obiect, nume_obiect, utilizator )
    VALUES (v_tip_operatie,v_tip_obiect,v_nume_obiect,USER);

    COMMIT;
    IF v_tip_obiect = 'TABLE' AND
       v_nume_obiect IN ('CLIENT', 'CREDIT', 'RATA') THEN
        DBMS_OUTPUT.PUT_LINE('Avertizare! Tabel Critic! Refaceti daca ati facut o greseala!' || v_nume_obiect ||' modificat prin ' || v_tip_operatie);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;
/
rollback;
ALTER TABLE ANALIST ADD test_col VARCHAR2(50);
ALTER TABLE CLIENT ADD test_col VARCHAR2(50);
ALTER TABLE ANALIST DROP COLUMN test_col;
ALTER TABLE CLIENT DROP COLUMN test_col;

SELECT tip_operatie, tip_obiect, nume_obiect, utilizator,
    TO_CHAR(data_operatie, 'DD-MON-YYYY HH24:MI:SS') as data
FROM LOG_DDL
ORDER BY data_operatie DESC;
