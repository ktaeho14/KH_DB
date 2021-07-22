--지금 까지 실습해 봤던 함수는
--단일 행 함수(Single Row Function)
-- 결과를 찾아서 출력 할 때마다 각행에 함수가 적용



--오늘 실습할 함수는
--다중 행 함수(Multiple Row Function)
-- 조건절에 만족하는 모든 행을 다찾고 나서 모든 데이터를 한번에 연산


--그룹 함수
--SUM(), AVG(), MAX(), MIN(), COUNT()

--SUM(숫자가 기록된 컬럼) : 해당 컬럼들의 합계

SELECT SUM(SALARY)
FROM EMPLOYEE;

--AVG(숫자가 기록된 컬럼) : 해당 컬럼들의 평균

SELECT AVG(SALARY)
FROM EMPLOYEE;

--MAX() : 해당 컬럼들의 값 중 최대값
--MIN(): 해당 컬럼들의 값 중 최소값

SELECT MAX(SALARY),
          MIN(SALARY)
FROM EMPLOYEE;


--실습 1.
--EMPLOYEE 테이블에서
--'해외영업1부'에 근무하는 모든 사원의
--평균 급여. 가장 높은 급여. 낮은 급여. 급여 합계
--조회하기

SELECT *
FROM EMPLOYEE;

SELECT AVG(SALARY) "평균",
            MAX(SALARY) "가장높은 급여",
            MIN(SALARY)"낮은 급여",
            SUM(SALARY)"급여합계"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


--COUNT : 행의 갯수

--COUNT 는 컬럼값이 NULL일 경우 계산하지 않는다.

SELECT COUNT(*),
           COUNT(DEPT_CODE),
           COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

--날짜 처리 함수 --

--MONTHS_BETWEEN(날짜1, 날짜2) :두 날짜 사이의 개월 수

SELECT HIRE_DATE "입사일",
           MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "입사 후 개월 수"
FROM EMPLOYEE;

--ADD MONTH(날짜, 개월 수)

SELECT ADD_MONTHS(SYSDATE, 2)
FROM DUAL;


-- EXTRACT() : 지정한 날짜로부터 날짜 값을 추출하는 함수

SELECT EXTRACT(YEAR FROM HIRE_DATE) "년도",
            EXTRACT(MONTH FROM HIRE_DATE)"월",
            EXTRACT(DAY FROM HIRE_DATE)"일"

FROM EMPLOYEE;

-----------------------

--형변환 함수--
-- DATE <--> CHAR <--> NUMBER
--TO_DATE() <-->> TO_CHAR() <--> TO_NUMBER()

--TO_CHAR()--

SELECT HIRE_DATE "입사일" ,
          TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'),
          TO_CHAR(HIRE_DATE, 'YY-MON-DD')
FROM EMPLOYEE;

-- 숫자 형식 변경하기
-- 0: 남은 자리는 0으로 표시한다.
-- 9: 남은 자리는 표시하지 않는다.
-- L: 통화기호 \가 들어간다.



SELECT SALARY,
            TO_CHAR(SALARY, 'L999,999,999'),
            TO_CHAR(SALARY, '000,000,000'),
            TO_CHAR(SALARY, 'L999,999'),
            TO_CHAR(SALARY, 'L000,000')
FROM EMPLOYEE;

--TO_DATE()
--날짜로 바꾸어주는 메소드

SELECT 20210402,
            TO_DATE(20210402, 'yyyymmdd'),
            TO_DATE(20210402, 'YYYY/MM/DD')
FROM DUAL;


--TO_NUMBER()

SELECT '1111' "문자" , TO_NUMBER('1111') "숫자"
FROM DUAL;


--------------------------------------------------
-- DECODE() --
--JAVA의 3항 연산자
-- DECODE(컬럼명|데이터, 비교값1, 결과1, 비교값2, 결과2, .... , 기본값)

--현재 근무하는 직원들의 성별을 남, 여로 구분짓기
SELECT EMP_NAME,
            EMP_NO,
            DECODE(SUBSTR(EMP_NO,8,1), '1','남', '2', '여') "성별" 
FROM EMPLOYEE;

--실습 2.
--EMPLOYEE 테이블에서
--모든 직원의 사번, 사원명, 부서코드, 직급코드,
--근무 여부, 관리자 여부를 조회하되
--만약 근무 여부가 'Y' 퇴사자,
--                      'N' 근무자,
--관리자 사번(MANAGER_ID)이 있으면 사원,
--                                        없으면 관리자
--로 작성하여 조회 하시오.      


SELECT EMP_ID"사번" ,
            EMP_NAME"사원명" ,
            DEPT_CODE"부서코드" ,
            JOB_CODE "직급코드" ,
            DECODE(ENT_YN,'Y','퇴사자','N','근무자') "근무여부",
            DECODE(MANAGER_ID,NULL,'관리자','사원') "관리자 사번"
            --DECODE(NVL(MANAGER_ID,0),0,'관리자','사원') "관리자 여부"
FROM EMPLOYEE;

-- CASE 문
-- 자바의 IF, SWITCH 처럼 사용할 수 있는 함수 표현식

--사용법
-- CASE
--         WHEN (조건식1) THEN 결과값1
--         WHEN (조건식2) THEN 결과값2
--         ELSE 결과괎3
-- END

--CASE문을 이용하여 실습2를 해결해보자

