DECLARE
    CURSOR job IS
        SELECT job_id, job_title
        FROM jobs;

    CURSOR angajat(p_job_id jobs.job_id%TYPE) IS
        SELECT first_name ||' '|| last_name AS nume, salary
        FROM employees
        WHERE job_id = p_job_id;

    job_title jobs.job_title%TYPE;
    job_id jobs.job_id%TYPE;
    nume employees.first_name%TYPE;
    salariu employees.salary%TYPE;
BEGIN
    OPEN job;
    LOOP
        FETCH job INTO job_id, job_title;
        EXIT WHEN job%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(job_title);
        OPEN angajat(job_id);
        FETCH angajat INTO nume, salariu;
        IF angajat%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('nu exista angajati in' || job_title);
        ELSE
            WHILE angajat%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('     '||nume || ' salariu: ' || salariu);
                FETCH angajat INTO nume, salariu;
            END LOOP;
        END IF;
        CLOSE angajat;
    END LOOP;
    CLOSE job;
END;
/
