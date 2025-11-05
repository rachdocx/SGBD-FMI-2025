declare
    cursor my_cursor is
    select
        first_name, salary
    from employees
    where department_id = 10;
    my_name varchar2(40);
    my_salary number(10);
begin
    open my_cursor;
    loop
        fetch my_cursor into my_name, my_salary;
        exit when my_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(my_cursor%rowcount || ' ' || my_name ||' '||my_salary);
    end loop;
end;

declare
    cursor my_cursor (my_dep number) is
    select
        first_name, salary
    from employees
    where department_id = my_dep;
    my_name varchar2(40);
    my_salary number(10);
begin
    for i in 1..10 loop
        for rec in my_cursor(i) loop
            DBMS_OUTPUT.PUT_LINE(my_cursor%rowcount || ' ' || my_name ||' '||my_salary);
        end loop;
        close my_cursor;
    end loop;
end;
/
