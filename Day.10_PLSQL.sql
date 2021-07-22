--PL/SQL--
--( PROCEDURAL LANGUAGE EXTENSION TO SQL)
--SQL에서 확장된 형태의 스크립트 언어
--오라클 자체에서 내장된 절차적 언어
--기존 SQL의 단점을 극복하기 위해
--변수의 정의, 조건처리, 반복처리, 예외처리 등을 지원

--PL/SQL의 구조
--선언부, 실행부, 예외처리부
--  선언부 : DECLARE, 변수나 상수를 선언하는 부분
--  실행부 : BEGIN, 제어문, 반복문, 함수정의 등을 작성하는 부분
--  예외처리부 : EXCEPTION, 예외 발생 시 처리할 내용을 작성하는 부분



--뷰: SELECT 문을 저장해서 필요할때마다 사용, 가상테이블
--프로시저 : PL/SQL 문을 저장해서 사용, 함수


--실행부를 사용해서 간단한 문장 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
    --PUT_LINE 이라는 프로시저를 이용해 호출.
END;
/
--화면에 작성한 출력문이 보이도록 설정하기
--기본값 OFF, 
SET SERVEROUTPUT ON;

--변수의 선언과 초기화, 변수값 출력
--[1] 일반변수를 사용
DECLARE
    vid NUMBER;
    
BEGIN
        SELECT EMP_ID
        INTO vid --변수에 조회한값을 담자.
        FROM EMPLOYEE
        WHERE EMP_NAME = '이창진';
        
        DBMS_OUTPUT.PUT_LINE('ID='|| vid);
        
EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data!!');

END;
/



DECLARE
    empno NUMBER(4);
    empname VARCHAR2(10);
    num NUMBER(4) :=6*5;    
BEGIN
--2. 변수에 값 대입(실행부)
--변수명 := 값;
empno:=1001;
empname :='이승준';

    DBMS_OUTPUT.PUT_LINE(empno || '                    ' ||empname);
    DBMS_OUTPUT.PUT_LINE('num='|| num);
END;
/


--[2]레퍼런스 변수
-- (1) %TYPE : 한 컬럼의 자료형을 받아 올 때 사용하는 자료형 타입.
DECLARE
        EMP_ID EMPLOYEE.EMP_ID%TYPE;
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
        SALARY EMPLOYEE.SALARY%TYPE;


BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMP_ID, EMP_NAME, SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '이창진';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID: ' ||EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME: ' ||EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('SALARY: ' || SALARY);


END;
/

-- (2)%ROWTYPE : 한 테이블의 모든 컬럼의 자료형을 참조할 때 사용하는 타입
--          특정 테이블의 컬럼 개수나 데이터 형식을 몰라도 지정 가능
--          SELECT 문장으로 행을 검색할 때 유리함.
DECLARE
    MYROW EMPLOYEE%ROWTYPE;


BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO MYROW.EMP_ID , MYROW.EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_NAME = '이창진';
    
    DBMS_OUTPUT.PUT_LINE(MYROW.EMP_ID || ',' || MYROW.EMP_NAME);

END;
/

-- *와 ROWTYPE변수를 이용해 한 행을 통째로 담기

DECLARE
    MYROW EMPLOYEE%ROWTYPE;

BEGIN
        SELECT *
        INTO MYROW
        FROM EMPLOYEE
        WHERE EMP_NAME = '이창진';
        
        
        DBMS_OUTPUT.PUT_LINE(MYROW.EMP_ID || ',' || MYROW.EMP_NAME || ',' 
                                            || MYROW.DEPT_CODE || ', ' || MYROW.JOB_CODE);



END;
/




--IF 문 --
--1. IF ~ THEN END IF 문
/*
        IF 조건 THEN 
            조건을 만족할 경우 처리구문;
        END IF;
*/

BEGIN
        IF 1=1 THEN
                DBMS_OUTPUT.PUT_LINE('1 이네');
        
        END IF;
END;
/


--2. IF ~THEN ~ ELSE ~ END IF
/*
        IF 조건 THEN
            조건을 만족할 경우 처리 구문;
        ELSE
            조건을 만족하지 않을 경우 처리 구문;
        END IF;
*/

--사원코드가 208인 사원의
-- 사번, 이름 부서명, 직급명, 소속 값 출력
--이때, 소속값은 J1>=대표, 그외에는 일반직원으로 출력

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    JOB_NAME JOB.JOB_NAME%TYPE;
    EMP_TEAM VARCHAR2(20);

BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
    INTO EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '208';

    IF JOB_CODE = 'J1' THEN 
            EMP_TEAM := '대표';
    ELSE EMP_TEAM := '일반직원';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름: ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서: ' || DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급: ' || JOB_NAME);
    DBMS_OUTPUT.PUT_LINE('소속: ' || EMP_TEAM);
    
END;
/

--3. IF ~ THEN ~ ELSIF ~ THEN ~ELSE ~ END IF
-- ELSE IF가아닌 ELSIF임.

--위 예제에서 J2인 경우, 소속을 '임원진'이라고 출력


DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    JOB_NAME JOB.JOB_NAME%TYPE;
    EMP_TEAM VARCHAR2(20);

BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
    INTO EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, JOB_NAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '203';

    IF JOB_CODE = 'J1' THEN EMP_TEAM := '대표';
    ELSIF JOB_CODE ='J2' THEN EMP_TEAM :='임원진';
    ELSIF JOB_CODE ='J7' THEN EMP_TEAM :='말단';
    ELSE EMP_TEAM := '일반직원';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름: ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서: ' || DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급: ' || JOB_NAME);
    DBMS_OUTPUT.PUT_LINE('소속: ' || EMP_TEAM);
    
END;
/


--4. CASE
--CASE ~ END CASE;
/*
CASE
        WHEN 표현식1 THEN 실행문1;
        WHEN 표현식 2THEN 실행문2;
        ELSE 기본실행문3;
END CASE;
*/

DECLARE
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    EMP_TEAM VARCHAR2(15);
BEGIN
    SELECT JOB_CODE
    INTO JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_ID = '208';
    
    CASE
        WHEN JOB_CODE='J1' THEN EMP_TEAM:= '대표';
        WHEN JOB_CODE='J2' THEN EMP_TEAM:= '임원진';
        ELSE EMP_TEAM:='일반직원';
    END CASE;
    
  
    DBMS_OUTPUT.PUT_LINE('직급: ' || JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('소속: ' || EMP_TEAM);
END;
/


--211사원의 급여에 따라 등급을 나누어 출력하도록 하시오
--그때 출력 값은 사번,이름,급여,급여등급을 출력하시오 (CASE 문으로 출력하시오)
--0만원 ~99만원 : F
--100만원 ~199만원 : E
--200만원 ~ 299만원 : D
--300만원 ~399만원 : C
--400만원 ~ 499만원 : B





DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(15);


BEGIN
    SELECT EMP_ID,EMP_NAME,SALARY
    INTO EMP_ID,EMP_NAME,SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '211';
    
    CASE 
        WHEN SALARY<=4990000 AND SALARY>=4000000  THEN SGRADE := 'B';
        WHEN SALARY<=3990000 AND SALARY>=3000000 THEN SGRADE:='C';
        WHEN SALARY<=2990000 AND SALARY>=2000000 THEN SGRADE:='D';
        WHEN SALARY<=1990000 AND SALARY>=1000000 THEN SGRADE:='E';
        WHEN SALARY<=990000 AND SALARY>=0 THEN SGRADE := 'F';
        
   
    
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('사번: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명: ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여: ' || SALARY);
    DBMS_OUTPUT.PUT_LINE('사원번호가211인 사원의 등급: ' || SGRADE);


END;
/







DECLARE
        E EMPLOYEE%ROWTYPE;
        SGRADE VARCHAR2(20);



BEGIN
        SELECT *
        INTO E
        FROM EMPLOYEE
        WHERE EMP_ID = '211';
        
        
        
        CASE TRUNC(E.SALARY / 1000000)
            WHEN 0 THEN SGRADE:='F';
            WHEN 1 THEN SGRADE:='E';
            WHEN 2 THEN SGRADE:='D';
            WHEN 3 THEN SGRADE:='C';
            WHEN 4 THEN SGRADE:='B';
            ELSE SGRADE:='A';
        
        

        END CASE;
        
        DBMS_OUTPUT.PUT_LINE('사번: ' || E.EMP_ID);
        DBMS_OUTPUT.PUT_LINE('이름: ' || E.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('급여: ' || E.SALARY);
        DBMS_OUTPUT.PUT_LINE('급여등급 : ' || SGRADE);
END;
/

SET SERVEROUT ON;
