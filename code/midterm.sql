CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    teacher_id INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

CREATE TABLE teacher (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);
CREATE TABLE student_course (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (course_id) REFERENCES course(id)
);

INSERT INTO teacher (first_name, last_name)
VALUES 
('Taylah', 'Booker'),
('Sarah-Louise', 'Blake');

INSERT INTO course (name, teacher_id)
VALUES 
('Database design', 1),
('English literature', 2),
('Python programming', 1);

INSERT INTO student (first_name, last_name)
VALUES 
('Shreya', 'Bain'),
('Rianna', 'Foster'),
('Yosef', 'Naylor');

INSERT INTO student_course (student_id, course_id)
VALUES 
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1);


SELECT 
    s.id AS student_id, 
    s.first_name AS student_first_name, 
    s.last_name AS student_last_name, 
    c.id AS course_id, 
    c.name AS course_name, 
    t.first_name AS teacher_first_name, 
    t.last_name AS teacher_last_name
FROM 
    student s
INNER JOIN student_course sc ON s.id = sc.student_id
INNER JOIN course c ON sc.course_id = c.id
INNER JOIN teacher t ON c.teacher_id = t.id;

SELECT 
    s.first_name AS student_first_name, 
    s.last_name AS student_last_name
FROM 
    student s
INNER JOIN student_course sc ON s.id = sc.student_id
INNER JOIN course c ON sc.course_id = c.id
WHERE 
    c.name = 'Database design';

SELECT 
    c.name AS course_name
FROM 
    course c
INNER JOIN teacher t ON c.teacher_id = t.id
WHERE 
    t.first_name = 'Taylah' 
    AND t.last_name = 'Booker';


-- 성이 "B"로 시작하는 학생 조회
SELECT 
    'Student' AS person_type, 
    s.first_name, 
    s.last_name
FROM 
    student s
WHERE 
    s.last_name LIKE 'B%'

UNION

-- 성이 "B"로 시작하는 교사 조회
SELECT 
    'Teacher' AS person_type, 
    t.first_name, 
    t.last_name
FROM 
    teacher t
WHERE 
    t.last_name LIKE 'B%';



