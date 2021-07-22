-- SELECT 문의 실행 순서 --
/*
    EX)
    SELECT 컬럼명 AS 별칭, 계산식, 함수...
    FROM 테이블명
    WHERE 조건
    GROUP BY 그룹을 묶을 컬럼명
    HAVING 그룹에 대한 조건식, 함수식
    ORDER BY 컬럼 | 별칭 | 컬럼의 순서[ASC|DESC][, 컬럼...]
    
    순서
    1. FROM 테이블명
    2. WHERE 조건
    3. GROUP BY 그룹을 묶을 컬럼명
    4. HAVING 그룹에 대한 조건식, 함수식
    5. SELECT 컬럼명 AS 별칭, 계산식, 함수...
    6. ORDER BY 컬럼 | 별칭 | 컬럼의 순서[ASC|DESC][, 컬럼...] 순으로 진행
*/


-- ORDER BY 절
-- SELECT를 통해 조회한 행의 결과를 특정 기준에 맞춰 정렬하는 구문
SELECT EMP_ID
       ,EMP_NAME 이름
       ,SALARY
       ,DEPT_CODE
FROM EMPLOYEE
-- ORDER BY EMP_ID;
/* ID로 정리 */
-- ORDER BY EMP_NAME; -- 기본값은 ASC(오름차순)
-- ORDER BY DEPT_CODE DESC; -- DEPT_CODE 내림차순
-- ORDER BY DEPT_CODE, EMP_ID; 
/* DEPT_CODE는 내림차순으로 정리하며,
DEPT_CODE 같은 EMP_ID는 EMP_ID 기준으로 오름차순으로 정리 */
-- ORDER BY 이름 DESC;
/* 별칭으로 정리 */
ORDER BY 2 DESC, 1;
/* 숫자로 했을 경우 SELECT 컬럼 순서대로 정리
적혀진 갯수 이상으로 숫자 입력하면 갯수 초과로 에러코드 발생 */


-- GROUP BY 절
-- 특정 컬럼이나 계산식을 하나의 그룹으로 묶어
-- 한 테이블 내에서 소그룹별로 조회하고자 할때 선언하는 구문

-- 전체 평균
SELECT TRUNC(AVG(SALARY), - 3)
FROM EMPLOYEE;

-- 부서별 평균 급여 구하기
-- D1 평균 급여
SELECT TRUNC(AVG(SALARY) - 3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- D6 평균 급여
SELECT TRUNC(AVG(SALARY) - 3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- GROUP BY 절 사용하여 그룹별 평균 급여 구하기
SELECT DEPT_CODE, TRUNC(AVG(SALARY), - 3)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


-- 실습 1.
-- EMPLOYEE 테이블에서
-- 부서 별 총인원, 급여합계, 급여평균, 최대급여, 최소급여를
-- 조회하여 부서코드 기준으로 오름차순 정렬
-- 단 모든 숫자 데이터는 100의 자리까지만 처리
SELECT DEPT_CODE
       ,COUNT(*)
       ,SUM(SALARY)
       ,TRUNC(AVG(SALARY), - 2)
       ,MAX(SALARY)
       ,MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;


-- 실습 2.
-- EMPLOYEE 테이블에서
-- 직급코드(JOB_CODE)별 보너스를 받는 사원의 수를 조회하되,
-- 직큽코드 순으로 내림차순 정렬하여
-- 직급코드, 보너스 받는 사원 수를 조회
SELECT JOB_CODE 직업코드
       ,COUNT(BONUS) 사원수
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1 DESC;

-- EMPLOYEE 테이블에서
-- 남성직원과 여성직원의 수를 조회
-- GROUP BY 에서 주어진 컬럼만이 아닌 함수식도 사용 가능
SELECT SUBSTR(EMP_NO, 8, 1) 성별
       ,COUNT(*) 직원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남성', '여성') 성별
       ,COUNT(*) 직원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);


-- HAVING
-- GROUP BY 한 그룹에 대한 조건을 설정
SELECT DEPT_CODE
       ,AVG(SALARY) 평균
FROM EMPLOYEE
WHERE SALARY > 3000000
GROUP BY DEPT_CODE;

SELECT DEPT_CODE
       ,AVG(SALARY) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 3000000
ORDER BY 1;


-- 실습 3.
-- 부서별 그룹의 급여 합계 중 900만원을 초과하는
-- 부서코드와 급여합계를 조회
SELECT DEPT_CODE
       ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 900000;


-- 실습 4.
-- 급여 합계가 가장 높은 부서를 찾고,
-- 해당 부서의 부서코드와 급여합계를 조회

-- 1) 급여합계가 가장 높은 부서의 급여
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 17700000

