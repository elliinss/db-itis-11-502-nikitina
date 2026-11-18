## 1. CTE (Common Table Expressions) 

### 1.1. Вывод среднего балла студентов через CTE
**Что хотим получить:** Список студентов и их средний балл.
```sql
WITH StudentAverages AS (
    SELECT student_id, AVG(grade_value) AS avg_grade
    FROM Grades
    GROUP BY student_id
)
SELECT s.first_name, s.last_name, sa.avg_grade
FROM Students s
JOIN StudentAverages sa ON s.student_id = sa.student_id;
```
Результат выполнения запроса — <img width="495" height="143" alt="image" src="https://github.com/user-attachments/assets/388f2a26-0cf3-41b1-ae11-c2428aceb5e4" />


### 1.2. Вывод статистики по группам через CTE
**Что хотим получить:** Название группы и количество студентов в ней.
```sql
WITH GroupStats AS (
    SELECT group_id, COUNT(student_id) AS student_count
    FROM Students
    GROUP BY group_id
)
SELECT g.group_name, gs.student_count
FROM Groups g
JOIN GroupStats gs ON g.group_id = gs.group_id;
```
Результат выполнения запроса — <img width="341" height="144" alt="image" src="https://github.com/user-attachments/assets/88a467df-c64c-44c8-b7e7-7b9c04dc95ee" />


### 1.3. Вывод курсов с количеством оценок через CTE
**Что хотим получить:** Название курса и сколько оценок по нему выставлено.
```sql
WITH CourseGrades AS (
    SELECT course_id, COUNT(grade_id) AS total_grades
    FROM Grades
    GROUP BY course_id
)
SELECT c.course_name, cg.total_grades
FROM Courses c
LEFT JOIN CourseGrades cg ON c.course_id = cg.course_id;
```
Результат выполнения запроса — <img width="646" height="294" alt="image" src="https://github.com/user-attachments/assets/b461e12f-d446-44c6-bd01-b0ce21caf04e" />


---

## 2. UNION, INTERSECT, EXCEPT 

### 2.1. UNION (Объединение)
**Что хотим получить:** Один общий список всех имен и фамилий (и студентов, и преподавателей).
```sql
SELECT first_name, last_name, 'Студент' AS role FROM Students
UNION
SELECT first_name, last_name, 'Преподаватель' AS role FROM Teachers;
```
Результат выполнения запроса — <img width="449" height="219" alt="image" src="https://github.com/user-attachments/assets/90cbae93-62fa-4274-85b0-362046ae53f2" />


### 2.2. INTERSECT (Пересечение)
**Что хотим получить:** Вывести ID студентов, которые получили и 5, и 4 (есть обе оценки).
```sql
SELECT student_id FROM Grades WHERE grade_value = 5
INTERSECT
SELECT student_id FROM Grades WHERE grade_value = 4;
```
Результат выполнения запроса — <img width="142" height="103" alt="image" src="https://github.com/user-attachments/assets/ce409866-b9fb-47d3-9cdc-c3b64a8384a3" />


### 2.3. EXCEPT (Разность)
**Что хотим получить:** Вывести группы, в которых есть студенты, но нет курсов.
```sql
SELECT group_id FROM Groups
EXCEPT
SELECT group_id FROM Students;
```
Результат выполнения запроса — <img width="288" height="154" alt="image" src="https://github.com/user-attachments/assets/8fd6bcec-4740-4ecb-be35-54e99ce0a85d" />


---

## 3. Оконные функции

### 3.1. PARTITION BY 
**Что хотим получить:** Вывести оценки и средний балл по этому студенту.
```sql
SELECT student_id, course_id, grade_value,
       AVG(grade_value) OVER (PARTITION BY student_id) AS avg_student_grade
FROM Grades;
```
Результат выполнения запроса — <img width="445" height="216" alt="image" src="https://github.com/user-attachments/assets/54c53b69-ea19-4e87-b250-70305eb909a8" />


**Что хотим получить:** Вывести студентов и их количество в группе (в каждой строке).
```sql
SELECT s.first_name, s.group_id,
       COUNT(s.student_id) OVER (PARTITION BY s.group_id) AS students_in_group
FROM Students s;
```
Результат выполнения запроса — <img width="399" height="136" alt="image" src="https://github.com/user-attachments/assets/9a2e58b9-2e88-46b2-a431-5f1519d4799e" />


