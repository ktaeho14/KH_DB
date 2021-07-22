--DROP--
--객체 자체를 제거하거나, 특정 요소를 제거할때 사용하는 명령어다.


--2.
--DROP 객체 객체명



SELECT * FROM DEPT_COPY;
--DROP (컬럼명)
ALTER TABLE DEPT_COPY
DROP (LNAME);

ALTER TABLE DEPT_COPY
DROP (DEPT_TITLE, LOCATION_ID);

--제약조건 삭제하기
CREATE TABLE CONS_TAB(
    EID CHAR(2),
    ENAME VARCHAR2(15) NOT NULL,
    AGE NUMBER NOT NULL,
    DEPT CHAR(5),
    CONSTRAINT PK_TAB PRIMARY KEY(EID),
    CONSTRAINT UK_TAB UNIQUE(ENAME),
    CONSTRAINT CK_TAB CHECK(AGE > 0),
    CONSTRAINT FK_TAB FOREIGN KEY(DEPT)
    REFERENCES DEPARTMENT ON DELETE CASCADE
);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME  = 'CONST_TAB';


--제약조건 삭제하기
ALTER TABLE CONST_TAB
DROP CONSTRAINT CK_TAB;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONST_TAB';


--제약조건 여러 개 삭제하기
ALTER TABLE CONST_TAB
DROP CONSTRAINT UK_TAB
DROP CONSTRAINT FK_TAB
DROP CONSTRAINT PK_TAB;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONST_TAB';


--NOT NULL 삭제
ALTER TABLE CONST_TAB
MODIFY (ENAME NULL, AGE NULL);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONST_TAB';

SELECT * FROM DEPT_COPY2;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY2';


ALTER TABLE DEPT_COPY2
DROP CONSTRAINT PK_DEPT_ID
DROP CONSTRAINT SYS_C007140;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY2';


--객체 삭제
DROP TABLE CONST_TAB;
DROP TABLE DEPT_COPY2;

/*
--계정 삭제 : 관리자 권한이 필요!
--DROP USER 계정명;

--------------------
--관리자 계정--
CREATE USER TEST IDENTIFIED BY TEST;

GRANT CONNECT, RESOURCE TO TEST;

DROP USER TEST;

*/


--오라클 객체--
--VIEW(뷰)--

--VIEW : SELECT를 실행한 결과 화면을 담는 객체
--조회할 SELECT 문장 자체를 저장하여
--호출할 때 마다 해당 쿼리를 실행하여 결과를 보여주는 객체.

--[사용방법]
--CREATE [OR REPLACE] VIEW 뷰이름
--AS 서브쿼리(뷰에서 확인할 SELECT 쿼리)


/*
--SYSTEM 계정에서 뷰 생성 권한 부여하기
GRANT CREATE VIEW TO KH;
REVOKE CREATE VIEW FROM KH;

*/

--ORA-01031: insufficient privileges
CREATE OR REPLACE VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;
--VIEW는 가상의 테이블이라고 생각하자

SELECT * FROM V_EMP;

CREATE OR REPLACE VIEW V_EMP (사번,이름,부서,직급)
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE;

SELECT * FROM V_EMP;

SELECT * FROM USER_VIEWS;

--실습1.
--사번, 이름, 직급명, 부서명, 근무지역을 조회하고
--그 결과를 V_RESULTTEST_EMP 라는 뷰를 만들어 뷰를 통해 그 결과를 조회

SELECT *
FROM LOCATION;

--1)서브쿼리 준비
SELECT EMP_ID, EMP_NAME, JOB_NAME,DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--2) 뷰에 대입해서 생성
CREATE OR REPLACE VIEW V_RESULTTEST_EMP (사번,이름,직급명,부서명,근무지역)
AS 
SELECT EMP_ID, EMP_NAME, JOB_NAME,DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

--3) 뷰를 통해 결과확인
SELECT *
FROM V_RESULTTEST_EMP;



--실습2.
--만들어진 VIEW를 활용하여 사번이 '205'번인 직원 정보조회
SELECT *
FROM V_RESULTTEST_EMP
WHERE 사번 = '205';

--VIEW는 SELECT 쿼리를 저장하고 있기 때문에
--원본 테이블의 값이 변경 되었을 때 뷰도 함께 변경해서 조회된다.

UPDATE EMPLOYEE
SET EMP_NAME = '정중아'
WHERE EMP_ID = '205';

SELECT * FROM V_RESULTTEST_EMP
WHERE 사번 = '205';

COMMIT;

--뷰 삭제
DROP VIEW V_RESULTTEST_EMP;

SELECT * FROM USER_VIEWS;

--뷰에는 연산 결과도 포함하여 저장 가능
--사번, 이름, 성별, 근무년수

SELECT EMP_ID,EMP_NAME, 
            DECODE(SUBSTR(EMP_NO,8,1),1,'남성','여성'),
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;


--2)
CREATE OR REPLACE VIEW V_EMP(사번, 이름, 성별, 근무년수)
AS SELECT EMP_ID,EMP_NAME, 
            DECODE(SUBSTR(EMP_NO,8,1),1,'남성','여성'),
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
            FROM EMPLOYEE;
            
            
SELECT * FROM V_EMP;


--뷰에 데이터 삽입, 수정, 삭제

CREATE OR REPLACE VIEW V_JOB
AS SELECT * FROM JOB;

SELECT * FROM V_JOB;

--뷰를 통한 데이터 추가
INSERT INTO V_JOB VALUES('J8','인턴');

SELECT * FROM V_JOB;
SELECT * FROM JOB;

--뷰를 통한 데이터 수정
UPDATE V_JOB SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

--뷰를 통한 데이터 삭제
DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;