-- 2) 급여합계가 가장 높은 부서의 급여와 같은 부서를 조회
SELECT DEPT_CODE
       ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >2800000;

-- Sub Query --
SELECT DEPT_CODE
       ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);


-- SET OPERATOR(집합) --
-- 두 개 이상의 SELECT 한 결과를
-- 합치거나, 중복을 별도로 제거하거나 하는
-- 집합 형식의 결과로 조회하는 명령어

-- 합집합 --
-- UNION : 
-- 두 개 이상의 SELECT한 결과(RESULT SET)를 구하는 명령어,
-- 두 개 이상의 결과를 보여주며 중복이 있을 경우는 제거한 채로 1번만 보여준다

-- UNION ALL :
-- 두 개 이상의 SELECT한 결과를 보여주되,
-- 중복이 있을 경우 그대로 조회하여 보여준다
               
                
-- 교집합 --
-- INTERSECT :
-- 두 개 이상의 결과 중 중복되는 결과만을 보여준다
         
             
-- 차집합 --
-- MINUS :
-- 두 개 이상의 결과 중 첫번째 결과만이 가진 내용을 보여주는 명령어
-- A랑 B를 합쳤을때 A만이 가진 결과를 보여주는 명령어

-- * 어떠한 SET 명령어를 사용하더라도 그 결과의 모양은 반드시 같아야 한다 *
-- SELECT 결과인 A와 SELECT한 결과 B를 하나로 합칠때
-- A와 B의 컬럼 갯수와 컬럼의 자료형이 반드시 같아야 한다


-- UNOION
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 조회

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 조회

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- UNION 사용하여 위 두 개 조회


-- UNOION ALL
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 조회

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 조회

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- UNION ALL 사용하여 위 두 개 조회


--INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>3000000;

--MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>3000000;


--JOIN--
--두개 이상의 테이블을 하나로 합쳐 사용하는 명령 구문

--만약에 'J6'라는 직급을 가진 사원들의 근무 부서명이 궁금하다면??
SELECT EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

SELECT * FROM DEPARTMENT;


-- 오라클 전용 문법/ ANSI 표준 문법

--오라클 전용
--FROM 절에 ','를 붙여 합치게 될 테이블을 나열
--WHERE 조건을 통해 합칠 테이블들의 공통 사항을 작성

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

--ANSI 표준문법--
--조인하고자 하는 테이블을 FROM 구문 다음에
--JOIN 테이블명 ON() | USING() 구문을 사용하여
-- 테이블을 합치는 방법

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 두개의 테이블에서 공통 컬럼의 이름이 같은 경우
SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E , JOB J 
WHERE E.JOB_CODE = J.JOB_CODE;

--ANSI
--동일한 컬럼명을 가지고있을때 JOIN USING()을 사용해서 구분할 수 있다.
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE  
JOIN JOB  USING(JOB_CODE);

--실습5.
-- EMPLOYEE 테이블의 직원 급여 정보와
-- SAL_GRADE의 급여 등급을 합쳐서
--사번, 사원명, 급여 등급, 등급 기준 최소급여, 최대 급여를
--조회 하시오.

SELECT *FROM EMPLOYEE;
SELECT *FROM SAL_GRADE;

--ORACLE
SELECT EMP_ID, EMP_NAME,EMPLOYEE.SAL_LEVEL,MIN_SAL,MAX_SAL
FROM EMPLOYEE, SAL_GRADE
WHERE EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL;

--ANSI USING()사용
SELECT EMP_ID, EMP_NAME,SAL_LEVEL,MIN_SAL,MAX_SAL
FROM EMPLOYEE JOIN SAL_GRADE USING(SAL_LEVEL);

--ANSI ON()사용
SELECT EMP_ID, 
            EMP_NAME,
            EMPLOYEE.SAL_LEVEL, 
            MIN_SAL,
            MAX_SAL
FROM EMPLOYEE JOIN SAL_GRADE ON(EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL);

/*FROM EMPLOYEE JOIN SAL_GRADE
같은 컬럼명이기때문에
여기서 USING()을 사용하면되는데
ON()을 사용하게되면
SELECT 의 SAL_LEVEL과
ON() 안의 SAL_LEVEL이 어떠한 테이블을 가르키고있는지 명시해주어야한다.
*/


--실습 6
--DEPARTMENT 테이블의 위치 정보와
--LOCATION 테이블을 조인하여
--각 부서별 근무지 위치를 조회
--부서코드, 부서명, 근무지코드, 근무위치

--테이블 정보
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

--ORACLE--
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;
--ANSI--
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);