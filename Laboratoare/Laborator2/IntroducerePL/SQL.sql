DECLARE
    V_NUMBER NUMBER(10):= 2;
    V_NUMBER2 NUMBER(4):= 3;
    V_NUMBER3 NUMBER(2);
begin
    V_NUMBER3 := V_NUMBER + V_NUMBER2;
    DBMS_OUTPUT.PUT_LINE(V_NUMBER3);
end;
/
DECLARE
    NUME_VAR EMPLOYEES.FIRST_NAME%TYPE;
    NUME_VAR2 EMPLOYEES%rowtype;
BEGIN
    NUME_VAR2.EMPLOYEE_ID := 'ASD';
end;
/
DECLARE
    V_NUMAR NUMBER(10) := 2;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_NUMAR);
        V_NUMAR := V_NUMAR +1;
        EXIT WHEN V_NUMAR = 4;
    end loop;
end;
/
DECLARE
    V_NUMAR NUMBER(10):=3;
BEGIN
    WHILE V_NUMAR <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(V_NUMAR);
        V_NUMAR := V_NUMAR +1;
        end loop;
end;
/
DECLARE
    I NUMBER(10);
BEGIN
    FOR I IN REVERSE 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        end loop;
end;
/
DECLARE
    V_NUMAR NUMBER(10);
BEGIN
    V_NUMAR :=4;
    GOTO ETICHETA;
    V_NUMAR :=5;
    <<ETICHETA>>
    DBMS_OUTPUT.PUT_LINE(V_NUMAR);
end;
/
<<PRINCIPAL>>
DECLARE
    V_NUMAR NUMBER(10);
BEGIN
    <<SECUNDAR>>
    DECLARE
    V_NUMAR2 NUMBER(10):=5;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(V_NUMAR + V_NUMAR2);
    end;
end;

/
DECLARE
    v_numar NUMBER := 10;
    v_text  VARCHAR2(20) := 'Local';
BEGIN
    DECLARE
        v_numar NUMBER := 1;
    BEGIN
        v_numar := v_numar + 2;
        v_text := v_text || ' sub-bloc';
    END;

    DBMS_OUTPUT.PUT_LINE(v_numar);
    DBMS_OUTPUT.PUT_LINE(v_text);
END;
/
DECLARE
      v_numar NUMBER := 10;
BEGIN
        IF v_numar = 10 THEN
               GOTO eticheta1;
      ELSE
               GOTO eticheta;
      END IF;

        DECLARE
              v_text VARCHAR2(20) := 'Salut';
      BEGIN
              <<eticheta>>
              DBMS_OUTPUT.PUT_LINE(v_text);
        END;

        <<eticheta1>>
        DBMS_OUTPUT.PUT_LINE('Numar: ' || v_numar);
END;
/
DECLARE
    v_numar NUMBER := 0;
BEGIN
    LOOP
        v_numar := v_numar + 1;
        EXIT WHEN v_numar > 5;
        v_numar := v_numar + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Rezultat: ' || v_numar);
END;