SELECT EMP_ID"사번" ,
            EMP_NAME"사원명" ,
            DEPT_CODE"부서코드" ,
            JOB_CODE "직급코드" ,
            CASE
                    WHEN ENT_YN ='Y' THEN '퇴사자'
                    ELSE '근무자'
            END "근무 여부" ,
            CASE
                    WHEN MANAGER_ID IS NULL THEN '관리자'
                    ELSE '사원'
            END "관리자 여부"
FROM EMPLOYEE;
--NULL값은 =로 비교가되지않는다 IS NULL || IS NOT NULL 을 통해서 비교하도록 하자.

-- NVL2(컬럼명|데이터, NULL이 아닌 경우 값, NULL일 경우 값)

SELECT EMP_ID "사번",
           EMP_NAME "사원명",
           BONUS "보너스",
           NVL(TO_CHAR(BONUS), 'X') "NVL함수",
           NVL2(BONUS, TO_CHAR(BONUS, '0.99'), 'X') "NVL2함수"
FROM EMPLOYEE;


--숫자 데이터 함수--
--ABS() : 특정 숫자의 절대값을 표현
SELECT ABS(10), ABS(-10)
FROM DUAL;

--MOD() : 주어진 컬럼이나 값을 나눈 나머지를 반환
--정수로 표현
SELECT MOD(10,3) , MOD(10,2)
FROM DUAL;

--ROUND() : 지정한 숫자를 반올림할 때 사용하는 함수
SELECT  ROUND(123.456, 0),
            ROUND(123.456,1),
            ROUND(123.456,2),
            ROUND(123.456,-2)
FROM DUAL;

-- FLOOR() :소수점 이하 자리의 숫자를 버리는 함수
--CEIL() : 소수점 첫째 자리에서 올림 하는 함수
SELECT FLOOR(123.456),
        CEIL(123.456)
FROM DUAL;

-- TRUNC() : 지정한 위치까지 숫자를 버리는 함수
SELECT TRUNC(123.456, 0),
           TRUNC(123.456, 1),
           TRUNC(123.456, 2),
           TRUNC(123.456, -2)
FROM DUAL;

--실습3
--EMPLOYEE 테이블에서
--입사한 달의 숫자가 홀수 달인
--직원의 사번, 사원명, 입사일 정보를
--조회하시오.


SELECT EMP_ID "사번",
           EMP_NAME "사원명",
           HIRE_DATE "입사일"
FROM EMPLOYEE
WHERE MOD (SUBSTR(HIRE_DATE, 5, 1) , 2)= 1;

--SYSDATE, MONTHS_BETWEEN, ADD_MONTHS,
--EXTRACT, LAST_DAY, NEXT_DAY

--오늘 날짜를 불러오는 함수
-- SYSDATE : 오늘 날짜만을 표시하는 함수
-- SYSTIMESTAMP : 오늘 날짜와 시간
SELECT SYSDATE,
            SYSTIMESTAMP
FROM DUAL;

-- NEXT_DAY(): 앞으로 다가올 가장 가까운 요일을 반환
SELECT NEXT_DAY(SYSDATE, '토요일'),
       NEXT_DAY(SYSDATE, '토'),
       NEXT_DAY(SYSDATE, 7)
FROM DUAL;
/* NEXT_DAY(SYSDATE, 'SATURDAY') 영어 입력 시 오류 발생 */

/* SELECT * FROM VSNLS_PARAMETERS;
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

SELECT NEXT_DAY(SYSDATE, 'SATURDAY')
FROM DUAL; 영어로 변환하여 SATURDAY가 읽히도록 변환하는 방법 

ALTER SESSION SET NLS_LANGUAGE = KOREAN; 한글로 다시 변환 */

-- 설정 정보를 데이터 베이스의 테이블 형태로 보고나하는 테이블을
-- 데이터 딕셔너리(데이터 사전)이라고 한다

--------------------------------------------------------------------------------
-- LAST_DAY() : 주어진 날짜의 마지막 일짜를 조회
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

-- 날짜값 끼리는 가장 최근 날짜일 수록 큰값으로 판단한다
-- +, - 의 연산 가능
SELECT (SYSDATE - 10) "날짜1",
        SYSDATE - TO_DATE('19/03/01', 'YY/MM/DD') "날짜2"
FROM DUAL;

-- 형변환 함수 --
-- TO_CHAR()
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS'),
       TO_CHAR(SYSDATE, 'AM HH24:MI:SS')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY'),
       TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY'),
       TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY'),
       TO_CHAR(SYSDATE, 'YEAR, Q') || '분기',
       TO_CHAR(SYSDATE, 'YEAR, Q"분기"')
FROM DUAL;

--------------------------------------------------------------------------------
-- Y / R
SELECT TO_DATE('190325', 'YYMMDD'),
       TO_DATE('190325', 'RRMMDD')
FROM DUAL;

SELECT TO_CHAR(TO_DATE('190325', 'YYMMDD'), 'YYYY'),
       TO_CHAR(TO_DATE('190325', 'RRMMDD'), 'RRRR'),
       TO_CHAR(TO_DATE('800325', 'YYMMDD'), 'YYYY'),
       TO_CHAR(TO_DATE('800325', 'RRMMDD'), 'RRRR')
FROM DUAL;

-- YY
-- 80 -> 2080
-- RR
-- 51~99 -> 1900년대
-- 00~50 -> 2000년대

-- YY는 현세기 기준으로 값 추가
-- RR은 반세기 기준으로 값 추가
        
        
--GROUP BY--













