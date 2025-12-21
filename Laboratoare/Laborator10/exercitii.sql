CREATE TABLE employees_AlMeu AS SELECT * FROM employees;
/
CREATE OR REPLACE TRIGGER tr_comision1
BEFORE INSERT OR UPDATE OF commission_pct ON employees_AlMeu
FOR EACH ROW
BEGIN
    IF :NEW.salary * :NEW.commission_pct > :NEW.salary * 0.5 THEN
            RAISE_APPLICATION_ERROR(-20001, 'comisionul va duce la depasirea salariului cu 50%');
    END IF;
END;
/
UPDATE employees_AlMeu
SET commission_pct = 0.1
WHERE employee_id = 100;

ROLLBACK;

--e4
CREATE OR REPLACE TRIGGER tr_max45
FOR INSERT OR UPDATE OF department_id ON employees_AlMeu
COMPOUND TRIGGER
    TYPE t_dept IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_depts t_dept;
    nr_dep PLS_INTEGER := 0;

    before EACH ROW IS
    BEGIN
        nr_dep := nr_dep + 1;
        v_depts(nr_dep) := :NEW.department_id;
    END before EACH ROW;

    AFTER STATEMENT IS
        nr NUMBER;
    BEGIN
        FOR j IN 1 .. nr_dep LOOP
            SELECT COUNT(*) INTO nr
            FROM employees_AlMeu
            WHERE department_id = v_depts(j);
            IF nr > 45 THEN
                RAISE_APPLICATION_ERROR(-20002, 'dept nu poate avea mai mult de 45 de angajati');
            END IF;
        END LOOP;
    END AFTER STATEMENT;

END tr_max45;

/
UPDATE employees_AlMeu
SET department_id = 50
WHERE department_id != 50;

BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO employees_AlMeu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
        VALUES (1000 + i, 'test', 'test' || i, 'test' || i, SYSDATE, 'test', 10);
    END LOOP;
end;
/
ROLLBACK;
