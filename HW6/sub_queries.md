### 1.1. Подзапрос в SELECT
**Что хотим получить:** Вывести имя студента и общее количество всех оценок в базе.
```sql
SELECT 
    first_name, 
    last_name, 
    (SELECT COUNT(*) FROM Grades) AS total_grades_in_db
FROM Students;
```
Результат выполнения запроса — <img width="472" height="144" alt="image" src="https://github.com/user-attachments/assets/95c9e522-2c31-4a80-8493-a446ad936b8a" />


**Что хотим получить:** Вывести название курса и средний балл по этому курсу.
```sql
SELECT 
    course_name, 
    (SELECT AVG(grade_value) FROM Grades g WHERE g.course_id = c.course_id) AS avg_course_grade
FROM Courses c;
```
Результат выполнения запроса — <img width="347" height="120" alt="image" src="https://github.com/user-attachments/assets/0540bfc8-0e6b-43fb-92ca-575e31f91fae" />


---

### 1.2. Подзапрос в FROM
**Что хотим получить:** Вывести средний балл по группам, используя подзапрос как таблицу.
```sql
SELECT 
    group_id, 
    AVG(avg_grade) AS group_avg
FROM (
    SELECT s.group_id, s.student_id, AVG(g.grade_value) AS avg_grade
    FROM Students s
    JOIN Grades g ON s.student_id = g.student_id
    GROUP BY s.group_id, s.student_id
) AS student_averages
GROUP BY group_id;
```
Результат выполнения запроса — <img width="263" height="122" alt="image" src="https://github.com/user-attachments/assets/bb76748f-2561-4c50-a983-a24aaf7c239c" />


**Что хотим получить:** Вывести преподавателей, у которых больше 1 курса, используя подзапрос.
```sql
SELECT teacher_id, course_count
FROM (
    SELECT teacher_id, COUNT(course_id) AS course_count
    FROM Courses
    GROUP BY teacher_id
) AS t_counts
WHERE course_count >= 1;
```
Результат выполнения запроса — <img width="256" height="121" alt="image" src="https://github.com/user-attachments/assets/8990d439-31e9-4c3a-b43c-c0da161ebb39" />


---

### 1.3. Подзапрос в WHERE
**Что хотим получить:** Вывести студентов, у которых есть хотя бы одна оценка 5.
```sql
SELECT first_name, last_name
FROM Students
WHERE student_id IN (
    SELECT student_id FROM Grades WHERE grade_value = 5
);
```
Результат выполнения запроса — <img width="346" height="96" alt="image" src="https://github.com/user-attachments/assets/d295a650-5dd0-49ee-82ae-37a3a39d4b58" />


**Что хотим получить:** Вывести преподавателей, которые ведут курс "Базы данных".
```sql
SELECT first_name, last_name
FROM Teachers
WHERE teacher_id = (
    SELECT teacher_id FROM Courses WHERE course_name = 'Базы данных'
);
```
Результат выполнения запроса — <img width="346" height="70" alt="image" src="https://github.com/user-attachments/assets/f5fd1145-105e-48cf-a8fa-569bc4b0a05a" />


---

### 1.4. Подзапрос в HAVING
**Что хотим получить:** Вывести группы, средний балл которых выше среднего балла по всему университету.
```sql
SELECT s.group_id, AVG(g.grade_value) AS group_avg
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
GROUP BY s.group_id
HAVING AVG(g.grade_value) > (
    SELECT AVG(grade_value) FROM Grades
);
```
Результат выполнения запроса —<img width="272" height="66" alt="image" src="https://github.com/user-attachments/assets/d3c09764-7600-4d85-8428-b5e89e1f87fa" />


**Что хотим получить:** Вывести курсы, максимальная оценка по которым выше среднего балла по этому курсу.
```sql
SELECT course_id, MAX(grade_value) AS max_grade
FROM Grades
GROUP BY course_id
HAVING MAX(grade_value) > (
    SELECT AVG(grade_value) FROM Grades g2 WHERE g2.course_id = Grades.course_id
);
```
Результат выполнения запроса — <img width="223" height="68" alt="image" src="https://github.com/user-attachments/assets/663fc323-55a0-411e-9a3b-45c4cd9c4228" />


---

### 1.5. ALL, IN, ANY, EXIST
**IN (Что хотим получить):** Студенты, у которых есть оценки 4 или 5.
```sql
SELECT first_name, last_name
FROM Students
WHERE student_id IN (SELECT student_id FROM Grades WHERE grade_value IN (4, 5));
```
Результат выполнения запроса — <img width="342" height="148" alt="image" src="https://github.com/user-attachments/assets/18097294-0f9d-4bfa-a911-8fb7d313e0e8" />


**ALL (Что хотим получить):** найти студентов, чей ID больше, чем ВСЕ ID из списка.
```sql
SELECT first_name, last_name
FROM Students
WHERE student_id > ALL (
    SELECT student_id FROM Grades WHERE grade_value = 2
);
```
Результат выполнения запроса — <img width="355" height="160" alt="image" src="https://github.com/user-attachments/assets/e5564260-7369-4f22-834d-052245e8b4b2" />


**ANY (Что хотим получить):** Преподаватели, которые ведут курс с количеством кредитов > 3.
```sql
SELECT first_name, last_name
FROM Teachers
WHERE teacher_id = ANY (
    SELECT teacher_id FROM Courses WHERE credits > 3
);
```
Результат выполнения запроса — <img width="698" height="136" alt="image" src="https://github.com/user-attachments/assets/9f269665-4d03-43ca-ab4d-3a07bd7419e7" />


