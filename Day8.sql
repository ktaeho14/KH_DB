--제약조건
--CHECK : 특정 범위 안의 값만 허용.
--UNIQUE : 중복 허용X
--PRIMARY KEY : (UNIQUE + NOT NULL)
--                      한 개의 테이블안에 한 개만 존재
--FOREIGN KEY : 다른 테이블의 값을 참조하는 제약조건
--NOT NULL :  NULL 값을 받을 수 없다.


------------------------------
--DML(데이터 조작 언어)
--[INSERT, UPDATE, DELETE, SELECT(DQL) --
-- [ CRUD ] --
-- C(CREATE)  : INSERT / 데이터 추가
-- R(READ)     : SELECT / 데이터 조회
-- U(UPDATE) : UPDATE / 데이터 수정
-- D(DELETE)  : DELETE / 데이터 삭제

--INSERT : 새로운 행을 특정 테이블에 추가하는 명령어.
--              실행하고 난 이후에는 테이블의 행의 개수가 증가.

--[사용형식]
--1. 특정 컬럼에 값을 추가하는 방법
-- INSERT INTO 테이블명 [ (컬럼명, ...) ]
--VALUES(값1, 값2 ...)

--2. 모든 컬럼에 값을 추가하는 방법
--INSERT INTO 테이블명
--VALUES(값1, 값2 ...)

--컬럼을 명시하여 데이터 추가하기
INSERT INTO EMPLOYEE(EMP_ID,    EMP_NAME,   EMP_NO, EMAIL,  PHONE,
                                    DEPT_CODE,  JOB_CODE,   SAL_LEVEL, SALARY,
                                    BONUS,  MANAGER_ID, HIRE_DATE,  ENT_DATE,   ENT_YN)
VALUES(500, '이창진', '800101-1234567', 'leech@kh.or.kr','01091967013',
            'D1','J7','S4',3100000,0.1,'200',SYSDATE,NULL, DEFAULT);
            
SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '이창진';


INSERT INTO EMPLOYEE
VALUES(900, '권예희', '990101-2234567','yh@kh.or.kr','01032141234',
            'D1','J7','S3',4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);
            
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '권예희';

COMMIT;

-- INSERT + SUBQUERY
-- INSERT 문에 서브쿼리를 사용하여 VALUES 대신 값을 지정하여 추가 할 수 있다.
CREATE TABLE EMP_01(
        EMP_ID NUMBER,
        EMP_NAME VARCHAR2(20),
        DEPT_TITLE VARCHAR2(40)
);

INSERT INTO EMP_01(
                        SELECT EMP_ID,EMP_NAME, DEPT_TITLE
                        FROM EMPLOYEE
                        LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

COMMIT;

--실습1
--EMPLOYEE 테이블에서 D1부서에 근무하는 직원들의
--사번, 이름, 부서코드, 입사일을 조회하여
--EMP_DEPT_D1 테이블에 추가


CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
     FROM EMPLOYEE
     WHERE 1 = 2;
     
INSERT INTO EMP_DEPT_D1(
            SELECT EMP_ID, EMP_NAME,DEPT_CODE, HIRE_DATE
            FROM EMPLOYEE
            WHERE DEPT_CODE = 'D1'
    );

--UPDATE : 해당 테이블의 데이터를 수정하는 명령어
--[사용형식]
--UPDATE 테이블명 SET 컬럼명 = 바꿀값
-- [WHERE 컬럼명 비교연사 비교값]
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

COMMIT;
--D9번 부서를 총무부 - > 전략기획부
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'
WHERE DEPT_ID = 'D9';

SELECT * FROM DEPT_COPY;

SELECT * FROM EMPLOYEE;
--실습2
--EMPLOYEE 테이블에서 주민번호가 잘못 표기되어 있는 사원들을 찾아
--사번 순으로 각각 주민번호 앞자리를
-- '621230', '631126', '850705'로 변경하는 UPDATE 구문을 작성

SELECT EMP_ID, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 5,2) >31;

UPDATE EMPLOYEE
SET EMP_NO = '621230' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 200;

UPDATE EMPLOYEE
SET EMP_NO = '631126' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 201;

UPDATE EMPLOYEE
SET EMP_NO = '850705' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 214;

SELECT EMP_ID, EMP_NO
FROM EMPLOYEE
WHERE EMP_ID IN(200,201,214);

COMMIT;

--UPDATE + SUBQUERY
--여러 행을 변경하거나, 여러 컬럼의 값을 변경하고자 할 떄
--서브쿼리를 사용하여 UPDATE를 작성할 수 있다.
--UPDATE 테이블명 SET 컬럼명 = (SUBQUERY)
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;
    
SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN('유재식','방명수');

--단일행 서브쿼리 활용
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME ='유재식'),
      BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

