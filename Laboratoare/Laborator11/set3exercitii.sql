CREATE OR REPLACE TRIGGER trg_emp_check
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
DECLARE
    my_min_salary jobs.min_salary%TYPE;
    my_max_salary jobs.max_salary%TYPE;
    my_mgr NUMBER;
    my_mgr_dept employees.department_id%TYPE;
BEGIN
    SELECT min_salary, max_salary
    INTO my_min_salary, my_max_salary
    FROM jobs
    WHERE job_id = :NEW.job_id;
    IF :NEW.salary<my_min_salary OR :NEW.salary>my_max_salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'salariu invalid');
    END IF;

    IF :NEW.manager_id IS NOT NULL THEN
        SELECT department_id
        INTO my_mgr_dept
        FROM employees
        WHERE employee_id = :NEW.manager_id;

        IF my_mgr_dept != :NEW.department_id THEN
            RAISE_APPLICATION_ERROR(-20002, 'manager din alt department');
        END IF;

        my_mgr := :NEW.manager_id;

        WHILE my_mgr IS NOT NULL LOOP
            IF my_mgr = :NEW.employee_id THEN
                RAISE_APPLICATION_ERROR(-20003, 'ciclu ierarhic');
            END IF;

            SELECT manager_id
            INTO my_mgr
            FROM employees
            WHERE employee_id = my_mgr;
        END LOOP;

        IF :NEW.commission_pct IS NOT NULL THEN
            IF :NEW.department_id != my_mgr_dept THEN
                RAISE_APPLICATION_ERROR(-20004, 'department diferit');
            END IF;
        END IF;
    END IF;
END;
/
CREATE OR REPLACE PACKAGE hr_analytics_pkg AS
    FUNCTION get_department_payroll_rank(p_department_id NUMBER) RETURN NUMBER;
    PROCEDURE reassign_department(p_from NUMBER, p_to NUMBER);
    FUNCTION get_manager_salary_gap(p_manager_id NUMBER) RETURN NUMBER;
END hr_analytics_pkg;
/
CREATE OR REPLACE PACKAGE BODY hr_analytics_pkg AS
    FUNCTION get_department_payroll_rank(p_department_id NUMBER)
    RETURN NUMBER IS
        my_sum NUMBER;
        my_rank NUMBER;
    BEGIN
        SELECT SUM(salary + salary * NVL(commission_pct, 0))
        INTO my_sum
        FROM EMPLOYEES
        WHERE department_id = p_department_id;

        SELECT COUNT(*) + 1
        INTO my_rank
        FROM (
            SELECT department_id, SUM(salary+ salary*NVL(commission_pct, 0)) total
            FROM EMPLOYEES
            GROUP BY department_id
        )
        WHERE total>my_sum;
        RETURN my_rank;
    END;
    PROCEDURE reassign_department(p_from NUMBER, p_to NUMBER) IS
        my_cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO my_cnt
        FROM EMPLOYEES
        WHERE department_id = p_from;

        IF my_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20005,'departament fara angajati');
        END IF;

        UPDATE employees
        SET department_id=p_to
        WHERE department_id=p_from AND employee_id NOT IN (
              SELECT manager_id
              FROM EMPLOYEES
              WHERE manager_id IS NOT NULL
          );
    END;

    FUNCTION get_manager_salary_gap(p_manager_id NUMBER)
    RETURN NUMBER IS
        my_mgr_salary NUMBER;
        my_avg_salary NUMBER;
        my_cnt NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO my_cnt
        FROM EMPLOYEES
        WHERE manager_id=p_manager_id;

        IF my_cnt=0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'manager fara subordonati');
        END IF;

        SELECT salary
        INTO my_mgr_salary
        FROM EMPLOYEES
        WHERE employee_id=p_manager_id;

        SELECT AVG(salary)
        INTO my_avg_salary
        FROM EMPLOYEES
        WHERE manager_id=p_manager_id;
        RETURN my_mgr_salary-my_avg_salary;
    END;
END hr_analytics_pkg;
/
BEGIN
    hr_analytics_pkg.reassign_department(999, 60);
END;
/

