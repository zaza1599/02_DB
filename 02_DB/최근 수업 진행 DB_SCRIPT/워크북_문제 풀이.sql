-- 2-2번
-- 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 두 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL문장을 작성해보자.
-- (*이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇인지 생각해볼 것)
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_PROFESSOR
--WHERE LENGTH(PROFESSOR_NAME) != 3;
WHERE PROFESSOR_NAME NOT LIKE '___';

-- 2-3번
-- 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
-- 단 이 때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력 헤더는 "교수이름"으로 한다. 나이는 '만'으로 계산한다.)

SELECT PROFESSOR_NAME, 
FLOOR( MONTHS_BETWEEN ( SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1 ,6), 'YYYYMMDD') ) / 12 )  나이

FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 나이;


-- 3-3번
-- 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 
-- 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오.
-- 단, 출력헤더에는 "학생이름", "학번", "거주지 주소"가 출력되도록 한다.

SELECT STUDENT_NAME "학생이름", STUDENT_NO "학번", STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO LIKE '9%'
AND (STUDENT_ADDRESS LIKE '경기도%'
    OR  STUDENT_ADDRESS LIKE '강원도%');

-- 3-5번
-- 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
-- 학점이 높은 학생부터 표시하고,
-- 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해 보시오.

SELECT STUDENT_NO, TO_CHAR(POINT, '9.00') POINT
FROM TB_GRADE
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;


-- 3-13번
-- 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 
-- 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;


-- 3-14번
-- 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우
-- "지도교수 미지정"으로 표시하도록 하는 SQL 문을 작성하시오.
-- 단 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.

SELECT STUDENT_NAME "학생이름", NVL(PROFESSOR_NAME, '지도교수 미지정') "지도교수"
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

-- 3-15번
-- 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 
-- 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME "학과 이름", ROUND(AVG(POINT),8) 평점
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 학번;

                
-- 3-18번
-- 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오

SELECT STUDENT_NO, STUDENT_NAME
FROM (
    SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT) 평점
    FROM TB_STUDENT
    JOIN TB_GRADE USING(STUDENT_NO)
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '국어국문학과'
    GROUP BY STUDENT_NO, STUDENT_NAME
    ORDER BY 평점 DESC)
WHERE ROWNUM = 1;


-- 3-19번
-- 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 
-- 학과 별 전공 과목 평점을 파악하기 위한 적절한 SQL문을 찾아내시오.
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 
-- 평점은 소수점 한 자리 까지만 반올림하여 표시되도록 한다.
SELECT DEPARTMENT_NAME "계열 학과명", ROUND( AVG(POINT) , 1) "전공평점"
FROM TB_DEPARTMENT 
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY = (SELECT CATEGORY FROM TB_DEPARTMENT
                 WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY 1;

-- 2-15
SELECT NVL( SUBSTR(TERM_NO, 1, 4) , ' ' ) 년도, 
       NVL( SUBSTR(TERM_NO, 5, 2) , ' ' ) 학기, 
       ROUND( AVG(POINT) ,1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP( SUBSTR(TERM_NO, 1, 4) , SUBSTR(TERM_NO, 5, 2)  );

