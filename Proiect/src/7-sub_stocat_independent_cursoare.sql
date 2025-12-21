CREATE OR REPLACE PROCEDURE analiza_garanti AS
    cursor c_clienti is
    select distinct c.id_client, c.nume, c.prenume
    from client c
    join garant g on c.id_client = g.id_client;

    cursor c_garanti (my_id_client number) is
    select venit_garant, LOWER(relatie_client) as relatie
    from garant
    where id_client = my_id_client;

    my_nr_garanti NUMBER;
    my_nr_valizi NUMBER;
    my_nr_nevalizi NUMBER;
    my_venit_total NUMBER;
    my_venit_max NUMBER;
    my_risc VARCHAR2(20);

begin
    for c in c_clienti loop
        my_nr_garanti := 0;
        my_nr_valizi := 0;
        my_nr_nevalizi := 0;
        my_venit_total := 0;
        my_venit_max := 0;

        for g in c_garanti(c.id_client) loop
            my_nr_garanti := my_nr_garanti + 1;

            if g.relatie not in ('sot', 'sotie', 'fiu', 'fiica', 'parinte') then
                my_nr_valizi := my_nr_valizi + 1;
                my_venit_total := my_venit_total + g.venit_garant;
                if g.venit_garant > my_venit_max then
                    my_venit_max := g.venit_garant;
                end if;
            else
                my_nr_nevalizi := my_nr_nevalizi + 1;
            end if;
        end loop;

        if(my_nr_valizi = 0) then
            my_risc := 'Risc ridicat';
        else
            if(my_venit_max <= 7000) then
                my_risc := 'Risc mediu';
            else
                my_risc := 'Risc scazut';
            end if;
        end if;

        DBMS_OUTPUT.PUT_LINE('Client: ' || c.nume || ' ' || c.prenume);
        DBMS_OUTPUT.PUT_LINE('Numar garanti: ' || my_nr_garanti);
        DBMS_OUTPUT.PUT_LINE('Garanti valizi: ' || my_nr_valizi);
        DBMS_OUTPUT.PUT_LINE('Garanti nevalizi: ' || my_nr_nevalizi);
        DBMS_OUTPUT.PUT_LINE('Venit total garanti valizi: ' || my_venit_total);
        DBMS_OUTPUT.PUT_LINE('Venit maxim garant: ' || my_venit_max);
        DBMS_OUTPUT.PUT_LINE('Clasificare risc: ' || my_risc);
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;
/
BEGIN
    analiza_garanti();
END;
/


