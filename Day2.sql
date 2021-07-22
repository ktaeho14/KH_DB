SELECT * FROM EMPLOYEE;

-- 데이터 베이스에서 실행하고자 하는 명령 종류
-- CRUD   : 데이터 기본 사항 처리 로직
-- CREATE : 데이터 추가  /   INSERT
-- READ   : 데이터 조회  /   SELECT
-- UPDATE : 데이터 수정  /   UPDATE
-- DELETE : 데이터 삭제  /   DELETE

--컬럼 값을 사용하여 계산식을 적용한 정보 조회하기
--컬럼의 값이 만약 NULL 이라면 어떠한 연산 처리를 해도 결과는 NULL!!!
SELECT EMP_NAME "사원명",
      (SALARY * 12) "연봉",
      BONUS "보너스",
      (SALARY + (SALARY*BONUS)) * 12 "연봉총합"
FROM EMPLOYEE;


--NVL() : NULL일경우 별도로 지정한 값으로 변경
SELECT EMP_NAME "사원명",
        (SALARY * 12) "연봉",
        BONUS "보너스",
        (SALARY + (SALARY * NVL(BONUS,0))) * 12 "연봉총합"
FROM EMPLOYEE;

--컬럼에 일반 값 사용하기
SELECT EMP_NAME, SALARY*12,'원'"단위"
FROM EMPLOYEE;

SELECT 



--DISTINCT
--해당하는 값이 컬럼에 여러 개 존재할 경우 중복을 제거하고 한 개만 조회(NULL포함)
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE;


SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

--실습1
--DEPARTMENT 테이블을 참조하여,
--부서가'해외영업2부'인 부서의 부서코드를 찾고
--EMPLOYEE 테이블에서 해당 부서의
--사원들 중 급여를 200만원보다 많이 받는 직원의
--사번,사원명, 급여를 조회


--1)'해외영업2부'의 부서코드 찾기(DEPARTMENT 테이블에서)
SELECT *
FROM DEPARTMENT;

SELECT DEPT_ID,
            DEPT_TITLE
FROM DEPARTMENT;

--2) 조회한 부서코드를 사용하여
--  사원들 중 급여를 200만원 보다 많이 받는 직원 조회
SELECT *
FROM EMPLOYEE;

SELECT EMP_ID "사번",
            EMP_NAME "사원명",
            SALARY "급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' AND SALARY>'2000000';


--연산자--

--연결 연산자 '||' 
--여러 컬럼의 결과나 값을 하나의 컬럼으로 묶을때 사용

--EX) '사번'을 가진 사원의 이름은 '000'입니다.

SELECT EMP_ID ||'을 가진 사원의 이름은 ' || EMP_NAME || '입니다.'
FROM EMPLOYEE;

--비교 연산자
-- <, >, <=, >= : 크기를 나타내는 부등호
-- = : 같다
-- !=, ^=, <> : 같지않다

--EMPLOYEE테이블에서 부서코드가 'D9'이 아닌 직원들의 모든 정보를 조회
SELECT *
FROM EMPLOYEE
--WHERE DEPT_CODE <> 'D9';
--WHERE DEPT_CODE ^= 'D9';
WHERE DEPT_CODE != 'D9';

-- EMPLOYEE 테이블에서
--급여가 350만원 이상, 550만원 이하인
--직원의 사번, 사원명, 부서코드, 직급코드, 급여 정보를 조회

--1.
SELECT EMP_ID "사번",
           EMP_NAME "사원명",
           DEPT_CODE "부서코드",
           JOB_CODE "직급코드",
           SALARY "급여 정보"
FROM EMPLOYEE
WHERE SALARY>='3500000' AND SALARY<='5500000'
ORDER BY SALARY ASC; --오름차순
--ORDER BY SALARY DESC; --내림차순

--2. BETWEEN A AND B
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 5500000;

--직원의 사번,사원명,부서코두,직급코드,급여정보를 조회하되
--350만원 미만, 550만원 초과인 직원 정보를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 5500000; 


--LIKE : 입력한 숫자, 문자가 포함된 정보를 조회할 때 사용하는 연산자
--  '_' : 임의의 한 문자
-- '%' : 몇자리 문자든 관계 없이



--EMPLOYEE 테이블에서 사원 이름에 가운데'중'이 들어가는 사원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_중_';

SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_중%';

--성이'이'인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이__';

--성이'이'인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이%';

