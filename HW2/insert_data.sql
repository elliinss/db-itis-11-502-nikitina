INSERT INTO Groups (group_id, group_name, faculty) VALUES
(1, 'ПИ-21-1', 'Информатика'),
(2, 'ПИ-21-2', 'Информатика'),
(3, 'ЭК-21-1', 'Экономика');

INSERT INTO Teachers (teacher_id, first_name, last_name, department) VALUES
(1, 'Иван', 'Иванов', 'Кафедра ИТ'),
(2, 'Петр', 'Петров', 'Кафедра Математики'),
(3, 'Анна', 'Сидорова', 'Кафедра Экономики');

INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES
(1, 'Алексей', 'Смирнов', 1),
(2, 'Мария', 'Кузнецова', 1),
(3, 'Дмитрий', 'Попов', 2),
(4, 'Елена', 'Васильева', 3);

INSERT INTO Courses (course_id, course_name, credits, teacher_id) VALUES
(1, 'Базы данных', 4, 1),
(2, 'Высшая математика', 3, 2),
(3, 'Экономика предприятия', 3, 3);

INSERT INTO Grades (grade_id, student_id, course_id, grade_value, date) VALUES
(1, 1, 1, 5, '2024-01-15'),
(2, 2, 1, 4, '2024-01-16'),
(3, 3, 2, 3, '2024-01-17'),
(4, 4, 3, 5, '2024-01-18'),
(5, 1, 2, 4, '2024-01-19');