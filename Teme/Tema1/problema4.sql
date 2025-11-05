DECLARE
    TYPE tip_coduri IS TABLE OF employees.employee_id%TYPE;
    coduri tip_coduri;
    salariuvechi employees.salary%TYPE;
    salariunou employees.salary%TYPE;
BEGIN
    SELECT employee_id
    BULK COLLECT INTO coduri
    FROM ( SELECT employee_id
        FROM employees
        WHERE commission_pct IS NULL
        ORDER BY salary)
    WHERE rownum<=5;
    FOR i IN 1 .. coduri.COUNT LOOP
        SELECT salary INTO salariuvechi
        FROM employees
        WHERE employee_id=coduri(i);
        salariunou:=salariuvechi * 1.05;
        UPDATE employees
        SET salary=salariunou
        WHERE employee_id=coduri(i);
        DBMS_OUTPUT.PUT_LINE('id angajat: ' || coduri(i) || ' ' || salariuvechi || ' ' || salariunou);
    END LOOP;
    COMMIT;
END;
/
