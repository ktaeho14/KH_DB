

SET SERVEROUTPUT ON;



--ORA-01422: exact fetch returns more than requested number of rows
DECLARE
        E EMPLOYEE%ROWTYPE;

BEGIN
        SELECT *
        INTO E
        FROM EMPLOYEE;
        
        DBMS_OUTPUT.PUT_LINE(E.EMP_ID);
        
END;
/

--PL/SQL 반복문--
--LOOP와 FOR, WHILE

--일반LOOP문
--[사용형식]

--LOOP
--      반복시킬 내용
--      IF 반복 종료 조건
--              EXIT [WHEN 종료조건]
--END LOOP;

DECLARE
        N INT :=1;
        
BEGIN
        LOOP
                DBMS_OUTPUT.PUT_LINE(N);
                N := N+1;
                EXIT WHEN N=6;
        
        END LOOP;
        
END;
/

--FOR 반복문--
--[사용형식]--
--FOR 카운터변수 IN [REVERSE] 시작값.. 종료값 LOOP
--          반복할 내용;
--END LOOP;

BEGIN
        FOR N IN 1..5 LOOP
                DBMS_OUTPUT.PUT_LINE(N);
            END LOOP;


END;
/

--FOR문을 반대로 실행

BEGIN
    FOR N IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;


END;
/



--구구단
BEGIN
        FOR I IN 2..9 LOOP
            FOR J IN 1..9 LOOP
                    DBMS_OUTPUT.PUT(I || '*' || J || '=' || I*J);
                    DBMS_OUTPUT.PUT('       ');
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
END;
/



BEGIN
    FOR I IN 


END;
/

--FOR LOOP 으로 INSERT 활용
CREATE TABLE TB_TEST_FOR(
                NO NUMBER,
                TEST_DATE DATE
);


BEGIN
        FOR x IN 1..10 LOOP
                INSERT INTO TB_TEST_FOR VALUES(x, SYSDATE + x);
        END LOOP;


END;
/

SELECT * FROM TB_TEST_FOR;

--실습1.
--PL/SQL의 FOR를 이용하여 EMPLOYEE 테이블에서 200~210번까지
--사원의 사원아이디, 사원명, 이메일 출력.

DECLARE
    E EMPLOYEE%ROWTYPE;
    

BEGIN
         DBMS_OUTPUT.PUT_LINE('ID          NAME            EMAIL');
         DBMS_OUTPUT.PUT_LINE('-----------------------------------');  
    
    FOR I IN 0..10 LOOP
            SELECT *
            INTO E
            FROM EMPLOYEE
            WHERE EMP_ID = 200+I;
            
            DBMS_OUTPUT.PUT_LINE(E.EMP_ID||'    '||E.EMP_NAME||'        '||E.EMAIL);
    END LOOP;


END;
/

--WHILE 문--
--제어 조건이 TRUE인 동안만 반복실행
--[사용형식]--
--WHILE 반복할조건 LOOP
--  반복할 내용;
--END LOOP;

DECLARE
    N INT := 5;
    

BEGIN
    WHILE N>0 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N-1;
    END LOOP;

END;
/


--예외처리 EXCEPTION--
--[사용형식]
--EXCEPTION
--      WHEN 예외명1 THEN 처리문장1
--      WHEN 예외명2 THEN 처리문장2
--      WHEN 예외명3 THEN 처리문장3
--      WHEN OTHERS THEN 처리문장4
--END;

--EX)
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_ID = '200';



END;
/


--
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '201'
    WHERE EMP_ID = '200';

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사원입니다');
END;
/

/*
        오라클에서 제공하는 알려진 예외 별칭들
        NO_DATA_FOUND : SELECT 한 결과가 하나도 없을 경우
        CASE_NOT_FOUND : CASE 구문 중 일치하는 결과가 없고,
                                    ELSE로 그외의 내용에 대한 처리를 하지 않았을때.
        DUP_VAL_ON_INDEX : UNIQUE 제약조건을 위배했을 경우
        INVALID_NUMBER : 문자데이터를 숫자로 변경할 떄, 변경할 수 없는 문자인 경우
        
                                     
*/


--PL/SQL 객체--
--프로시저 : PL/SQL을 미리 저장해 놓았다가
--              프로시저 명으로 호출하여 함수처럼 동작시키는 객체
/*
[사용형식]
CREATE [OR REPLACE] PROCEDURE 프로시저명(매개변수1 [IN/OUT/ IN OUT] 자료형, 매개변수 2 [MODE] 자료형 ...)
                                                                            IN : 프로시저에서 사용할 변수 값을 외부에서 받아 올때 사용하는 모드
                                                                            OUT : 프로시저를 실행한 결과를 외부로 추출할 떄 사용하는 모드
                                                                            IN OUT: IN과 OUT 두가지 기능을 선택해서 사용할 수 있는 모드


IS      --DECLARE(선언부)
                변수 선언;
                
BEGIN
        실행할 내용;
END;
/


[호출방식]
EXECUTE 프로시저명[(전달값1, 전달값2 . . .)];
EXEC         ''                 ''

[삭제]
DROP PROCEDURE 프로시저명;
*/

--테이블 생성(EMPLOYEE 복사)
CREATE TABLE EMP_TMP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_TMP;



--프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
        --변수 선언이 없더라도 생략이 불가능하다.
BEGIN
        DELETE FROM EMP_TMP;
        COMMIT;
