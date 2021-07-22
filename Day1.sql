--한 줄 주석
/* 여러 줄 주석 */

--SELECT 문
/*
SELECT : 조회 용 SQL 문장
[사용법]
SELECT 조회할 컬럼 : 조회하고자 하는 내용
FROM 테이블 명     : 조회하고자 하는 테이블 명
[WHERE 조건 ]     : 특정 조건
[ORDER BY 컬럼 ]  : 정렬
;                : 문장의 끝
*/

--모든 행과 모든 컬럼 조회
SELECT *
FROM EMPLOYEE;

--사원 전체의 ID와 사원명, 연락처만 조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE;

--실습--
--사원의 아이디, 사원명, 이메일, 연락처, 부서번호(DEPT_CODE),직급코드(JOB_CODE)를 조회
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;


--WHERE 구문
--테이블에서 조건을 만족하는 값을 가진 행을(튜플,로우)
--따로 선택하여 조회한다.
-- 여러개의 조건을 선택하고자 할 경우 AND | OR 명령어를 사용
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

--실습2
--직급이 'J1'인 사원의 사번, 사원명, 직급코드, 부서코드를 조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';

--실습3
--EMPLOYEE 테이블에서 급여(SALARY)가 300만원 이상인
--사원의 아이디, 사원명, 직급코드, 급여정보를 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

--조건이 2개 이상 붙었을 경우(AND | OR)
--부서 코드가 'D6'이면서, 이름이 유재식인 사원의 모든 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' 
    AND EMP_NAME = '유재식';

--부서 코드가 'D6' 이거나, 'D5'인 사원의 모든 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
    OR DEPT_CODE= 'D5';
    

--컬럼 명에 별칭 달기
--1. AS(alias) 표현
SELECT EMP_ID AS "사원번호", 
       EMP_NAME AS "사원명"
FROM EMPLOYEE;

--2. AS 생략
SELECT EMP_ID "사  번",
       EMP_NAME 사원명
FROM EMPLOYEE;

--실습4
--EMPLOYEE 테이블에서 부서가 D2 이거나 D1인
--사원들의 사원명, 입사일, 연락처를 조회
--(단, 조회하는 컬럼에는 별칭 부여)
SELECT  EMP_NAME "사원명",
        HIRE_DATE "입사일",
        PHONE "연락처"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D2' 
   OR DEPT_CODE = 'D1';
   

--실습5
--EMPLOYEE 테이블에서 사원 번호가 205번인 사원의
--사원명, 이메일, 급여, 입사일자를 조회
--(단, 조회하는 컬럼명에 별칭 부여)
SELECT EMP_NAME "사원명",
       EMAIL "이메일",
       SALARY "급여",
       HIRE_DATE "입사일자"
FROM EMPLOYEE
WHERE EMP_ID = '205';




