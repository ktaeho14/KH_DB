--SQL 기본함수 문제

--1.
SELECT EMP_NAME "직원명" , 
            REPLACE(EMP_NO,SUBSTR(EMP_NO,9,6),'******') "주민번호"
FROM EMPLOYEE;

SELECT SALARY
FROM EMPLOYEE;
--2.
SELECT EMP_NAME "직원명",
            JOB_CODE "직급코드",
            TO_CHAR( (SALARY+NVL( BONUS,  0) ) * 12, 'L99,000,000') "연봉"
FROM EMPLOYEE;


--3.
SELECT EMP_ID "사번",
            EMP_NAME "사원명",
            DEPT_CODE "부서코드",
            HIRE_DATE "입사일"
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D5' OR DEPT_CODE = 'D9')  AND TO_CHAR(HIRE_DATE,'YYYY') = '2004';

--4.
SELECT *
FROM EMPLOYEE;

SELECT EMP_NAME "직원명",
            HIRE_DATE "입사일",
            SUBSTR(LAST_DAY(HIRE_DATE),7,2) - SUBSTR(HIRE_DATE,7,2) "근무일수"
FROM EMPLOYEE;

--5.
SELECT EMP_NAME "직원명", 
            DEPT_CODE "부서코드",
            CONCAT(
            CONCAT(TO_CHAR(SUBSTR(EMP_NO,1,2))||'년'
            ,TO_CHAR(SUBSTR(EMP_NO,3,2))||'월'),
            TO_CHAR(SUBSTR(EMP_NO,5,2))||'일')  "생년월일"
            --EXTRACT( YEAR FROM SYSDATE)-EXTRACT(YEAR FROM SUBSTR(EMP_NO,1,2))
            --만나이출력 질문해보기
            
            
FROM EMPLOYEE;


SELECT HIRE_DATE
FROM EMPLOYEE;
--6.


SELECT  COUNT(*)"전체직원수",
            SUM(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2001,1,0))"2001년",
            SUM(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2002,1,0))"2002년",
            SUM(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2003,1,0))"2003년",
            SUM(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2004,1,0))"2004년"
FROM EMPLOYEE;


--7
SELECT  EMPLOYEE.*,
            CASE
            WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            WHEN DEPT_CODE = 'D9' THEN '영업부'
            END "부서"
            
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR DEPT_CODE ='D6' OR DEPT_CODE = 'D9'
ORDER BY DEPT_CODE ASC;


SELECT *
FROM EMP
WHERE JOB ! = 'MANAGER';

SELECT *
FROM EMP;

SELECT ENAME 사원명
       ,HIREDATE 입사일
       ,SUBSTR(EMPNO,1,2)||'년'
        ||SUBSTR(EMPNO,3,2)||'월'
        ||SUBSTR(EMPNO,5,2)||'일'
FROM EMP;







