-- superentitatea 1. PERSOANA
CREATE TABLE PERSOANA (
    id_persoana NUMBER GENERATED ALWAYS AS IDENTITY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    data_nastere DATE NOT NULL,
    adresa VARCHAR2(200),
    telefon VARCHAR2(20),
    email VARCHAR2(100),
    CNP VARCHAR2(13) UNIQUE NOT NULL,
    CONSTRAINT pk_persoana PRIMARY KEY (id_persoana)
);

-- subentitati
    -- 1.1 CLIENT
        CREATE TABLE CLIENT (
            id_persoana NUMBER PRIMARY KEY,
            venit_lunar NUMBER(10,2) NOT NULL,
            status_financiar VARCHAR2(50) NOT NULL,
            status_angajare VARCHAR2(50) NOT NULL,
            grad_indatorare NUMBER(5,2) NOT NULL,
            CONSTRAINT fk_client_persoana FOREIGN KEY (id_persoana) REFERENCES PERSOANA(id_persoana) ON DELETE CASCADE
        );

    -- 1.2 ANALIST
        CREATE TABLE ANALIST(
            id_persoana NUMBER PRIMARY KEY,
            departament VARCHAR2(50) NOT NULL,
            suma_maxima NUMBER(12,2) NOT NULL,
            CONSTRAINT fk_analist_persoana FOREIGN KEY (id_persoana) REFERENCES PERSOANA(id_persoana) ON DELETE CASCADE
        );

    -- 1.3 GARANT
        CREATE TABLE GARANT(
            id_persoana NUMBER PRIMARY KEY,
            venit_garant NUMBER(10,2) NOT NULL,
            relatie_client VARCHAR2(50),
            CONSTRAINT fk_garant_persoana FOREIGN KEY (id_persoana) REFERENCES PERSOANA(id_persoana) ON DELETE CASCADE
        );

-- 2. VENIT_CLIENT
CREATE TABLE VENIT_CLIENT (
    id_venit NUMBER GENERATED ALWAYS AS IDENTITY,
    id_persoana NUMBER NOT NULL,
    suma_lunara NUMBER(10,2) NOT NULL,
    tip_venit VARCHAR2(50) NOT NULL,
    sursa_venit VARCHAR2(100),
    contract_venit VARCHAR2(50),
    CONSTRAINT pk_venit_client PRIMARY KEY (id_venit),
    CONSTRAINT fk_vc_persoana FOREIGN KEY (id_persoana) REFERENCES CLIENT(id_persoana)  ON DELETE CASCADE
);

-- 3. CREDIT
CREATE TABLE CREDIT(
    id_credit NUMBER GENERATED ALWAYS AS IDENTITY,
    id_persoana NUMBER NOT NULL,
    tip_credit VARCHAR2(50) NOT NULL,
    suma_solicitata NUMBER(12,2),
    suma_acordata NUMBER(12,2) NOT NULL,
    data_aplicarii DATE NOT NULL,
    data_acordare DATE NOT NULL,
    numar_rate NUMBER(3),
    CONSTRAINT pk_credit PRIMARY KEY (id_credit),
    CONSTRAINT fk_credit_persoana FOREIGN KEY (id_persoana) REFERENCES CLIENT(id_persoana) ON DELETE CASCADE,
    CONSTRAINT chk_date_credit CHECK (data_aplicarii <= data_acordare)
    --de adaugat constragneri gen data_aplicare <= data acordare
);

-- 4. RATA
CREATE TABLE RATA(
    id_rata NUMBER GENERATED ALWAYS AS IDENTITY,
    id_credit NUMBER NOT NULL,
    numar_rata NUMBER(3) NOT NULL,
    data_scadenta DATE NOT NULL,
    indice_referinta VARCHAR2(50) NOT NULL,
    marja NUMBER(5,2), --sau un float de verificat?
    suma_rata NUMBER(12,2) NOT NULL,
    suma_dobanda NUMBER(12,2),
    status_rata VARCHAR2(20),
    penalizari NUMBER(12,2),
    CONSTRAINT pk_rata PRIMARY KEY (id_rata),
    CONSTRAINT fk_rata_credit FOREIGN KEY (id_credit) REFERENCES CREDIT(id_credit) ON DELETE CASCADE
);

-- 5. PLATA
CREATE TABLE PLATA(
    id_plata NUMBER GENERATED ALWAYS AS IDENTITY,
    id_rata NUMBER NOT NULL,
    data_plata DATE,
    suma_platita NUMBER(12,2) NOT NULL,
    metoda_plata VARCHAR2(20),
    CONSTRAINT pk_plata PRIMARY KEY (id_plata),
    CONSTRAINT fk_plata_rata FOREIGN KEY (id_rata) REFERENCES RATA(id_rata) ON DELETE CASCADE

);

-- 6. ACHIZITE
CREATE TABLE ACHIZITIE(
    id_achizitie NUMBER GENERATED ALWAYS AS IDENTITY,
    tip_achizitie VARCHAR2(20),
    procent_finantat NUMBER(5,2) NOT NULL, --trb un float un procent gen
    suma_avans NUMBER(12,2) NOT NULL,
    CONSTRAINT pk_achizitie PRIMARY KEY (id_achizitie)
);

-- 7. GARANTIE
CREATE TABLE GARANTIE(
    id_garantie NUMBER GENERATED ALWAYS AS IDENTITY,
    valoare_piata NUMBER(12,2),
    valoare_evaluare NUMBER(12,2) NOT NULL,
    data_evaluare DATE,
    descriere VARCHAR2(200),
    CONSTRAINT pk_garantie PRIMARY KEY (id_garantie)
);

-- 8. ACOPERIRE
CREATE TABLE ACOPERIRE(
    id_acoperire NUMBER GENERATED ALWAYS AS IDENTITY,
    id_garantie NUMBER NOT NULL,
    id_credit NUMBER NOT NULL,
    procent_acoperire NUMBER(5,2), --imi trb un float subunitar gen
    CONSTRAINT pk_acoperire PRIMARY KEY (id_acoperire),
    CONSTRAINT fk_acoperire_garantie FOREIGN KEY (id_garantie) REFERENCES GARANTIE(id_garantie) ON DELETE CASCADE,
    CONSTRAINT fk_acoperire_credit FOREIGN KEY (id_credit) REFERENCES CREDIT(id_credit) ON DELETE CASCADE
);

-- 9. Relatia Ternara EVALUARE
CREATE TABLE EVALUARE (
    id_evaluare      NUMBER GENERATED ALWAYS AS IDENTITY,
    id_credit        NUMBER NOT NULL,
    id_analist       NUMBER NOT NULL,
    id_achizitie     NUMBER NOT NULL,
    data_evaluarii   DATE NOT NULL,
    tip_evaluare     VARCHAR2(50),
    scor_risc        NUMBER(5,2) NOT NULL,
    clasa_risc       VARCHAR2(20),
    decizie          VARCHAR2(20) NOT NULL,
    comentarii       VARCHAR2(400),
    CONSTRAINT pk_evaluare PRIMARY KEY (id_evaluare),
    CONSTRAINT fk_eval_credit FOREIGN KEY (id_credit) REFERENCES CREDIT(id_credit) ON DELETE CASCADE,
    CONSTRAINT fk_eval_analist FOREIGN KEY (id_analist) REFERENCES ANALIST(id_persoana) ON DELETE SET NULL,
    CONSTRAINT fk_eval_achizitie FOREIGN KEY (id_achizitie) REFERENCES ACHIZITIE(id_achizitie) ON DELETE CASCADE
);
