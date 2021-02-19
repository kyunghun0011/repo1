---------------------------------------------------------
-- 1번

-- 먼저 ddl.sql을 이용하여 테이블 생성합니다.

-- 그다음 import csv file 합니다 (데이터셋은 로컬 파일 경로 매핑)

COPY concept
FROM '/home/master/workspace/linewalks/concept.csv'
DELIMITER ',' CSV HEADER;

COPY condition_occurrence
FROM '/home/master/workspace/linewalks/condition_occurrence.csv'
DELIMITER ',' CSV HEADER;

COPY death
FROM '/home/master/workspace/linewalks/death.csv'
DELIMITER ',' CSV HEADER;

COPY drug_exposure
FROM '/home/master/workspace/linewalks/drug_exposure.csv'
DELIMITER ',' CSV HEADER;

COPY person
FROM '/home/master/workspace/linewalks/person.csv'
DELIMITER ',' CSV HEADER;

COPY visit_occurrence
FROM '/home/master/workspace/linewalks/visit_occurrence.csv'
DELIMITER ',' CSV HEADER;

-- 테이블에 데이터 넣은 뒤 카운터 확인합니다. 

SELECT COUNT(*) FROM concept; -- 7403692

SELECT COUNT(*) FROM condition_occurrence; -- 12167
 
SELECT COUNT(*) FROM death; -- 41810

SELECT COUNT(*) FROM drug_exposure; -- 46579

SELECT COUNT(*) FROM person; -- 1000

SELECT COUNT(*) FROM visit_occurrence; -- 41810


---------------------------------------------------------
-- 2번
-- 전체 데이터

 -- 모든 환자에 대한 총 내원일수(환자별 내원일수)
SELECT PERSON_ID
     , SUM(VISIT_END_DATE - VISIT_START_DATE + 1) AS 내원일수
  FROM VISIT_OCCURRENCE
 GROUP BY PERSON_ID
 ORDER BY PERSON_ID
;

-- 총 내원일수 최대값 
SELECT MAX(LST.내원일수)
  FROM (
		SELECT SUM(VISIT_END_DATE - VISIT_START_DATE + 1) AS 내원일수
		  FROM VISIT_OCCURRENCE
		 GROUP BY PERSON_ID	  
  ) LST
;
  
---------------------------------------------------------  
-- 3번

SELECT DISTINCT CP.CONCEPT_NAME
  FROM CONDITION_OCCURRENCE CO
  LEFT OUTER JOIN CONCEPT CP ON CP.CONCEPT_ID = CO.CONDITION_CONCEPT_ID
 WHERE (UPPER(CP.CONCEPT_NAME)  LIKE 'A%'
    OR  UPPER(CP.CONCEPT_NAME)  LIKE 'B%'
    OR  UPPER(CP.CONCEPT_NAME)  LIKE 'C%'
    OR  UPPER(CP.CONCEPT_NAME)  LIKE 'D%'
    OR  UPPER(CP.CONCEPT_NAME)  LIKE 'E%')
   AND  UPPER(CP.CONCEPT_NAME)  LIKE '%HEART%' 
 ORDER BY CP.CONCEPT_NAME DESC
 ;
 
 -- DISTINCT를 사용하여 중복된 상병 이름 제거합니다.
 -- ANSI 표준 쿼리 사용하여 LEFT OUTER JOIN 실행합니다.
 -- A,B,C,D,E로 시작하는 문자와 HEART문자가 포함된 데이터 검색합니다.
 -- >> Chronic congestive heart failure
---------------------------------------------------------
-- 4번

SELECT PERSON_ID, DRUG_CONCEPT_ID
     , SUM(DRUG_EXPOSURE_END_DATE - DRUG_EXPOSURE_START_DATE) AS 복용일
  FROM DRUG_EXPOSURE
 WHERE PERSON_ID = 1891866
 GROUP BY PERSON_ID, DRUG_CONCEPT_ID
 ORDER BY SUM(DRUG_EXPOSURE_END_DATE - DRUG_EXPOSURE_START_DATE) DESC

 -- 환자번호 1894866의 처방된 약의 종류별로 복용일을 집계하여 가장 긴 순으로 정렬하였습니다.

---------------------------------------------------------
-- 5번

-- 임시 테이블 생성
CREATE TEMPORARY TABLE DRUG_PAIR (DRUG_CONCEPT_ID1 INT, DRUG_CONCEPT_ID2 INT);
-- 임시 테이블 데이터 생성
INSERT INTO DRUG_PAIR 
VALUES (40213154,19078106),
		(19078106,40213154),
		(19009384,19030765),
		(40224172,40213154),
		(19127663,19009384),
		(1511248,40169216),
		(40169216,1511248),
		(1539463,19030765),
		(19126352,1539411),
		(1539411,19126352),
		(1332419,19126352),
		(40163924,19078106),
		(19030765,19009384),
		(19106768,40213154),
		(19075601,19126352);