**EXISTS (Что хотим получить):** Студенты, у которых есть хотя бы одна оценка.
```sql
SELECT first_name, last_name
FROM Students s
WHERE EXISTS (
    SELECT 1 FROM Grades g WHERE g.student_id = s.student_id
);
```
Результат выполнения запроса — <img width="359" height="154" alt="image" src="https://github.com/user-attachments/assets/eaadc130-6d03-4350-b568-ef4cafdafe9d" />


**EXISTS (Что хотим получить):** Группы, в которых нет ни одного студента.
```sql
SELECT group_name
FROM Groups gr
WHERE NOT EXISTS (
    SELECT 1 FROM Students s WHERE s.group_id = gr.group_id
);
```
Результат выполнения запроса — <img width="211" height="69" alt="image" src="https://github.com/user-attachments/assets/a68fe18e-bb04-41e6-befa-84531175a38e" />


---

### 1.6. Сравнение по нескольким столбцам
**Что хотим получить:** Найти оценки, которые совпадают по студенту и курсу с оценкой 5 (например, найти дубликаты).
```sql
SELECT grade_id, student_id, course_id, grade_value
FROM Grades
WHERE (student_id, course_id) IN (
    SELECT student_id, course_id FROM Grades WHERE grade_value = 5
);
```
Результат выполнения запроса — <img width="425" height="103" alt="image" src="https://github.com/user-attachments/assets/476dc032-953e-4197-99ff-50b36fd9c52c" />


**Что хотим получить:** Найти студентов, которые учатся в той же группе и имеют тот же средний балл, что и Алексей.
```sql
SELECT first_name, last_name
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
WHERE (s.group_id, g.grade_value) IN (
    SELECT s2.group_id, g2.grade_value
    FROM Students s2
    JOIN Grades g2 ON s2.student_id = g2.student_id
    WHERE s2.first_name = 'Алексей'
);
```
Результат выполнения запроса — <img width="340" height="122" alt="image" src="https://github.com/user-attachments/assets/6c971a9c-e2e0-4f4d-b6e2-1d7fea555424" />


---

## 2. Коррелированные подзапросы (5 шт.)

Коррелированный подзапрос — это подзапрос, который зависит от внешнего запроса (использует его столбцы).

**1. Студенты, у которых средний балл выше среднего балла по их группе.**
```sql
SELECT s.first_name, s.last_name
FROM Students s
WHERE (
    SELECT AVG(grade_value) FROM Grades g WHERE g.student_id = s.student_id
) > (
    SELECT AVG(grade_value) 
    FROM Grades g2 
    JOIN Students s2 ON g2.student_id = s2.student_id 
    WHERE s2.group_id = s.group_id
);
```
Результат выполнения запроса — <img width="345" height="59" alt="image" src="https://github.com/user-attachments/assets/46fe8b9d-13b7-428b-bf62-73195aac5bdf" />


**2. Группы, в которых учатся только отличники (нет ни одной оценки ниже 4).**
```sql
SELECT group_name
FROM Groups gr
WHERE NOT EXISTS (
    SELECT 1 
    FROM Students s 
    JOIN Grades g ON s.student_id = g.student_id 
    WHERE s.group_id = gr.group_id AND g.grade_value < 4
);
```
Результат выполнения запроса — <img width="420" height="250" alt="image" src="https://github.com/user-attachments/assets/a312c0fb-83cf-4626-b150-ad44df38a8fa" />


**3. Курсы, у которых количество оценок больше, чем среднее количество оценок на курс.**
```sql
SELECT course_name
FROM Courses c
WHERE (
    SELECT COUNT(*) FROM Grades g WHERE g.course_id = c.course_id
) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM Grades GROUP BY course_id) AS avg_counts
);
```
Результат выполнения запроса — <img width="205" height="93" alt="image" src="https://github.com/user-attachments/assets/aac8bfa0-df18-4a8e-8ca0-2678313a1d73" />


**4. Преподаватели, чьи курсы посещают студенты из группы 'ПИ-21-1'.**
```sql
SELECT t.first_name, t.last_name
FROM Teachers t
WHERE EXISTS (
    SELECT 1 
    FROM Courses c
    JOIN Grades g ON c.course_id = g.course_id
    JOIN Students s ON g.student_id = s.student_id
    JOIN Groups gr ON s.group_id = gr.group_id
    WHERE c.teacher_id = t.teacher_id AND gr.group_name = 'ПИ-21-1'
);
```
Результат выполнения запроса — <img width="359" height="102" alt="image" src="https://github.com/user-attachments/assets/7b4b71d9-29e6-422b-87b9-5fe59bc54636" />


**5. Студенты, которые получили максимальный балл по какому-либо курсу.**
```sql
SELECT s.first_name, s.last_name, c.course_name, g.grade_value
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
JOIN Courses c ON g.course_id = c.course_id
WHERE g.grade_value = (
    SELECT MAX(g2.grade_value)
    FROM Grades g2
    WHERE g2.course_id = g.course_id
);
```
Результат выполнения запроса — <img width="604" height="150" alt="image" src="https://github.com/user-attachments/assets/25cb131e-ec74-4861-996c-c6b40f0088b7" />
