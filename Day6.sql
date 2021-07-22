-- TOP-N 분석함수 --
-- RANK() 함수, DENSE_RANK() 함수
-- PARK() : 동일한 순번이 있을 경우 이후의 순번은 이전 동일한 순번의 개수만큼
--          건너 뛰고 순번을 매기는 함수
-- 1
-- 2
-- 3
-- 4
SELECT EMP_NAME
       ,SALARY
       ,RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT EMP_NAME
       ,SALARY
       ,RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) < 4;/* 오류발생 */

SELECT *
FROM (
      SELECT EMP_NAME
             ,SALARY
             ,RANK() OVER(ORDER BY SALARY DESC) 순위
      FROM EMPLOYEE
      )
WHERE 순위 < 4;

      
-- DENSE_RANK() : 동일한 순번이 있을 경우 이후 순번에 영향을 미치지 않는 함수
-- 1
-- 2
-- 2
-- 3
SELECT EMP_NAME
       ,SALARY
       ,DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;


-- 실습 1.
-- EMPLYOEE 테이블에서 
-- 보너스를 포함한 연봉이 가장 높은 사원 상위 5명을
-- RANK() 함수를 활용 하여 조회
-- 사번, 사원명, 부서명, 직급명 입사일, 연봉(보너스 포함)
-- (SALARY + SALARY * BONUS) * 12
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       ,(SALARY + (SALARY * NVL(BONUS, 0))) * 12 연봉
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE); -- 조회하면 21명

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       ,(SALARY + (SALARY * NVL(BONUS, 0))) * 12 연봉
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE); -- 조회하면 23명

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       ,(SALARY + (SALARY * NVL(BONUS, 0))) * 12 연봉
       ,RANK() OVER(ORDER BY(SALARY + (SALARY * NVL(BONUS, 0))) * 12 DESC) 순위
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

SELECT * FROM (
       SELECT EMP_ID
              ,EMP_NAME
              ,DEPT_TITLE
              ,JOB_NAME
              ,HIRE_DATE
              ,(SALARY + (SALARY * NVL(BONUS, 0))) * 12 연봉
       ,RANK() OVER(ORDER BY(SALARY + (SALARY * NVL(BONUS, 0))) * 12 DESC) 순위
       FROM EMPLOYEE
       LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
       JOIN JOB USING(JOB_CODE)
)
WHERE 순위 < 6;

-- 상호 연관 쿼리 : 상관 쿼리 --
-- 메인쿼리가 사용하는 컬럼값, 계산식 등을 서브쿼리에 적용하여
-- 서브쿼리 실행 시 메인쿼리의 값도 함께 사용하는 방식

-- 사원의 직급에 따른 급여 평균보다 많이 받는 사원의 정보 조회
SELECT JOB_CODE
       ,TRUNC(AVG(SALARY), - 3)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT AVG(SALARY) 
                FROM EMPLOYEE E2 
                WHERE E.JOB_CODE = E2.JOB_CODE);

--스칼라 서브쿼리
--단일행 + 상관쿼리
--SELECT, WHERE, ORDER BY 절에 사용
--보통 SELECT 절에 많이 사용. SELECT LIST라고도 한다.

--연습(SELECT)
--모든 사원의 사번, 사원명, 관리자 사번, 관리자명을 조회하되,
--관리자가 없을 경우 '없음' 이라고 표시.
--단, SELECT 문에 서브쿼리를 삽입하는 형식

SELECT EMP_ID,
            EMP_NAME,
            MANAGER_ID,
            NVL( (SELECT EMP_NAME
                    FROM EMPLOYEE M
                    WHERE E.MANAGER_ID = M.EMP_ID), '없음') 관리자이름
            
FROM EMPLOYEE E
ORDER BY 관리자이름, EMP_ID;


--연습(WHERE)
        SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT AVG(SALARY) 
                FROM EMPLOYEE E2 
                WHERE E.JOB_CODE = E2.JOB_CODE);


--------------------------------------------------
/*
    CREATE : 데이터베이스의 객체를 생성하는 DDL
    [사용형식]
    CREATE 객체형태 객체명 (관련 내용)
    
    EX)
    --계정생성
    CREATE USER TEST IDENTIFIED BY TEST; GRANT CONNECT, RESOURCE TO TEST;
    --테이블 생성
    CREATE TABLE TB_TEST (
                컬럼명 자료형 제약조건,
                컬럼명 자료형 제약조건 . . .
    );
*/

CREATE TABLE MEMBER(
        MEMBER_NO NUMBER,               --회원 번호
        MEMBER_ID VARCHAR2(20),        --회원 아이디
        MEMBER_PWD VARCHAR2(20),    --회원 비밀번호
        MEMBER_NAME VARCHAR2(15)  --회원 이름
);

SELECT * FROM MEMBER;


-- 테이블의 각 컬럼에 주석 달기
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_NO IS '회원 번호';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';

--데이터 사전 : 설정정보를 테이블에 저장한것

--현재 접속한 사용자 계정이 보유한 테이블 목록
SELECT * FROM USER_TABLES;

SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER';

SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME = 'MEMBER';

--제약조건--
--테이블을 생성할 때 각 컬럼에 값을 기록하는 것에 대한
--제약사항을 설정할 때 사용하는 조건들.

--사용자 계정에 관련된 제약조건을 확인하는 데이터 사전
SELECT * FROM USER_CONSTRAINTS;

--NOT NULL 제약조건--
--'널 값을 허용하지 않는다'
--NOT NULL 제약조건을 등록한 컬럼에는 반드시 값을 기록해야 한다.
--데이터 삽입/ 수정/ 삭제 시에 NULL 값을 허용하지 않도록
--컬럼 작성시 함께 작성.(컬럼레벨 제약조건)

DROP TABLE USER_CONS;

CREATE TABLE USER_CONS(
        USER_NO NUMBER,
        USER_ID VARCHAR2(20),
        USER_PWD VARCHAR2(15),
        USER_NAME VARCHAR2(15),
        GENDER VARCHAR2(3),
        PHONE VARCHAR2(14),
        EMAIL VARCHAR2(30)
);

SELECT * FROM USER_CONS;

--테이블에 값 추가
-- INSERT -> DML
INSERT INTO USER_CONS
VALUES(1, 'user01','pass01','이창진','남','010-3333-2222','leecj123@kh.or.kr');

SELECT * FROM USER_CONS;

INSERT INTO USER_CONS
VALUES(2,NULL,NULL,NULL,'여',NULL,NULL);

SELECT * FROM USER_CONS;

CREATE TABLE USER_NOT_NULL(
    USER_NO NUMBER NOT NULL,  --컬럼 레벨 제약 조건 설정
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR(3),
    PHONE VARCHAR(14),
    EMAIL VARCHAR(30)
);

SELECT * FROM USER_NOT_NULL;

--NOT NULL 제약조건 확인
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 ON(C1.CONSTRAINT_NAME = C2.CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_NOT_NULL';

INSERT INTO USER_NOT_NULL
VALUES(1,'user01','pass01','이창진','남','010-1234-5678','lee321@kh.or.kr');

SELECT * FROM USER_NOT_NULL;

INSERT INTO USER_NOT_NULL
VALUES(2,NULL,NULL,NULL,'여',NULL,NULL);

SELECT * FROM USER_NOT_NULL;

--UNIQUE 제약조건--
--중복을 허용하지 않는 제약조건
--만약에 중복 값이 있을경우 값을 추가, 수정을 하지 못하게
--막는 제약조건
--컬럼레벨, 테이블레벨에서 설정 가능

INSERT INTO USER_CONS
VALUES(1, 'user01', ' 1234', '유관순', '여', '010-3333-2211','you@kh.or.kr');

SELECT *
FROM USER_CONS;


CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE, --컬럼레벨, 제약조건
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2 (15)
);

INSERT INTO USER_UNIQUE
VALUES(1,'USER01','PASS01','이창진');



SELECT * FROM USER_UNIQUE;

SELECT *
FROM USER_CONSTRAINTS C1
WHERE C1.TABLE_NAME = 'USER_UNIQUE';

--P : PRIMARY KEY
--C : CHECK, NOT NULL
--U : UNIQUE
--R : FOREIGN KEY(REFERENCE)



--테이블 레벨에서 제약조건 설정하기
CREATE TABLE USER_UNIQUE2(
    USER_NO NUMBER,
    --USER_ID VARCHAR2(20) UNIQUE --컬럼레벨 제약 조건
    USER_ID VARCHAR(20),
    USER_PWD VARCHAR(30),
    USER_NAME VARCHAR(15),
    UNIQUE(USER_ID) --테이블 레벨 제약조건
                              --컬럼이 모두 작성 된 후 별도로 작성하는 제약조건
);

INSERT INTO USER_UNIQUE2
VALUES(1,'USER01','PASS01','이창진');

INSERT INTO USER_UNIQUE2
VALUES(1,'USER01','1234','홍길동');

SELECT * FROM USER_UNIQUE2;


--UNIQUE 제약조건을 여러 개 컬럼에 적용하기
--D1 200
--D1 201
--D2 200
--D2 201
--두 개 이상의 컬름을 제약조건으로 묶을 경우
--반드시 테이블 레벨에서 제약조건을 선언해야 한다.
CREATE TABLE USER_UNIQUE3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(15),
    UNIQUE(USER_NO,USER_ID)
);

SELECT * FROM USER_UNIQUE3;

INSERT INTO USER_UNIQUE3
VALUES (1,'USER01','PASS01','홍길동');

INSERT INTO USER_UNIQUE3
VALUES(1,'USER02','PASS02','고길동');

INSERT INTO USER_UNIQUE3
VALUES(2,'USER01','PASS03','김길동');

INSERT INTO USER_UNIQUE3
VALUES(2,'USER02','PASS04','이길동');

INSERT INTO USER_UNIQUE3
VALUES(2,'USER01','PASS05','최길동');

SELECT * FROM USER_UNIQUE3;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'USER_UNIQUE3';












