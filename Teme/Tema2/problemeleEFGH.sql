--e
CREATE OR REPLACE PROCEDURE e(nume EMPLOYEES.LAST_NAME%TYPE, salariu EMPLOYEES.SALARY%TYPE) IS
    nr_angajati NUMBER := 0;
    my_emp_id EMPLOYEES.employee_id%TYPE;
    my_job_id EMPLOYEES.JOB_ID%TYPE;
    my_min EMPLOYEES.SALARY%TYPE;
    my_max EMPLOYEES.SALARY%TYPE;
begin
    SELECT COUNT(*)
    INTO nr_angajati
    FROM EMPLOYEES
    WHERE LOWER(last_name) = LOWER(nume);

    IF(nr_angajati = 0) THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista acest angajat');
    end if;

    IF(nr_angajati > 1) THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu acest nume');
        DBMS_OUTPUT.PUT_LINE('Angajatii sunt:');
        FOR r IN (
                  SELECT first_name || ' ' || last_name AS nume, salary
                  FROM EMPLOYEES
                  WHERE LOWER(last_name) = LOWER(nume)
            ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.nume || ' cu salariul ' || r.salary);
        END LOOP;
    end if;

    IF(nr_angajati = 1) THEN
        SELECT EMPLOYEE_ID, JOB_ID
        INTO my_emp_id, my_job_id
        FROM EMPLOYEES
        WHERE LOWER(last_name) = LOWER(nume);

        SELECT min_salary, max_salary
        INTO my_min, my_max
        FROM JOBS
        WHERE JOB_ID = my_job_id;

        IF(salariu < my_min OR salariu > my_max) THEN
            DBMS_OUTPUT.PUT_LINE('salariul nu este in intervalul corect');
        ELSE
            UPDATE EMPLOYEES
            SET SALARY = salariu
            WHERE EMPLOYEE_ID = my_emp_id;
            DBMS_OUTPUT.PUT_LINE('salariu actualizat cu succes');
        END IF;
    end if;
end;

begin
    e('Whalen', 4000);
end;
--f
CREATE OR REPLACE PROCEDURE f(my_job_id employees.job_id%TYPE) IS
    CURSOR c_angajati (c_job employees.job_id%TYPE) IS
        SELECT employee_id, first_name, last_name, salary
        FROM employees
        WHERE job_id = c_job;
BEGIN
    FOR r IN c_angajati(my_job_id) LOOP
        DBMS_OUTPUT.PUT_LINE(r.employee_id || ' ' ||  r.first_name || ' ' || r.last_name || ' '|| r.salary);
    END LOOP;
END;
/

begin
    f('SA_MAN');
end;

--g
CREATE OR REPLACE PROCEDURE g IS
    CURSOR c_joburi IS
        SELECT job_id, job_title, min_salary, max_salary
        FROM jobs;
BEGIN
    FOR r IN c_joburi LOOP
        DBMS_OUTPUT.PUT_LINE(r.job_id || ' - ' || r.job_title );
    END LOOP;
END;
/
begin
    g;
end;
--h
CREATE OR REPLACE PROCEDURE h IS
    CURSOR c_joburi IS
        SELECT job_id, job_title
        FROM jobs;
    CURSOR c_angajati_job (my_job_id jobs.job_id%TYPE) IS
        SELECT employee_id, first_name, last_name
        FROM employees
        WHERE job_id = my_job_id;
    nr NUMBER;
    nr_job NUMBER;
-- bulevardul energeticienilor nr 9-11
-- la arcca in spate
-- ketchup dulce si maioneza simpla FARA SALATRE
-- cu cardu
BEGIN
    FOR j IN c_joburi LOOP
        DBMS_OUTPUT.PUT_LINE('Job: ' || j.job_title);
        nr := 0;
        FOR a IN c_angajati_job(j.job_id) LOOP
            nr := nr + 1;
            SELECT COUNT(*)
            INTO nr_job
            FROM job_history
            WHERE employee_id = a.employee_id AND job_id = j.job_id;
            IF nr_job > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  ' || a.first_name || ' ' || a.last_name || ' - a mai avut job');
            ELSE
                DBMS_OUTPUT.PUT_LINE( '  ' || a.first_name || ' ' || a.last_name ||' - nu a mai avut job');
            END IF;
        END LOOP;
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati ptr acest job');
        END IF;
    END LOOP;
END;
/
begin
    h();
end;
rollback;