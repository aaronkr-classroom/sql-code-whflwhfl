-- 교수 테이블
CREATE TABLE 교수 (
    교번 INT PRIMARY KEY,
    교수명 VARCHAR(100) NOT NULL
);

-- 강의실 테이블
CREATE TABLE 강의실 (
    강의실번호 INT PRIMARY KEY,
    좌석수 INT NOT NULL
);

-- 교과목 테이블
CREATE TABLE 교과목 (
    과목번호 INT PRIMARY KEY,
    과목명 VARCHAR(100) NOT NULL
);

-- 학생 테이블
CREATE TABLE 학생 (
    학번 INT PRIMARY KEY,
    학생명 VARCHAR(100) NOT NULL
);

-- 강의 테이블
CREATE TABLE 강의 (
    강의ID INT PRIMARY KEY AUTO_INCREMENT,
    교번 INT NOT NULL,
    강의실번호 INT NOT NULL,
    FOREIGN KEY (교번) REFERENCES 교수(교번),
    FOREIGN KEY (강의실번호) REFERENCES 강의실(강의실번호)
);

-- 수강신청 테이블
CREATE TABLE 수강신청 (
    수강ID INT PRIMARY KEY AUTO_INCREMENT,
    학번 INT NOT NULL,
    과목번호 INT NOT NULL,
    신청날짜 DATE NOT NULL,
    취소여부 BOOLEAN DEFAULT FALSE,
    취소날짜 DATE,
    FOREIGN KEY (학번) REFERENCES 학생(학번),
    FOREIGN KEY (과목번호) REFERENCES 교과목(과목번호)
);

-- 멘토링 테이블 (자기 참조 관계)
CREATE TABLE 멘토링 (
    멘토링ID INT PRIMARY KEY AUTO_INCREMENT,
    멘토학번 INT NOT NULL,
    멘티학번 INT NOT NULL,
    FOREIGN KEY (멘토학번) REFERENCES 학생(학번),
    FOREIGN KEY (멘티학번) REFERENCES 학생(학번),
    CHECK (멘토학번 <> 멘티학번) -- 멘토와 멘티는 서로 다르게 설정
);
