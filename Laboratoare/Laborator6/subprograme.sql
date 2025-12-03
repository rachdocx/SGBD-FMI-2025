create or replace
    FUNCTION f1 (v_id EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN NUMBER
    IS
        salariu EMPLOYEES.salary%TYPE;
    BEGIN
        SELECT SALARY
        INTO salariu
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = v_id;

        RETURN salariu;
    END f1;

DECLARE
    salariu_rezultat EMPLOYEES.salary%TYPE;
BEGIN
    salariu_rezultat := f1(100);
    DBMS_OUTPUT.PUT_LINE(salariu_rezultat);

    salariu_rezultat := f1(200);
    DBMS_OUTPUT.PUT_LINE(salariu_rezultat);
END;

/

-- 5
create or replace procedure my_p (val IN OUT NUMBER) IS
begin
    select MANAGER_ID nr
    into val
    from EMPLOYEES
    where EMPLOYEE_ID = val;
end my_p;

declare
        salariu_rezultat EMPLOYEES.salary%TYPE;
        val number;
    begin
        val := 101;
        my_p(val);
        DBMS_OUTPUT.PUT_LINE(val);
end;
/
-- oerload global nu merge, imi va rescrie a doua functie pe prima functie
declare

    procedure my_p1 (val number) is
        begin
            DBMS_OUTPUT.PUT_LINE(val);
        end my_p1;

    procedure my_p1 (val1 number, val2 number) is
        begin
            DBMS_OUTPUT.PUT_LINE(val1 + val2);
        end my_p1;

begin
    my_p1(100);
    my_p1(100, 200);
end;

CREATE OR REPLACE PROCEDURE e4(p_manager_id IN employees.employee_id%TYPE)
IS
    v_exista NUMBER;
    TYPE t_angajati IS TABLE OF employees.employee_id%TYPE;
    v_lista t_angajati := t_angajati();
    v_index number := 1;
BEGIN
    SELECT COUNT(*)
    INTO v_exista
    FROM employees
    WHERE employee_id = p_manager_id;

    IF v_exista = 0 THEN
        RETURN;
    END IF;

    SELECT employee_id
    BULK COLLECT INTO v_lista
    FROM employees
    WHERE manager_id = p_manager_id;

    WHILE v_index <= v_lista.COUNT LOOP
        DECLARE
            v_sub T_angajati;
        BEGIN
            SELECT employee_id
            BULK COLLECT INTO v_sub
            FROM employees
            WHERE manager_id = v_lista(v_index);

            IF v_sub.COUNT > 0 THEN
                v_lista := v_lista MULTISET UNION ALL v_sub;
            END IF;
        END;
        v_index := v_index + 1;
    END LOOP;

    IF v_lista.COUNT > 0 THEN
        UPDATE employees
        SET salary = salary * 1.1
        WHERE employee_id IN (SELECT * FROM TABLE(v_lista));
    END IF;

    COMMIT;
END e4;
/
--e5
CREATE OR REPLACE PROCEDURE e5_faraVechime
IS
    TYPE t_angajati IS TABLE OF employees.first_name%TYPE;
    TYPE t_salariu IS TABLE OF employees.salary%TYPE;
    TYPE t_vechime IS TABLE OF NUMBER;
    TYPE t_zile IS TABLE OF VARCHAR2(10);
    CURSOR c_departamente IS
        SELECT department_id, department_name
            FROM departments;
    v_angajati t_angajati;
    v_salariu t_salariu;
    v_vechime t_vechime;
    v_max NUMBER;
    v_zile t_zile;
BEGIN
    -- dc are angajati
    FOR dep IN c_departamente LOOP
        SELECT count(*) INTO v_max
            FROM employees
            WHERE department_id=dep.department_id;

        IF v_max=0 THEN
            DBMS_OUTPUT.PUT_LINE('depart: '||dep.department_name||' are 0 ang.');
        ELSE
            -- max intr o zi
            SELECT max(nr) INTO v_max
                FROM ( SELECT count(*) AS nr
                        FROM employees
                        WHERE department_id=dep.department_id
                        GROUP BY to_char(hire_date,'fmDay') );
            --zilele cu max de angajati
            SELECT to_char(hire_date,'fmDay') BULK COLLECT INTO v_zile
                FROM employees
                WHERE department_id=dep.department_id
                GROUP BY to_char(hire_date,'fmDay')
                HAVING count(*)=v_max;

            FOR j IN 1 .. v_zile.COUNT LOOP
                SELECT first_name, salary, trunc(months_between(sysdate, hire_date)/12) BULK COLLECT INTO v_angajati, v_salariu, v_vechime
                    FROM employees
                    WHERE department_id = dep.department_id AND to_char(hire_date,'fmDay') = v_zile(j);

                DBMS_OUTPUT.PUT_LINE('depart: '||dep.department_name||', ziua cu cele mai multe ang: '||v_zile(j));

                FOR i IN 1..v_angajati.COUNT LOOP
                    DBMS_OUTPUT.PUT_LINE('      ang: '||v_angajati(i)||', vechime: '||v_vechime(i)||' salariu: '||v_salariu(i));

                END LOOP;
            END LOOP;
        END IF;
    END LOOP;
END e5_faraVechime;

begin
    e5_faraVechime();
end;
/





