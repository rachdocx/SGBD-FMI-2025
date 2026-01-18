CREATE OR REPLACE PROCEDURE validare_credit (p_id_client CLIENT.id_client%TYPE, p_id_credit CREDIT.id_credit%TYPE) IS
    v_venit_total NUMBER;
    v_grad_indatorare CLIENT.grad_indatorare%TYPE;
    v_decizie EVALUARE.decizie%TYPE;
    v_suma_credit CREDIT.SUMA_SOLICITATA%TYPE;
    v_venit_minim NUMBER;

    venit_insuficient EXCEPTION;
    credit_neaprobat EXCEPTION;
    grad_prea_mare EXCEPTION;
BEGIN

    --am schimbat logica query-ului, initial era gresita
    SELECT SUM(vc.suma_lunara), c.grad_indatorare, e.decizie, cr.SUMA_SOLICITATA
    INTO v_venit_total, v_grad_indatorare, v_decizie, v_suma_credit
    FROM CLIENT c
    JOIN VENIT_CLIENT vc ON c.id_client = vc.id_client
    JOIN VENIT v ON vc.id_venit = v.id_venit
    JOIN CREDIT cr ON cr.id_client = c.id_client
    JOIN EVALUARE e ON e.id_credit = cr.id_credit
    WHERE c.id_client = p_id_client AND cr.id_credit = p_id_credit AND e.id_evaluare = (SELECT MAX(id_evaluare)
                                                                                        FROM EVALUARE
                                                                                        WHERE id_credit = p_id_credit)
    GROUP BY c.grad_indatorare, e.decizie, cr.SUMA_SOLICITATA;

    v_venit_minim := v_suma_credit * 0.05;

    IF v_venit_total < v_venit_minim THEN
        RAISE venit_insuficient;
    END IF;

    IF LOWER(v_decizie) != 'aprobat' THEN
        RAISE credit_neaprobat;
    END IF;

    IF v_grad_indatorare > 40 THEN
        RAISE grad_prea_mare;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Credit VALID');

EXCEPTION
    WHEN venit_insuficient THEN
        DBMS_OUTPUT.PUT_LINE('Venit insuficient: necesar minim = ' || v_venit_minim || ', venit total = ' || v_venit_total);
    WHEN credit_neaprobat THEN
        DBMS_OUTPUT.PUT_LINE('Creditul nu este aprobat');
    WHEN grad_prea_mare THEN
        DBMS_OUTPUT.PUT_LINE('Grad de indatorare prea mare');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Creditul nu exista sau nu a fost evaluat');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Date inconsistente: mai multe evaluari gasite');
END;
/
--credit valid
BEGIN
    validare_credit(1, 1);
END;
/
--venit insuficient
BEGIN
    validare_credit(3, 9);
END;
/
--grad indatorare prea mare
BEGIN
    validare_credit(6, 10);
END;
/
--no data found
BEGIN
    validare_credit(999, 1);
END;
/
--too many rows
BEGIN
    validare_credit(1, 1);
END;