--EMPLOYEE 테이블에서
--주민등록번호 기준 남성인 사원의 정보만 조회하기
SELECT *
FROM EMPLOYEE
WHERE EMP_NO LIKE '_______1%';

--사원 중 이메일 아이디가
--다섯글자를 초과하는 사원의
--사원명,사번,이메일 정보를 조회
SELECT EMP_NAME, EMP_ID, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '______%@%';

--사원 중 이메일 4번째 자리가 '_'인 사원의 정보 조회하기
-- ESCAPE 문자를 선언하여 뒤에 오는 문자를 특수문자가 아닌
--일반 문자로 선언하여 사용.
-- ESCAPE 문자선언은 무엇을 사용해도 가능하다.
SELECT EMP_NAME, EMP_ID, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%@%' ESCAPE '#';



SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY, EMAIL
FROM EMPLOYEE
WHERE DEPT_CODE ='D9' OR DEPT_CODE ='D6' 
AND SALARY>3000000 
AND EMAIL LIKE '___#_%' ESCAPE '#' 
AND BONUS IS NULL;
--IN 연산자
--          IN(값1,값2,값3.....)
--          괄호 안에 있는 값 중 하나라도 일치하는 경우
--          해당하는 값을 조회하는 연산자

--부서 코드가 D1이거나 D6인 부서 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1' OR DEPT_CODE='D6';

SELECT *
FROM EMPLOYEE
WHERE  DEPT_CODE IN('D1','D6');

--D1도 D6도 아닌 부서의 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN('D1','D6');

--IS NULL
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;




-- 연산자의 우선순위
/*
    0.()
    1.산술연산자( +,-,*,/)
    2.연결연산자 ( || )
    3.비교연산자 (<,>,<=,>=)
    4.IS NULL/ IS NOT NULL/ LIKE, IN/ NOT IN  --NULL인지 비교해주는 연산자
    5.BETWEEN A AND B
    6.NOT
    7.AND
    8.OR
*/


--종합 실습1:
--직급이 'J2'이면서 200만원 이상 받는 직원 이거나,
--직급이 'J7;인
--사원의 사번, 사원명, 직급코드, 급여
--정보 조회하기
SELECT EMP_ID "사번" , EMP_NAME "사원명" , JOB_CODE "직급코드" , SALARY "급여"
FROM EMPLOYEE
WHERE (JOB_CODE ='J2' AND SALARY>=2000000) OR JOB_CODE = 'J7';

--종합 실습2:
--직급이 'J7'이거나 'J2'이면서 급여를 200만원 이상
-- 받는 직원의 사번, 사원명, 직급코드, 급여, 연봉을
--조회하시오

SELECT EMP_ID "사번" , EMP_NAME "사원명" , JOB_CODE"직급코드", SALARY,SALARY*12 "연봉"
FROM EMPLOYEE
WHERE JOB_CODE IN('J7','J2') AND SALARY>=2000000;

--WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') 
--FROM EMPLOYEE
--AND SALARY >= 2000000;


-- 함수(Function) --

--문자 관련 함수

--LENGTH / LENGTHB
--LENGTH : 문자열의길이
--LENGTHB(바이트 타입)


--문자열의 길이를 계산하는 함수

SELECT LENGTH('Hello'),
           LENGTHB('Hello')
FROM DUAL;

SELECT LENGTH('홍길동'),
           LENGTHB('홍길동') --영어를 제외한 모든 문자는 3BYTE
FROM DUAL;

SELECT * FROM DUAL;
/* DUAL :임시 테이블(가상의 테이블)
            SELECT문에서 리터럴을 활용한 계산식
            테스트하고자 할 때 사용하는 임시 테이블
*/

--INSTR : 주어진 값에서 원하는 문자가 몇번째인지 찾아 반환하는 함수
SELECT INSTR('ABCDE','A'),
           INSTR('ABCDE','C'),
           INSTR('ABCDE','Y'),
           INSTR('ABCDE','CD')
FROM DUAL;


-- SUBSTR : 주어진 문자열에서 특정 부분만 꺼내 오는 함수
SELECT 'Hello World',
            SUBSTR('Hello World',1,5), --처음부터 5문자
            SUBSTR('Hello World',7) --7번째문자부터 끝까지
FROM DUAL;



--실습 2.
--EMPLOYEE 테이블에서
--사원들의 이름, 이메일 주소를 조회하는데
--이메일은 아이디 부분만 조회하기
/*
    --조회결과--
    홍길동 HONG_GD
*/

