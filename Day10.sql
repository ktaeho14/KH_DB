--SEQUENCE :  시퀀스 --
--1,2,3,4,5, . . . . . 의 형식으로
--숫자를 자동으로 카운트 하는 객체


/*

    CREATE SEQUENCE 시퀀스명 
    [INCREMENT BY 숫자] : 다음값에 대한 증감 수치, 생략시 1씩 증가
                    --INCREMENT BY 5 --> 5씩 증가
                    --INCREMENT BY -5 --> 5씩 감소
    [START WITH 숫자] : 시작값, 생략하면 1부터.
    [MAXVALUE 숫자  | NOMAXVALUE] : 발생 시킬 값의 최대값 설정
    [MINVALUE 숫자 | NOMINVALUE] : 발생시킬 값의 최소값 설정
    [CYCLE | NOCYCLE] : 값의 순환 여부(1~100 . . ~ . . 1~100)
    [CACHE 바이트 크기 | NOCACHE] : 값을 미리 구해놓고 다음 값을 반영 할때 까지 활용하는 설정
                                            --기본값 20BYTE
*/


CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;


SELECT SEQ_EMPID.NEXTVAL FROM DUAL; --300
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; --305
SELECT SEQ_EMPID.NEXTVAL FROM DUAL; --310

--ORA-088004 : sequence SEQ_EMPID.NEXTVAL exceeds MAXVALUE and cannot be instantiated

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

--시퀀스 설정 변경하기
--시퀀스 변경 시에 초기값은 설정할 수 없다.
--
ALTER SEQUENCE SEQ_EMPID
--START WITH 315
MAXVALUE 400
NOCYCLE
NOCACHE;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL; --315

--시퀀스 삭제하기
DROP SEQUENCE SEQ_EMPID;


--시퀀스를 활용하여 데이터 추가하기
CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

SELECT *
FROM USER_SEQUENCES;



--데이터 추가
--현재 시퀀스가 300
INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '정현구','121212-1234567','hg@kh.or.kr','01012345678',
            'D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);


SELECT *
FROM EMPLOYEE
WHERE EMP_NAME ='정현구';

--실습1.
--D9 부서에 J7 직급의 사원 4명을
--시퀀스를 활용하여 추가하시오.

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '김수호4','951218-1000003','ktaeho14@hanmail.com','01091967016',
            'D9','J7','S1',5000000,0.2,201,SYSDATE,NULL,DEFAULT);


SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';


--옵션 CYCLE // CACHE
--CYCLE : 시퀀스의 값이 최소값 OR 최대값에 도달했을 때 다시
--          반대의 값부터 시작하는 옵션


CREATE SEQUENCE SEQ_CYCLE
START WITH 200
INCREMENT BY 10
MAXVALUE 230
MINVALUE 15
CYCLE
NOCACHE;

SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --200
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --210
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --220
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --230최대값!
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --15
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; --25

-- CACHE / NOCACHE
-- CACHE : 컴퓨터가 다음값에 대한 연산들을 그때 그때 수행하지 않고
--              미리 계산해 놓는것
--NOCACHE : 컴퓨터가 수행할 값을 그때 그때 처리하는 것

DROP SEQUENCE SEQ_CACHE;
CREATE SEQUENCE SEQ_CACHE
START WITH 100
INCREMENT BY 1
CACHE 20
NOCYCLE;


SELECT SEQ_CACHE.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES;


--ORACLE--
--DBMS(ORACLE) :  데이터를 효율적으로 관리하기 위한 시스템

--DDL : 데이터 정의 언어
-- CREATE, ALTER, DROP


--DBMS 객체 : USER, TABLE VIE, SEQUENCE. . . .

--DML : 데이터 조작 언어
--CRUD
--    CREATE : INSERT
--    READ : SELECT
--    UPDATE : UPDATE
--    DELETE : DELETE

--SELECT
--
-- 5. SELECT ~
-- 1. FROM ~
-- 2. WHERE ~
-- 3. GROUP BY ~
-- 4. HAVING ~
-- 6. ORDER BY ~

--다른테이블, 다른결과와 합칠때--
--SET OPERATOR
--UNION, UNOIN ALL, MINUS, INTERSECT

--JOIN
--INNER JOIN : 두 개 이상의 테이블에서 같은 값끼리 묶어서
--                    RESULT SET을 만드는 조인방식
--OUTER JOIN : 서로 다른 값도 포함하기 위해서 사용한다.
--LEFT, RIGHT, FULL (오라클은 FULL 안된다.)

--TABLE
--저장된 데이터를 직사각형 표의 형태로 표현하여 관리하는
--데이터 베이스 객체.

--VIEW
--조회한 SELECT 쿼리를 저장하여, 필요할 때마다 가져다
--사용할 수 있는 가상의 테이블

--INDEX
--1,2,3,4 . . . 등의 순서를 자동으로 증감시키는 객체