### 3.2. PARTITION BY + ORDER BY 
**Что хотим получить:** Вывести оценки студента и накопленный итог.
```sql
SELECT student_id, grade_value, date,
       SUM(grade_value) OVER (PARTITION BY student_id ORDER BY date) AS running_total
FROM Grades;
```
Результат выполнения запроса — <img width="402" height="215" alt="image" src="https://github.com/user-attachments/assets/6e61b775-a416-4d5d-a60f-770245848f76" />


**Что хотим получить:** Вывести студентов и их позицию по алфавиту внутри группы.
```sql
SELECT group_id, first_name, last_name,
       ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY last_name) AS row_num
FROM Students;
```
Результат выполнения запроса — <img width="506" height="155" alt="image" src="https://github.com/user-attachments/assets/cde83f47-d0f5-4765-b4af-d14178b96b7f" />


### 3.3. ROWS и RANGE 
**Что хотим получить (ROWS):** Скользящее среднее по 2 предыдущим оценкам.
```sql
SELECT student_id, grade_value,
       AVG(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg
FROM Grades;
```
Результат выполнения запроса — <img width="728" height="432" alt="image" src="https://github.com/user-attachments/assets/2973f07b-346c-4522-8440-59dc0f13aaa2" />


**Что хотим получить (ROWS):** Сумма текущей и следующей оценки студента.
```sql
SELECT student_id, grade_value,
       SUM(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS sum_next
FROM Grades;
```
Результат выполнения запроса — <img width="648" height="430" alt="image" src="https://github.com/user-attachments/assets/d732f523-c0d1-4a6d-9600-bae639c42e2e" />


**Что хотим получить (RANGE):** Сумма всех оценок студента.
```sql
SELECT student_id, grade_value,
       SUM(grade_value) OVER (PARTITION BY student_id ORDER BY grade_value RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_sum
FROM Grades;
```
Результат выполнения запроса — <img width="311" height="212" alt="image" src="https://github.com/user-attachments/assets/803c15eb-11d5-450a-96ef-fc43a6cf3cbd" />


### 3.4. Ранжирующие функции 
**ROW_NUMBER:** Вывести студентов и их порядковый номер по ID.
```sql
SELECT first_name, last_name, ROW_NUMBER() OVER (ORDER BY student_id) AS row_num FROM Students;
```
Результат выполнения запроса — <img width="452" height="162" alt="image" src="https://github.com/user-attachments/assets/c701a6f3-8d92-4249-8388-bcd048aa32a5" />


**RANK:** Вывести оценки и ранг.
```sql
SELECT student_id, grade_value, RANK() OVER (ORDER BY grade_value DESC) AS rank_val FROM Grades;
```
Результат выполнения запроса — <img width="320" height="209" alt="image" src="https://github.com/user-attachments/assets/07a48ff9-39c6-40d9-a868-23f08717dcec" />


**DENSE_RANK:** Вывести оценки и плотный ранг.
```sql
SELECT student_id, grade_value, DENSE_RANK() OVER (ORDER BY grade_value DESC) AS dense_rank_val FROM Grades;
```
Результат выполнения запроса — <img width="349" height="216" alt="image" src="https://github.com/user-attachments/assets/0a8e9258-8ba5-4065-a896-785757155b26" />


### 3.5. Функции смещения 
**LAG:** Показать предыдущую оценку студента.
```sql
SELECT student_id, grade_id, grade_value,
       LAG(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id) AS prev_grade
FROM Grades;
```
Результат выполнения запроса — <img width="418" height="216" alt="image" src="https://github.com/user-attachments/assets/93c20657-856a-43d3-ab41-aaabc0e21e42" />


**LEAD:** Показать следующую оценку студента.
```sql
SELECT student_id, grade_id, grade_value,
       LEAD(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id) AS next_grade
FROM Grades;
```
Результат выполнения запроса — <img width="854" height="432" alt="image" src="https://github.com/user-attachments/assets/c1b2c5c2-8e37-4881-946e-8a693269b27b" />


**FIRST_VALUE:** Показать первую (самую раннюю) оценку студента.
```sql
SELECT student_id, grade_value,
       FIRST_VALUE(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id) AS first_grade
FROM Grades;
```
Результат выполнения запроса — <img width="654" height="438" alt="image" src="https://github.com/user-attachments/assets/ead9d0d3-0dfe-4aa3-b8cd-7b33dbaa7fa3" />


**LAST_VALUE:** Показать последнюю оценку.
```sql
SELECT student_id, grade_value,
       LAST_VALUE(grade_value) OVER (PARTITION BY student_id ORDER BY grade_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_grade
FROM Grades;
```
Результат выполнения запроса — <img width="322" height="215" alt="image" src="https://github.com/user-attachments/assets/436b1f91-0a56-47c4-bb2a-52e28338ab36" />
