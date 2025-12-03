--1
CREATE SEQUENCE secv_employee_id
START WITH 300
INCREMENT BY 1;

CREATE OR REPLACE PACKAGE pachet_employee AS
    FUNCTION get_dept_id(p_dept_name VARCHAR2) RETURN NUMBER;
    FUNCTION get_job_id(p_job_title VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_manager_id(p_mgr_first VARCHAR2, p_mgr_last VARCHAR2) RETURN NUMBER;
    FUNCTION get_min_salary(p_dept_id NUMBER, p_job_id VARCHAR2) RETURN NUMBER;
    PROCEDURE add_employee(p_first_name VARCHAR2, p_last_name VARCHAR2, p_phone VARCHAR2, p_email VARCHAR2, p_dept_name VARCHAR2, p_job_title VARCHAR2, p_mgr_first VARCHAR2, p_mgr_last VARCHAR2);
END pachet_employee;
/

CREATE OR REPLACE PACKAGE BODY pachet_employee AS
    FUNCTION get_dept_id(p_dept_name VARCHAR2)
        RETURN NUMBER IS v_dept_id NUMBER;
    BEGIN
        SELECT department_id INTO v_dept_id
        FROM departments
        WHERE department_name = p_dept_name;
        RETURN v_dept_id;
    END;

    FUNCTION get_job_id(p_job_title VARCHAR2) RETURN VARCHAR2 IS v_job_id VARCHAR2(10);
    BEGIN
        SELECT job_id INTO v_job_id
        FROM jobs
        WHERE job_title = p_job_title;
        RETURN v_job_id;
    END;

    FUNCTION get_manager_id(p_mgr_first VARCHAR2, p_mgr_last VARCHAR2) RETURN NUMBER IS v_mgr_id NUMBER;
    BEGIN
        SELECT employee_id INTO v_mgr_id
        FROM employees
        WHERE first_name = p_mgr_first AND last_name = p_mgr_last;
        RETURN v_mgr_id;
    END;

    FUNCTION get_min_salary(p_dept_id NUMBER, p_job_id VARCHAR2) RETURN NUMBER IS v_sal NUMBER;
    BEGIN
        SELECT MIN(salary) INTO v_sal
        FROM employees
        WHERE department_id = p_dept_id AND job_id = p_job_id;
        RETURN v_sal;
    END;

    PROCEDURE add_employee(p_first_name VARCHAR2, p_last_name VARCHAR2, p_phone VARCHAR2, p_email VARCHAR2, p_dept_name VARCHAR2, p_job_title VARCHAR2, p_mgr_first VARCHAR2, p_mgr_last VARCHAR2)
    IS v_emp_id NUMBER; v_dept_id NUMBER; v_job_id VARCHAR2(10); v_mgr_id NUMBER; v_salary NUMBER;
    BEGIN
        SELECT secv_employee_id.NEXTVAL INTO v_emp_id FROM dual;
        v_dept_id := get_dept_id(p_dept_name);
        v_job_id := get_job_id(p_job_title);
        v_mgr_id := get_manager_id(p_mgr_first, p_mgr_last);
        v_salary := get_min_salary(v_dept_id, v_job_id);
--         INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
--         VALUES (v_emp_id, p_first_name, p_last_name, p_email, p_phone, SYSDATE, v_job_id, v_salary, NULL, v_mgr_id, v_dept_id);
         DBMS_OUTPUT.PUT_LINE('angajat adaugat: ' || v_emp_id);
    END;

END pachet_employee;
/
SELECT department_name FROM departments;
/
BEGIN
    pachet_employee.add_employee(p_first_name => 'Ana', p_last_name => 'Pop', p_phone => '0751234567', p_email => 'ana1@email.com', p_dept_name => 'IT', p_job_title => 'Programmer', p_mgr_first => 'Steven', p_mgr_last => 'King');
END;
/
select * from EMPLOYEES