--DML(입력, 수정, 삭제)가 안되는 경우
--1. 뷰에 정의되지 않은 컬럼값을 변경하려고 하는 경우
--2. 뷰에 포함되지 않은 컬럼중, 기본이 되는 테이블 컬럼이 NOT NULL 제약조건을 가졌을 경우
--3. 산술 연산이 포함된 컬럼인 경우
--4. JOIN을 통한 여러 테이블 정보를 가진 뷰를 사용할 경우
--5. DISTINCT를 뷰에 사용했을 경우
--6. 그룹 함수를 사용하거나, GROUP BY를 통한 결과를 가졌을 경우

--뷰에 정의되어 있지 않은 컬럼을 수정할 경우
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE FROM JOB;

SELECT * FROM V_JOB;

--ORA-00913: too many values
INSERT INTO V_JOB VALUES('J8','인턴');

--ORA-00904: "JOB_NAME": invalid identifier
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';

--산술 표현일 경우
CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY,
            (SALARY+(SALARY*NVL(BONUS,0) ) )*12 연봉
FROM EMPLOYEE;            

SELECT * FROM V_EMP_SAL;

--ORA-01733: virtual column not allowed here
INSERT INTO V_EMP_SAL
VALUES('901','정지연',300000,40000000);

COMMIT;

--JOIN을 통해서 VIEW의 정보를 수정하는 경우
CREATE OR REPLACE VIEW V_JOIN_EMP
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

SELECT *
FROM V_JOIN_EMP;

--ORA-01776: cannot modify more than one base table through a join view
INSERT INTO V_JOIN_EMP
VALUES('901','김수호','기술지원부');

COMMIT;
--데이터 삭제는 가능
DELETE FROM V_JOIN_EMP
WHERE DEPT_TITLE = '기술지원부';

SELECT * FROM V_JOIMN_EMP;
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

ROLLBACK;



--VIEW 생성 시 설정할 수 있는 옵션들
--OR REPLACE : 기존에 있던 동일한 이름의 뷰가 있을 경우 해당 뷰를 덮어씌우고,
--                    없다면 새로 만들겠다.


--FORCE / NO FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도
--                              뷰를 강제로 생성할 것인지 설정

--WITH CHECK / READ ONLY
--              CHECK : 옵션을 성정한 컬럼의 값을 바꾸지 못하게 막는 설정
--              READ ONLY : 뷰에 사용된 어떠한 컬럼도 뷰를 통해서 변경하지 못하게 막는 설정


--경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
--FORCE : 테이블이 존재하지 않더라도 뷰를 강제로 생성
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT T_CODE, T_NAME, T_CONTENT
FROM TEST_TABLE;


--ORA-00942: table or view does not exist
--NO FORCE : 테이블이 존재하지 않는 다면 뷰를 생성하지 않겠다.
CREATE OR REPLACE /*NOFORCE*/ VIEW V_EMP
AS
SELECT T_CODE, T_NAME, T_CONTENT
FROM TEST_TABLE;



--WITH CHECK : 뷰에 존재하는 컬럼을 추가하거나 수정하지 못하게 막는 옵션

CREATE OR REPLACE VIEW V_EMP
AS
SELECT * FROM EMPLOYEE
WITH CHECK OPTION;

SELECT *
FROM V_EMP;

--ORA-32575: Explicit column default is not supported for modifying views
INSERT INTO V_EMP
VALUES (819, '정현구', '101010-1234567','hg@kh.or.kr','01012344321','D1','J7',
            'S1',8000000,0.1,200,SYSDATE,NULL,DEFAULT);



COMMIT;


DELETE FROM V_EMP
WHERE EMP_ID = '200';

ROLLBACK;

--WITH READ ONLY : 데이터의 입력, 수정, 삭제 모두를 막는 옵션
CREATE OR REPLACE VIEW V_EMP
AS
SELECT * FROM EMPLOYEE
WITH READ ONLY;


--ORA-32575: Explicit column default is not supported for modifying views
INSERT INTO V_EMP
VALUES (819, '정현구', '101010-1234567','hg@kh.or.kr','01012344321','D1','J7',
            'S1',8000000,0.1,200,SYSDATE,NULL,DEFAULT);
       

--ORA-42399: cannot perform a DML operation on a read-only view            
DELETE
FROM V_EMP
WHERE EMP_ID = '200';

------------------------
--ROLE--
------------------------
--T사용자에게 여러개의 권한을 한번에 부여 할 수 있는 데이터베이스 객체

--ORACLE 설치시 제공되는 기본 ROLE
--CONNECT : 사용자가 데이터 베이스에 접속 가능하도록 하기위한 권한 있는 ROLE
--RESOURCE :  사용자가 객체(테이블, 인덱스 등)를 생성하기 위한 시스템 권한 제공되는 ROLE
--DBA : 시스템 자원을 무제한적으로 사용가능, 시스템 관리를 하기 위한 모든 권한 ROLE

--[관리자 계정]--
--DBA를 시스템 권한 확인
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'DBA';


--계정 생성
CREATE USER TEST IDENTIFIED BY TEST;
--롤 부여
GRANT CONNECT, RESOURCE TO TEST;

--SYSTEM 계정으로 ROLE 생성
CREATE ROLE EMP_ROLE;



--ROLE에 권한 부여
GRANT SELECT ON KH.EMPLOYEE TO EMP_ROLE;

--TEST 계정에 EMP_ROLE 권한 부여
GRANT EMP_ROLE TO TEST;


--세션권한
--GRANT CREATE SESSION TO TEST;


--TEST 계정에서 실행
SELECT * FROM KH.EMPLOYEE;

--권한 회수하기(관리자 계정)
REVOKE EMP_ROLE FROM TEST;