wITH DRUG_LIST AS (
	 SELECT DISTINCT DRUG_CONCEPT_ID, CONCEPT_NAME, COUNT(*) AS CNT 
	   FROM DRUG_EXPOSURE 
	   JOIN CONCEPT
	  	 ON DRUG_CONCEPT_ID = CONCEPT_ID
	  WHERE CONCEPT_ID IN (
			40213154,19078106,19009384,40224172,19127663,1511248,40169216,1539463,
			19126352,1539411,1332419,40163924,19030765,19106768,19075601)
	  GROUP BY DRUG_CONCEPT_ID,CONCEPT_NAME
	  ORDER BY COUNT(*) DESC)
    , DRUGS 			 AS (SELECT DRUG_CONCEPT_ID, CONCEPT_NAME FROM DRUG_LIST)
    , PRESCRIPTION_COUNT AS (SELECT DRUG_CONCEPT_ID, CNT 		  FROM DRUG_LIST)
SELECT A.CONCEPT_NAME
  FROM DRUG_LIST A
  LEFT OUTER JOIN DRUG_PAIR P ON P.DRUG_CONCEPT_ID1 = A.DRUG_CONCEPT_ID
 WHERE (SELECT X.CNT FROM PRESCRIPTION_COUNT X WHERE X.DRUG_CONCEPT_ID = P.DRUG_CONCEPT_ID2) > A.CNT
 ORDER BY A.CNT
 -- 두번째 약의 처방 건수가 첫번째 약의 처방 건수보다 
 --   더 많은 첫번째 약의 약품명을 처방건수 순으로 출력합니다


---------------------------------------------------------
-- 6.

SELECT E.PERSON_ID
     , E.DRUG_CONCEPT_ID
     , E.DRUG_EXPOSURE_END_DATE - E.DRUG_EXPOSURE_START_DATE 복용일
     , DATE_PART('YEAR', AGE(NOW(), P.BIRTH_DATETIME)) ::INT AS AGE
  FROM DRUG_EXPOSURE E
 INNER JOIN PERSON P ON P.PERSON_ID = E.PERSON_ID
 WHERE DRUG_CONCEPT_ID IN (3191208,36684827,3194332,3193274,43531010,4130162,45766052,
						   45757474,4099651,4129519,4063043,4230254,4193704,4304377,
						   201826, 3194082,3192767)
   AND DATE_PART('YEAR', AGE(NOW(), P.BIRTH_DATETIME)) ::INT >= 18
   AND DRUG_CONCEPT_ID = 40163924
   AND (E.DRUG_EXPOSURE_END_DATE - E.DRUG_EXPOSURE_START_DATE) >= 90
 ;
 -- condition_concept_id 가 당뇨환자인 경우에서
 -- 그리고 AGE와 DATE_PART를 이용하여 나이를 구하여 18세 이상이면서
 -- 복용일이 90일 이상인 환자를 검색합니다.

 -- 제공된 데이터에서는 해당 당뇨환자가 없어서 검색 조건 데이터를 변경하면서 테스트하였습니다.

---------------------------------------------------------
-- 7	
WITH METFORMIN_LIST AS 
(
	 SELECT E.*
	   FROM DRUG_EXPOSURE E
	  INNER JOIN PERSON P ON P.PERSON_ID = E.PERSON_ID
	  WHERE DRUG_CONCEPT_ID IN (3191208,36684827,3194332,3193274,43531010,4130162,45766052,
								45757474,4099651,4129519,4063043,4230254,4193704,4304377,
								201826, 3194082,3192767)
)
SELECT PERSON_ID, DRUG_CONCEPT_ID, DRUG_EXPOSURE_START_DATE
  FROM METFORMIN_LIST
 WHERE DRUG_CONCEPT_ID IN (19018935, 1539411,1539463, 19075601, 1115171)
 GROUP BY PERSON_ID, DRUG_CONCEPT_ID, DRUG_EXPOSURE_START_DATE
 ORDER BY DRUG_EXPOSURE_START_DATE
  ;

 -- 6.a 항목에서 추출한 데이터를 이용하여 
 -- 같은 날 처방된 약을 그룹별로 묶습니다.

 -- 제공된 데이터에서는 해당 당뇨환자가 없어서 검색 조건 데이터를 변경하면서 테스트하였습니다.