END;
/



SELECT COUNT(*) FROM EMP_TMP;
--프로시저는 선언시 바로 실행되는 것이 아니다.
--선언 후 별도로 실행해야 한다.

--프로시저 실행
EXECUTE DEL_ALL_EMP;


SELECT COUNT(*) FROM EMP_TMP;

DROP TABLE EMP_TMP;


--매개변수 있는 프로시저--
--[IN]--
--      외부의 값을 내부로 전달하는 방식

CREATE TABLE EMP_TMP_01
AS SELECT * FROM EMPLOYEE;


--특정 이름을 가진 사원 삭제하기
CREATE OR REPLACE PROCEDURE DEL_EMP_NAME(V_NAME IN EMP_TMP_01.EMP_NAME%TYPE)
IS

BEGIN
        DELETE FROM EMP_TMP_01
        WHERE EMP_NAME LIKE V_NAME;
        DBMS_OUTPUT.PUT_LINE(V_NAME || '직원 정보가 삭제되었습니다.');
        COMMIT;
END;
/

EXEC DEL_EMP_NAME('이창진');

SELECT * FROM EMP_TMP_01 WHERE EMP_NAME LIKE '이%';
        
EXEC DEL_EMP_NAME('이%');


--[OUT]--
/*
        OUT 모드는 내부의 값을 외부로 전달하는 방식.
        외부에서도 값을 받을 수 있게 변수 객체를 생성해야 한다.
*/


CREATE OR REPLACE PROCEDURE EMP_INFO(VEMP_ID IN EMPLOYEE.EMP_ID%TYPE,
                                                VEMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                                VPHONE OUT EMPLOYEE.PHONE%TYPE)

IS
BEGIN
        SELECT EMP_NAME, PHONE
        INTO VEMP_NAME, VPHONE
        FROM EMPLOYEE
        WHERE EMP_ID = VEMP_ID;
END;
/

--변수 선언 : 프로시저를 통해 OUT되는 데이터를 담는다.
VARIABLE VAR_ENAME VARCHAR2(20);
VARIABLE VAR_PHONE VARCHAR2(20);


--출력
PRINT VAR_ENAME;

EXEC EMP_INFO(201, :VAR_ENAME, :VAR_PHONE);

PRINT VAR_ENAME;
PRINT VAR_PHONE;

--프로시저를 통해 입력받은 변수 값 자동 호출 설정
SET AUTOPRINT ON;


--FUNCTION--
--내부에서 계산된 결과를 반환하는 객체
--MAX(), MIN(), SUM(), AVG() . . . . 

/*
    CREATE [OR REPLACE] FUNCTION 함수명(매개변수 [모드] 자료형)
    RETURN 자료형 --반환할 결과의 자료형
    IS
                --변수;
    BEGIN
                --실행할 내용;
    RETURN 결과;
    END;
    /
*/

--입력한 사번에 해당하는 직원의 보너스 급여 계산하기
CREATE OR REPLACE FUNCTION BONUS_CALC(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
        V_SAL EMPLOYEE.SALARY%TYPE;
        V_BONUS EMPLOYEE.BONUS%TYPE;
        RESULT NUMBER;

BEGIN
        SELECT SALARY, NVL(BONUS,0)
        INTO V_SAL, V_BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = V_EMP_ID;
        
        RESULT :=V_SAL * V_BONUS;
        RETURN RESULT;
END;
/

SELECT EMP_NAME, SALARY, BONUS, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) >600000;


--TRIGGER--
--특정 테이블이나 뷰가 DML을 통해 데이터 변환이 일어날 떄
--그 시점을 감지하여 자동으로 동작하는 스크립.

--제품관리시스템

--제품 정보 테이블
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

--제품 입,출고 내역 테이블
CREATE TABLE PRODUCT_DETAIL(
    DCODE NUMBER PRIMARY KEY,
    PCODE NUMBER NOT NULL,
    PDATE DATE DEFAULT SYSDATE,
    AMOUNT NUMBER,
    STATUS CHAR(6) CHECK(STATUS IN('입고','출고')),
    CONSTRAINT FK_PRODUCT FOREIGN KEY(PCODE)
    REFERENCES PRODUCT
);

SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_DETAIL;

CREATE SEQUENCE SEQ_PRODUCT;
CREATE SEQUENCE SEQ_DETAIL;


--제품 등록
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL, '노트북', 'LG', 2000000, DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL,'TV','SAMSUNG',1000000,DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL,'휴대폰','Apple',1500000,DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL,'청소기','다이슨',800000,DEFAULT);

SELECT *
FROM PRODUCT;

COMMIT;

--제품 입출고 관련 재고 증감 트리거
CREATE OR REPLACE TRIGGER TRG
AFTER INSERT ON PRODUCT_DETAIL
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = '입고'
    THEN
            UPDATE PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
    
    IF :NEW.STATUS = '출고'
    THEN
        UPDATE PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
END;
/

COMMIT;

SELECT * FROM PRODUCT_DETAIL;
SELECT * FROM PRODUCT;

--입고--
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 2, SYSDATE, 100, '입고');

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 3, SYSDATE, 200, '입고');

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 4, SYSDATE, 500, '입고');

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 1, SYSDATE, 500, '입고');

--출고
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 2, SYSDATE, 50,'출고');

SELECT * FROM PRODUCT_DETAIL;
SELECT * FROM PRODUCT;

COMMIT;



























