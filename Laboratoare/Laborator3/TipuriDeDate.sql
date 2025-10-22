declare
    my_var number(5) := 5;
    begin
    if my_var is null then
        DBMS_OUTPUT.PUT_LINE('a');
    else
        DBMS_OUTPUT.PUT_LINE('b');
    end if;
end;
/
declare
    TYPE my_record IS record (
        dep_info DEPARTMENTS %rowtype,
        nume varchar2(25),
        salariu number(6)
                            );
    my_var my_record;
     begin
--         select
--             e.EMPLOYEE_ID, e.FIRST_NAME || ' ' || e.LAST_NAME, e.SALARY into my_var
--             from EMPLOYEES e
--                 where e.EMPLOYEE_ID = 100;
--
--     DBMS_OUTPUT.PUT_LINE(my_var.id_angajat ||' '|| my_var.nume);

end;
/
declare
    TYPE my_list IS TABLE OF NUMBER(20) INDEX BY PLS_INTEGER;
    my_var my_list;
    begin
    select * bulk collect into my_var
    from EMPLOYEES;
    for i in my_var.first .. my_var.last loop
        DBMS_OUTPUT.PUT_LINE('buna guys');
        end loop;
--     my_var(5) := 1;
--     for i in 1 .. 10 loop
--         if my_var.EXISTS(i) then
--         DBMS_OUTPUT.PUT_LINE(my_var(i));
--         end if;
--         end loop;
    DBMS_OUTPUT.PUT_LINE('ROW');
end;