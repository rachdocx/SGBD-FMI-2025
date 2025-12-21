--1) VENIT
CREATE TABLE VENIT (
    id_venit NUMBER GENERATED ALWAYS AS IDENTITY,
    nume_venit VARCHAR2(100) NOT NULL,
    sursa_venit VARCHAR2(100),

    CONSTRAINT pk_venit PRIMARY KEY (id_venit)
);

--2) CLIENT
CREATE TABLE CLIENT (
    id_client NUMBER GENERATED ALWAYS AS IDENTITY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    adresa VARCHAR2(200),
    telefon VARCHAR2(20),
    email VARCHAR2(100),
    CNP VARCHAR2(13) UNIQUE NOT NULL,
    venit_lunar NUMBER(10,2),
    status_financiar VARCHAR2(50),
    status_angajare VARCHAR2(50),
    grad_indatorare NUMBER(5,2),

    CONSTRAINT pk_client PRIMARY KEY (id_client)
);

--3) ANALIST
CREATE TABLE ANALIST (
    id_analist NUMBER GENERATED ALWAYS AS IDENTITY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    adresa VARCHAR2(200),
    telefon VARCHAR2(20),
    email VARCHAR2(100),
    CNP VARCHAR2(13),
    departament VARCHAR2(50),
    suma_maxima NUMBER(12,2),

    CONSTRAINT pk_analist PRIMARY KEY (id_analist)
);

--4) ACHIZITIE
CREATE TABLE ACHIZITIE (
    id_achizitie NUMBER GENERATED ALWAYS AS IDENTITY,
    tip_achizitie VARCHAR2(50),
    procent_finantat NUMBER(5,2),
    suma_avans NUMBER(12,2),
    valoare_piata NUMBER(12,2),
    valoare_evaluare NUMBER(12,2),
    data_evaluare DATE,
    descriere VARCHAR2(255),

    CONSTRAINT pk_achizitie PRIMARY KEY (id_achizitie)
);

--5) VENIT_CLIENT
CREATE TABLE VENIT_CLIENT (
    id_venit_client NUMBER GENERATED ALWAYS AS IDENTITY,
    id_client NUMBER NOT NULL,
    id_venit NUMBER NOT NULL,
    suma_lunara NUMBER(10,2) NOT NULL,
    contract_venit VARCHAR2(50),

    CONSTRAINT pk_venit_client PRIMARY KEY (id_venit_client),

    CONSTRAINT fk_vc_client FOREIGN KEY (id_client)
    REFERENCES CLIENT(id_client)
    ON DELETE CASCADE,

    CONSTRAINT fk_vc_venit FOREIGN KEY (id_venit)
    REFERENCES VENIT(id_venit)
    ON DELETE CASCADE,

    CONSTRAINT uq_client_venit UNIQUE (id_client, id_venit)
);

--6) GARANT
CREATE TABLE GARANT (
    id_garant NUMBER GENERATED ALWAYS AS IDENTITY,
    id_client NUMBER NOT NULL,
    nume VARCHAR2(50),
    prenume VARCHAR2(50),
    adresa VARCHAR2(200),
    telefon VARCHAR2(20),
    email VARCHAR2(100),
    CNP VARCHAR2(13),
    relatie_client VARCHAR2(50),
    venit_garant NUMBER(10,2),

    CONSTRAINT pk_garant PRIMARY KEY (id_garant),

    CONSTRAINT fk_garant_client FOREIGN KEY (id_client)
    REFERENCES CLIENT(id_client)
    ON DELETE CASCADE
);

--7) CREDIT
CREATE TABLE CREDIT (
    id_credit NUMBER GENERATED ALWAYS AS IDENTITY,
    id_client NUMBER NOT NULL,
    tip_credit VARCHAR2(50) NOT NULL,
    suma_solicitata NUMBER(12,2),
    suma_aprobata NUMBER(12,2),
    data_aplicarii DATE DEFAULT SYSDATE NOT NULL,
    data_acordarii DATE,
    numar_rate NUMBER(3) NOT NULL CHECK (numar_rate >= 1),

    CONSTRAINT pk_credit PRIMARY KEY (id_credit),

    CONSTRAINT fk_credit_client FOREIGN KEY (id_client)
    REFERENCES CLIENT(id_client)
    ON DELETE CASCADE
);

--8) EVALUARE
CREATE TABLE EVALUARE (
    id_evaluare NUMBER GENERATED ALWAYS AS IDENTITY,
    id_credit NUMBER NOT NULL,
    id_analist NUMBER NOT NULL,
    id_achizitie NUMBER NOT NULL,
    data_evaluarii DATE DEFAULT SYSDATE NOT NULL,
    tip_evaluare VARCHAR2(50),
    scor_risc NUMBER(5,2),
    clasa_risc VARCHAR2(10),
    decizie VARCHAR2(50) NOT NULL,
    comentarii VARCHAR2(400),

    CONSTRAINT pk_evaluare PRIMARY KEY (id_evaluare),

    CONSTRAINT fk_eval_credit FOREIGN KEY (id_credit)
    REFERENCES CREDIT(id_credit)
    ON DELETE CASCADE,

    CONSTRAINT fk_eval_analist FOREIGN KEY (id_analist)
    REFERENCES ANALIST(id_analist)
    ON DELETE CASCADE,

    CONSTRAINT fk_eval_achizitie FOREIGN KEY (id_achizitie)
    REFERENCES ACHIZITIE(id_achizitie)
    ON DELETE CASCADE
);

--9) RATA
CREATE TABLE RATA (
    id_rata NUMBER GENERATED ALWAYS AS IDENTITY,
    id_credit NUMBER NOT NULL,
    numar_rata NUMBER(3) NOT NULL,
    data_scadenta DATE NOT NULL,
    indice_referinta VARCHAR2(50),
    marja NUMBER(5,2),
    suma_rata NUMBER(12,2) NOT NULL,
    suma_dobanda NUMBER(12,2),
    status_rata VARCHAR2(20),
    penalizari NUMBER(12,2) DEFAULT 0,

    CONSTRAINT pk_rata PRIMARY KEY (id_rata),

    CONSTRAINT fk_rata_credit FOREIGN KEY (id_credit)
    REFERENCES CREDIT(id_credit)
    ON DELETE CASCADE,

    CONSTRAINT uq_credit_rata UNIQUE (id_credit, numar_rata)
);

--10) PLATA
CREATE TABLE PLATA (
    id_plata NUMBER GENERATED ALWAYS AS IDENTITY,
    id_rata NUMBER NOT NULL,
    data_plata DATE DEFAULT SYSDATE,
    suma_platita NUMBER(12,2) NOT NULL,
    metoda_plata VARCHAR2(50),

    CONSTRAINT pk_plata PRIMARY KEY (id_plata),

    CONSTRAINT fk_plata_rata FOREIGN KEY (id_rata)
    REFERENCES RATA(id_rata)
    ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER trg_creare_rate
AFTER INSERT ON CREDIT
FOR EACH ROW
BEGIN
    FOR i IN 1 .. :NEW.numar_rate LOOP
        INSERT INTO RATA ( id_credit, numar_rata, data_scadenta, suma_rata, status_rata, penalizari) VALUES (
            :NEW.id_credit,
            i,
            ADD_MONTHS(:NEW.data_acordarii, i),
            (:NEW.suma_aprobata / :NEW.numar_rate),
            'NEPLATITA',
            0
        );
    END LOOP;
END;
/
