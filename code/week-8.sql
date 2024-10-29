EXPLAIN ANALYZE SELECT * FROM 수강2;

SELECT ABS(17), ABS(-17), CEL(3.28), FLOOR(4.97);

SELECT 학번, 
      SUM(기말성적)::FLOAT / COUNT(*) AS 평균성적,
      --ROUND(SUM(기말성적))::FLOAT / COUNT(*, 2)
      FROM 수강2;
      GROUP BY 학번;





SELECT SUBSTRING(주소, 1, 2), REPLACE (SUBSTRING(휴대번호, 5, 9), '-', '*')
FROM 학생;

--날짜/ 시간 내장 함수
SELECT 신청날짜, DATE_TRUNC('MONTH',신청날짜) +INTERVAL '1 MONTH - 1 DAY' AS 마지막날
FROM 수강2
WHERE EXTRACT(YEAR FROM 신청날짜) = 2019;
--2019/02/31

SELECT CURRENT_TIMESTAMP, 신청날짜 - DATE '2019-01-01' AS 일수차이
FROM 수강;

SELECT 신청날짜,
	TO_CHAR(신청날짜, 'Mon/DD/YY') AS 형식1,
	TO_CHAR(신청날짜, 'YYYY년"MM"월"YY"일"') AS 형식2
FROM 형식2 

--저장프로시저
CREATE OR REPLACE PROCEDURE InsertOrUpdateCourse(
	IN CourseNo VARCHAR(4),
	IN CourseName VARCHAR(20),
	IN CourseRoom VARCHAR(3),
	IN CourseDept VARCHAR(20),
	IN CourseCredit INT
	

)
	
LANGUAGE plpgsql
AS $$
DECLARE
	Count INT;
BEGIN
 --과목이 이미 존재하는지 확인 
 	SELECT COUNT(*) INTO Count FROM과복 WHERE 과목번호 = CourseNO;

	IF COUNT = 0 THEN --과목이 존재하지 않으면 새 과목 추가
		INSERT INTO 과목 (과목번호, 이름, 강의실, 개설학과, 시수 )
		VALUES (CourseNo, CourseName, CourseRoom,CourseDept, CourseCredit);
	ELSE --과목이 존재하면 기존 과목 어버데이트
		UPDATE 과목
		SET 이름 = CourseName, 강의실 = CourseRoom, 개설학과 = CourseDept, 시수 = CourseCrdit
		WHERE 과목번호 = CourseNo;
	END IF;
END;
$$;

--새 과목 추가하기 
CALL InsertOrUpdateCourse('c006', '연극학개론', '310', '교양학부', 2);
SELECT * FROM 과목;

--과목 업데이트하기
CALL InsertOrUpdateCourse('c006', '연극학개론', '310', '교양학부', 1);
SELECT * FROM 과목;

-- BestScore 프로시저
CREATE OR REPLACE PROCEDURE SelectAverageOfBestScore(

	IN Score INT,
	OUT Count Int
	
)
LANGUAGE plpgsql
AS $$
DECLARE
	NoMoreData BOOLEAN DEFAULT FALSE;
	Midterm INT;
	Final INT;
	Best INT;
	ScoreListCursor CURSOR FOR SELECT 중간성적, 기말성적, 기말성적 FROM 수강;

BEGIN 	
	Count := 0;
	OPEN ScoreListCursor;
	LOOP 	
		FETCH ScoreListCursor INTO Midterm, Final;
		EXIT WHEN NOT FOUND;

		--더 높은 성적을 BEST에 설정
		IF Midterm > Final THEN
			Best := Midterm;
		ELSE
			BEST := Final;
		END IF;

		--주어진 점수 이상인 경우 Count 증가
		IF Best >= Score THEN
			Count := Count + 1;
		END IF;
	END LOOP;
	CLOSE ScoreListCursor;
END;
$$;


--MySQL만 간단해
--CALL SelectAverageOfBestScore(95, @Count);
--SELECT @Count;

DO $$
DECLARE 
	Count INT;
BEGIN 
	CALL SelectAverageOfBestScore(96, Count);
	RAISE NOTICE 'Count: %', Count;
END;
$$;


--트리거
CREATE TABLE 남녀학생총수
	(성별 CHAR(1) NOT NULL DEFAULT 0,
	인원수 INT NOT NULL DEFAULT 0,
	PRIMARY KEY (성별));
INSERT INTO 남녀학생총수 SELECT '남', COUNT(*), COUNT(*) FROM 학생 WHERE 성별 ='남';
INSERT INTO 남녀학생총수 SELECT '여', COUNT(*), COUNT(*) FROM 학생 WHERE 성별 ='여';
SELECT * FROM 남녀학생총수;

CREATE OR REPLACE FUNCTION AfterInsertStudent()
RETURNS TRIGGER AS $$
BEGIN 
	IF (NEW.성별 = '남') THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '남';
	ELSEIF (NEW.성별 = '여')THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '여';
	END IF;
	RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_insert_student
AFTER INSERT ON 학생 FOR EACH ROW 
EXECUTE FUNCTION AfterInsertStudent();

INSERT INTO 학생
VALUES ('s008', '최동석', '경기 수원', 2, 26, '남', '010-8888-6666', '컴퓨터');

SELECT * FROM 남녀학생총수;


--사용자 정의 함수

CREATE OR REPLACE FUNCTION Fn_Grade(frade CHAR)
RETURNS TEXT AS $$
BEGIN
	CASE grade
		WHEN 'A' THEN RETURN '최우수';
		WHEN 'B' THEN RETURN '우수';
		WHEN 'C' THEN RETURN '보통';
		ELSE RETURN '미흡';
	END CASE;
END;
$$ LANGUAGE plpgsql;

SELECT 학번, 과목번호, 평가학점, Fn_Grade(평가학점) AS 평가등급 FROM 수강;