--실습3.
--노홍철, 전형돈 사원의 급여를
--유재식 사원과 같은 급여, 보너스로 수정하는
--UPATE 구문을 작성
--단, 다중 열 서브쿼리로 구현하여 작성
COMMIT;


SELECT EMP_NAME,SALARY, BONUS
FROM EMPLOYEE
WHERE EMP_NAME = '유재식' OR EMP_NAME = '노옹철' OR EMP_NAME = '전형돈';

UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                                    FROM EMP_SALARY
                                    WHERE EMP_NAME = '유재식')
WHERE EMP_NAME IN('노옹철', '전형돈');

SELECT *FROM EMP_SALARY
WHERE EMP_NAME IN('유재식','노옹철','전형돈');

--UPDATE 시에 변경할 값이 해당 컬럼의 제약조건을 위배하면 안된다.
--integrity constraint (KH.SYS_C007105) violated - parent key not found
--외래키 제약조건 위배
UPDATE EMPLOYEE
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D6';

--ORA-01407: cannot update ("KH"."EMPLOYEE"."EMP_ID") to NULL
--EMP_ID는 PRIMARY KEY 제약조건이 걸려있다(UNIQUE, NOT NULL제약조건)
--NOT NULL 제약조건을 위배
UPDATE EMPLOYEE
SET EMP_ID = NULL
WHERE EMP_ID = 200;


SELECT * FROM EMPLOYEE;

--ORA-00001: unique constraint (KH.SYS_C007110) violated
--UNIQUE 제약조건 위배
UPDATE EMPLOYEE
SET EMP_NO = '631126-1548654'
WHERE EMP_NAME='선동일';

--UPDATE 시에 DEFAULT값을 활용할 수 있다.
SELECT *
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

UPDATE EMPLOYEE
SET ENT_YN = DEFAULT
WHERE EMP_ID = 222;

--DELETE--
--테이블의 행을 삭제하는 명령어
--수행하고 나면 테이블의 행의 개수가 줄어든다.
--[사용형식]
--DELETE FROM 테이블명 [WHERE 조건]
--만약에 WHERE 조건을 작성하지 않았을 경우에는
--해당 테이블의 모든 정보가 삭제된다.

CREATE TABLE TEST_DELETE
AS SELECT * FROM EMPLOYEE;

SELECT * FROM TEST_DELETE;

DELETE FROM TEST_DELETE
WHERE EMP_ID = 222;

DELETE FROM TEST_DELETE;

--DELETE 역시 제약조건에 따라 지울 수 없는 컬럼이 존재한다.

--ORA-02292: integrity constraint (KH.SYS_C007105) violated - child record found
--외래키 제약조건에 위배되어 지울 수 없다.
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

--TRUNCATE : DELETE와 유사하게 테이블의 모든 정보를 삭제하는 명령어
-- ** DELETE 보다는 빠르지만, 삭제 후의 ROLLBACK(원상복구)가 불가능 하다.

SELECT * FROM EMP_SALARY;

COMMIT;

--DELETE를 통해 전체 삭제
DELETE FROM EMP_SALARY;

ROLLBACK;

TRUNCATE TABLE EMP_SALARY;

ROLLBACK;
--데이터 복구되지 않는다.

--TCL
--TRANSACTION CONTROL LANGUAGE--
--트랜젝션 제어 언어

--트랜잭션이란?
--정의 : 데이터를 처리하는 작업을 잘게 나눈 데이터. 처리의 최소 단위
--하나의 트랙잭션으로 이루어진 작업은 반드시 작업내용이
--한꺼번에 저장되거나 원상복구 되어야 한다.
--COMMMIT (작업 내역 저장/반영)/ ROLLBACK(작업 내역 취소)

/*
        COMMIT : 트랜잭션이 종료될 때 정상적으로 종료되었다면, 변경한 사항을 영구히 DB에 저장하겠다. 
        ROLLBACK : 트랜잭션이 작업중 오류가 발생했을때 작업한 내역을 취소(복구)하겠다. 
                       --가장 최근에 COMMIT한 시점으로...
        SAVEPOINT : 임시저장소명 : 현재 트랜잭션 수행 중 특정 구역을 나누어 현재까지 진행된 부분만 별도로 중간저장 하겠다.
        ROLLBACK TO 임시저장소 : 트랙잭션 작업 중 임시 저장된 SAVEPOINT를 찾아 해당 부분까지 원상복구할때 사용한다.
*/

COMMIT;

CREATE TABLE USER_TBL(
    NO NUMBER UNIQUE,
    ID VARCHAR2(20) NOT NULL UNIQUE,
    PWD VARCHAR2(30) NOT NULL
);

INSERT INTO USER_TBL
VALUES(1, 'TEST01','PASS01');

INSERT INTO USER_TBL
VALUES(2, 'TEST02','PASS02');

