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

    nr_ang_job NUMBER;
    total_salariu_job NUMBER;

    total_angajati NUMBER := 0;
    total_salarii NUMBER := 0;
BEGIN
    OPEN job;
    LOOP
        FETCH job INTO job_id, job_title;
        EXIT WHEN job%notfound;
        nr_ang_job := 0;
        total_salariu_job := 0;
        OPEN angajat(job_id);
        FETCH angajat INTO nume, salariu;
        IF angajat%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('nu exista');
        ELSE
            WHILE angajat%FOUND LOOP
                nr_ang_job := nr_ang_job + 1;
                total_salariu_job := total_salariu_job + salariu;
                FETCH angajat INTO nume, salariu;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(job_title || ' ' || nr_ang_job||' ' ||total_salariu_job);
            total_angajati := total_angajati + nr_ang_job;
            total_salarii := total_salarii + total_salariu_job;
        END IF;
        CLOSE angajat;
    END LOOP;
    CLOSE job;
    DBMS_OUTPUT.PUT_LINE('nr tot angajati: ' || total_angajati);
    DBMS_OUTPUT.PUT_LINE('val tot salarii: ' || total_salarii);
END;
/