--1. 이름과 이메일 조회
SELECT EMP_NAME || EMAIL"조회결과"
FROM EMPLOYEE;

--2. @위치 찾기
SELECT INSTR(EMAIL,'@')
FROM EMPLOYEE;

--3. SUBSTR
SELECT EMP_NAME ||
            SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) "조회결과" 
FROM EMPLOYEE;

--LPAD / RPAD
-- 빈칸을 지정한 문자로 채우는 함수
--LPAD(컬럼,방갯수,빈칸을채울 문자) 왼쪽부터
--RPAD(컬럼,방갯수,빈칸을채울 문자) 오른쪽부터
SELECT LPAD(EMAIL,20,'*')
FROM EMPLOYEE;

SELECT RPAD(EMAIL,20,'-')
FROM EMPLOYEE;

-- LTRIM / RTRIM
-- 특정 문자를 찾아 지워주는 함수

--찾을 문자를 지정하지 않으면 빈칸을 지운다
SELECT   LTRIM('      HELLO'),
             RTRIM('HELLO       ')
FROM DUAL;

SELECT LTRIM('012345','0'),
           LTRIM('111234','1'),
           RTRIM('54321','1')
FROM DUAL;

-- TRIM
--주어진 문자열에서 양끝을 기준으로 특정 문자를 찾아 지우는 함수
SELECT TRIM('   목요일    ')
FROM DUAL;

SELECT TRIM('0' FROM '0000123000')
FROM DUAL;

-- LOWER / UPPER/ INITCAP
-- 주어진 문자열을 소문자, 대문자, 앞글자만 대문자로 변경해주는 함수
SELECT LOWER('NICE TO MEET YOU'),
            UPPER('nice to meet you'),
            INITCAP('nice to meet you')
FROM DUAL;

--CONCAT : 여러 문자열을 하나의 문자열로 합치는 함수
SELECT CONCAT('오라클','재밌다 :)')
FROM DUAL;

--연결연산자
SELECT '오라클'||'재밌다:)'
FROM DUAL;

--REPLACE : 주어진 문자열에서 특정 문자를 변경할 때 사용하는 함수
SELECT REPLACE('HELLO WORLD','HELLO','BYE')
FROM DUAL;

--실습 3
--EMPLOYEE 테이블에서
--사원의 주민 번호를 확인하여
--생년 월일을 각각 조회하시오.
--이름 | 생년 | 생월 | 생일
--홍길 | 00년 || 00월 || 00일
SELECT *
FROM EMPLOYEE;

SELECT EMP_NAME "이름", SUBSTR(EMP_NO,'1','2')||'년' "생년", 
            SUBSTR(EMP_NO,'3','2')||'월' "생월",
            SUBSTR(EMP_NO,'5','2')||'일' "생일"
FROM EMPLOYEE;

--날짜 데이터도 SUBSTR을 통해 쪼갤 수 있다.
--'19/12/31' => 19 / 12 / 31
SELECT EMP_NAME "이름", SUBSTR(HIRE_DATE,1,2)||'년' "입사년도", 
            SUBSTR(HIRE_DATE,'4','2')||'월' "입사월",
            SUBSTR(HIRE_DATE,'7','2')||'일' "입사일"
FROM EMPLOYEE;


--실습 4
--EMPLOYEE 테이블에서
--모든 사원의 사번, 사원명, 이메일, 주민번호를
--조회하여 사원 목록표를 만들고자 한다.
--이 때,이메일은 '@'전 까지
--주민번호는 7번째 자리 이후 '*'처리를 하여
--조회 하시오.
SELECT EMP_ID "사번", EMP_NAME "사원명", 
            SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) "이메일",
            REPLACE(EMP_NO, SUBSTR(EMP_NO,7,8) ,'********') "주민번호"
                      
            
FROM EMPLOYEE;



--실습 5
--EMPLOYEE 테이블에서 현재 근무하는
--여성 사원의 사번, 사원명, 직급코드를 조회 하시오.
-- **ENT_YN : 현재 근무 여부 파악하는 컬럼(퇴사 여부)
-- **WHERE 절에서도 함수 사용이 가능하다.

SELECT *
FROM EMPLOYEE;


SELECT EMP_ID "사번",
           EMP_NAME "사원명",
            JOB_CODE "직급코드"
FROM EMPLOYEE
--WHERE EMP_NO LIKE '_______2%' AND ENT_YN ='Y';
WHERE EMP_NO LIKE '%-2%' AND ENT_YN ='Y';