COMMIT; --현재까지 작업한 DML 내용을 DB에 반영

INSERT INTO USER_TBL
VALUES(3, 'TEST03','PASS03');

ROLLBACK; --가장 최근에 COMMIT했던 구간으로 되돌아 가겠다.

SELECT *
FROM USER_TBL; 

INSERT INTO USER_TBL
VALUES(3, 'TEST03','PASS03');

SAVEPOINT SP1;

INSERT INTO USER_TBL
VALUES(4, 'TEST04','PASS04');

SELECT * FROM USER_TBL;

ROLLBACK TO SP1;

SELECT * FROM USER_TBL;

ROLLBACK;

SELECT * FROM USER_TBL;

--DDL(CREATE, ALTER, DROP)--
--CREATE : 데이터 베이스의 객체를 생성하는 DDL
--데이터 베이스로 만들 수 있는 객체
--USER, TABLE, INDEX, VIEW, SEQUENCE, PROCEDURE . . . . . . . .

--ALTER : 생성한 객체를 수정할 때
--DROP : 생성한 객체를 삭제할 떄

--ALTER--
DROP TABLE DEPT_COPY;

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

--DEPT_COPY에 컬럼 추가하기
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(20) );

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY
DROP COLUMN LNAME; 

SELECT * FROM DEPT_COPY;

--컬럼에 기본값을 적용하여 추가하기
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(20) DEFAULT '한국');

SELECT * FROM DEPT_COPY;

--컬럼에 제약조건 추가하기
DROP TABLE DEPT_COPY2;

CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

SELECT * FROM DEPT_COPY2;

--DEPT_COPY2에
--DEPT_ID 에는 기본키 제약조건
--DEPT_TITLE에는 고유값
--LNAME에는 필수입력사항
--에 대한 제약조건 설정하기

ALTER TABLE DEPT_COPY2
ADD CONSTRAINT PK_DEPT_CP2 PRIMARY KEY(DEPT_ID);

ALTER TABLE DEPT_COPY2
ADD CONSTRAINT UK_DEPT_TITLE UNIQUE(DEPT_TITLE);

ALTER TABLE DEPT_COPY2
MODIFY LNAME CONSTRAINT NN_DEPT_LNAME NOT NULL;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY2';

SELECT * FROM DEPT_COPY2;


--ORA-12899: value too large for column "KH"."DEPT_COPY2"."DEPT_ID" (actual: 3, maximum: 2)
INSERT INTO DEPT_COPY2
VALUES('D10', '교육부', 'L1', DEFAULT);

DESC DEPT_COPY2;

--컬럼의 자료형 수정하기
ALTER TABLE DEPT_COPY2
MODIFY DEPT_ID CHAR(3);

ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME CHAR(20);

DESC DEPT_COPY2;

--크기를 줄일때 들어있던 값을 확인해야 한다.
--ORA-01441: cannot decrease column length because some value is too big
--01441. 00000 -  "cannot decrease column length because some value is too big"
  
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(3);

--기본값 추가하기
ALTER TABLE DEPT_COPY2
MODIFY LNAME VARCHAR2(20) DEFAULT '한국' ;

INSERT INTO DEPT_COPY2
VALUES('D10', '교육부', 'L1', DEFAULT);

SELECT *
FROM DEPT_COPY2;

--LNAME 컬럼 기본값 변경하기
ALTER TABLE DEPT_COPY2
MODIFY LNAME DEFAULT '미국';

INSERT INTO DEPT_COPY2
VALUES('D11','개발팀','L1',DEFAULT);

SELECT *
FROM DEPT_COPY2;

--컬럼의 이름 변경
ALTER TABLE DEPT_COPY2
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--테이블 이름 변경
ALTER TABLE DEPT_COPY2
RENAME TO DEPT_COPY_SECOND;

--테이블 이름 확인 
SELECT * FROM DEPT_COPY_SECOND;
SELECT * FROM DEPT_COPY2;

--제약조건 이름 변경하기
ALTER TABLE DEPT_COPY_SECOND
RENAME CONSTRAINT PK_DEPT_CP2 TO PK_DEPT_ID;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY_SECOND';


--테이블 이름 한정으로
--RENAME 을 짧게 줄여 작성 가능
RENAME DEPT_COPY_SECOND TO DEPT_COPY2;

--컬럼 삭제하기
COMMIT;

ALTER TABLE DEPT_COPY2
DROP COLUMN LNAME;

SELECT * FROM DEPT_COPY2;

ROLLBACK;

SELECT * FROM DEPT_COPY2;
--DDL 사용시 (ALTER) 자동 커밋되어버리기때문에 생각하고 사용하자.


--
ALTER TABLE DEPT_COPY2
DROP COLUMN LOCATION_ID;

ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_NAME;

--ORA-12983 : cannot drop all columns in a table
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID;





