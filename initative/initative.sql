

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY ,
    name VARCHAR(100),
    expertise VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY ,
    title VARCHAR(100),
    category VARCHAR(50),
    instructor_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE participants (
    participant_id INT PRIMARY KEY ,
    name VARCHAR(100),
    age INT,
    email VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY ,
    participant_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY,
    enrollment_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);
-- Get all courses in the 'Technology' category
SELECT * FROM courses WHERE category = 'Technology';

-- List all instructors with 'Data Science' expertise
SELECT * FROM instructors WHERE expertise LIKE '%Data Science%';

-- Find participants older than 30
SELECT * FROM participants WHERE age > 30;
-- List courses with instructor names
SELECT c.title, i.name AS instructor
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- Show participant names and the courses they enrolled in
SELECT p.name AS participant, c.title AS course
FROM enrollments e
JOIN participants p ON e.participant_id = p.participant_id
JOIN courses c ON e.course_id = c.course_id;
-- Find participants who gave a rating of 5
SELECT name FROM participants
WHERE participant_id IN (
    SELECT e.participant_id
    FROM enrollments e
    JOIN feedback f ON e.enrollment_id = f.enrollment_id
    WHERE f.rating = 5
);
-- Average rating per course
SELECT c.title, AVG(f.rating) AS avg_rating
FROM feedback f
JOIN enrollments e ON f.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.title;

-- Count of enrollments per category
SELECT category, COUNT(*) AS total_enrollments
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY category;
-- Add indexes to frequently queried columns
CREATE INDEX idx_category ON courses(category);
CREATE INDEX idx_expertise ON instructors(expertise);
CREATE INDEX idx_rating ON feedback(rating);
