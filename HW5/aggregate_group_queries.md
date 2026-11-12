### COUNT() — количество

**Запрос 1.** Посчитать общее количество студентов.
**Что хотим получить:** Общее число студентов в базе.

```sql
SELECT COUNT(*) AS total_students
FROM Students;
```
Результат - <img width="175" height="73" alt="image" src="https://github.com/user-attachments/assets/87db377a-a5a6-4dbe-a175-ce46af2bfa0e" />


**Запрос 2.** Посчитать количество студентов в каждой группе.
**Что хотим получить:** Сколько человек учится в каждой группе.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id;
```
Результат - <img width="236" height="123" alt="image" src="https://github.com/user-attachments/assets/7025b359-16b0-4901-aded-10a1edcba963" />


---

### SUM() — сумма

**Запрос 1.** Посчитать сумму всех кредитов по курсам.
**Что хотим получить:** Общее количество кредитов всех курсов.

```sql
SELECT SUM(credits) AS total_credits
FROM Courses;
```
Результат - <img width="197" height="127" alt="image" src="https://github.com/user-attachments/assets/b063fdf7-2d7f-4276-8548-1d8f89302a5e" />


**Запрос 2.** Посчитать сумму кредитов по каждому преподавателю.
**Что хотим получить:** Сколько кредитов ведёт каждый преподаватель.

```sql
SELECT teacher_id, SUM(credits) AS total_credits
FROM Courses
GROUP BY teacher_id;
```
Результат - <img width="237" height="124" alt="image" src="https://github.com/user-attachments/assets/5209b9af-6bc2-4337-9c7b-517fd6879f6e" />


---

### AVG() — среднее

**Запрос 1.** Средний балл по всем оценкам.
**Что хотим получить:** Средний балл среди всех студентов.

```sql
SELECT AVG(grade_value) AS avg_grade
FROM Grades;
```
Результат - <img width="195" height="75" alt="image" src="https://github.com/user-attachments/assets/80423a85-bb5e-46b1-8dfd-8e7622f69e35" />


**Запрос 2.** Средний балл по каждому курсу.
**Что хотим получить:** Какой средний балл у студентов по каждому предмету.

```sql
SELECT course_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY course_id;
```
Результат - <img width="270" height="116" alt="image" src="https://github.com/user-attachments/assets/f3d627b8-1023-4418-8f69-3f8b3ba77371" />

---

### MIN() — минимум

**Запрос 1.** Минимальная оценка по всем студентам.
**Что хотим получить:** Самая низкая оценка в базе.

```sql
SELECT MIN(grade_value) AS min_grade
FROM Grades;
```
Результат - <img width="174" height="81" alt="image" src="https://github.com/user-attachments/assets/60a9cc9d-e543-46f5-ab9f-3fc3ce8c715b" />


**Запрос 2.** Минимальная оценка по каждому курсу.
**Что хотим получить:** Самый низкий балл по каждому предмету.

```sql
SELECT 
    c.course_id, 
    MIN(g.grade_value) AS min_grade
FROM Courses c
LEFT JOIN Grades g ON c.course_id = g.course_id
GROUP BY c.course_id;
```
Результат - <img width="466" height="294" alt="image" src="https://github.com/user-attachments/assets/df6a89de-c57e-4277-9928-d82d413a8aa8" />


---

### MAX() — максимум

**Запрос 1.** Максимальная оценка по всем студентам.
**Что хотим получить:** Самая высокая оценка в базе.

```sql
SELECT MAX(grade_value) AS max_grade
FROM Grades;
```
Результат - <img width="149" height="85" alt="image" src="https://github.com/user-attachments/assets/bf96244b-2012-4c82-9525-f1fb65d8b0a7" />


**Запрос 2.** Максимальная оценка по каждому курсу.
**Что хотим получить:** Самый высокий балл по каждому предмету.

```sql
SELECT course_id, MAX(grade_value) AS max_grade
FROM Grades
GROUP BY course_id;
```
Результат - <img width="259" height="138" alt="image" src="https://github.com/user-attachments/assets/aa41e010-dee6-4ab9-a0bd-53ebc1ea1f7b" />


---

### STRING_AGG() — объединение строк

**Запрос 1.** Собрать все фамилии студентов в одну строку.
**Что хотим получить:** Список всех фамилий через запятую.

```sql
SELECT STRING_AGG(last_name, ', ') AS all_last_names
FROM Students;
```
Результат - <img width="318" height="95" alt="image" src="https://github.com/user-attachments/assets/39378074-3b50-40fd-980b-47bb13e8d613" />


**Запрос 2.** Собрать названия курсов для каждого преподавателя в одну строку.
**Что хотим получить:** Список курсов каждого преподавателя через запятую.

```sql
SELECT teacher_id, STRING_AGG(course_name, ', ') AS courses
FROM Courses
GROUP BY teacher_id;
```
Результат - <img width="382" height="120" alt="image" src="https://github.com/user-attachments/assets/84a09571-7704-4512-bae1-4e0d3846f563" />


---

## Часть b. GROUP BY и HAVING 

### GROUP BY

**Запрос 1.** Количество студентов в каждой группе.
**Что хотим получить:** Список групп и число студентов в них.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id;
```
Результат - <img width="260" height="132" alt="image" src="https://github.com/user-attachments/assets/4f78bc93-d6fe-4864-bfa6-a429cea3af1d" />


**Запрос 2.** Средний балл по каждому студенту.
**Что хотим получить:** Средняя оценка каждого студента.

```sql
SELECT student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY student_id;
```
Результат - <img width="286" height="171" alt="image" src="https://github.com/user-attachments/assets/b8326b1a-92d7-48eb-99f8-27009b2fd750" />


---

### HAVING

**Запрос 1.** Группы, в которых больше 1 студента.
**Что хотим получить:** Только те группы, где учится больше одного человека.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id
HAVING COUNT(*) > 1;
```
Результат - <img width="237" height="78" alt="image" src="https://github.com/user-attachments/assets/88959d30-c267-4870-ad1f-24824afa9e1c" />


**Запрос 2.** Студенты со средним баллом выше 4.
**Что хотим получить:** Студенты-отличники (средний балл > 4).

```sql
SELECT student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY student_id
HAVING AVG(grade_value) > 4;
```
Результат - <img width="289" height="120" alt="image" src="https://github.com/user-attachments/assets/4bce9414-58ac-4f58-99a5-e49957d0e232" />


---

## Часть c. GROUPING SETS, ROLLUP, CUBE 

### GROUPING SETS

**Запрос 1.** Количество студентов по группам и факультетам отдельно.
**Что хотим получить:** Сводка по группам и отдельно по факультетам.

```sql
SELECT g.group_id, faculty, COUNT(*) AS student_count
FROM Students s
JOIN Groups g ON s.group_id = g.group_id
GROUP BY GROUPING SETS ((g.group_id), (faculty));
```
Результат - <img width="403" height="178" alt="image" src="https://github.com/user-attachments/assets/d9bca919-0a82-4b89-86d3-e8ef162470f2" />


**Запрос 2.** Средний балл по курсам и студентам отдельно.
**Что хотим получить:** Средний балл по каждому курсу и по каждому студенту.

```sql
SELECT course_id, student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY GROUPING SETS ((course_id), (student_id));
```
Результат - <img width="350" height="215" alt="image" src="https://github.com/user-attachments/assets/b14620d8-eeed-4637-98d9-68d8ca385092" />


---

### ROLLUP

**Запрос 1.** Количество студентов по группам с итогом.
**Что хотим получить:** Число студентов по группам + общий итог.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY ROLLUP (group_id);
```
Результат - <img width="245" height="148" alt="image" src="https://github.com/user-attachments/assets/c936cfee-1f48-4544-9f91-9eed2c3a5451" />


**Запрос 2.** Средний балл по курсам и по всем курсам вместе.
**Что хотим получить:** Средний балл по каждому курсу + общий средний балл.

```sql
SELECT course_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY ROLLUP (course_id);
```
Результат - <img width="305" height="161" alt="image" src="https://github.com/user-attachments/assets/b5821e68-933e-4da2-ab1f-3ff4b6d9f9f1" />


---

### CUBE

**Запрос 1.** Количество студентов по группам и факультетам со всеми комбинациями.
**Что хотим получить:** Все возможные комбинации группировок.

```sql
SELECT g.group_id, faculty, COUNT(*) AS student_count
FROM Students s
JOIN Groups g ON s.group_id = g.group_id
GROUP BY CUBE (g.group_id, faculty);
```
Результат - <img width="405" height="266" alt="image" src="https://github.com/user-attachments/assets/1835d098-be44-430b-8dd0-0c8ae8c7f720" />


**Запрос 2.** Средний балл по курсам и студентам со всеми комбинациями.
**Что хотим получить:** Все возможные комбинации группировок.

```sql
SELECT course_id, student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY CUBE (course_id, student_id);
```
Результат - <img width="358" height="291" alt="image" src="https://github.com/user-attachments/assets/b84b16b9-bba6-480a-8b08-b9d877b6feea" />


---

## Часть d. SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY 

### Запрос 1. Полный синтаксис
**Что хотим получить:** Студенты с оценкой выше 3, средний балл > 4, отсортированные по убыванию.

```sql
SELECT 
    s.first_name,
    s.last_name,
    AVG(g.grade_value) AS avg_grade
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
WHERE g.grade_value > 3
GROUP BY s.student_id, s.first_name, s.last_name
HAVING AVG(g.grade_value) > 4
ORDER BY avg_grade DESC;
```
Результат - <img width="485" height="129" alt="image" src="https://github.com/user-attachments/assets/518e7503-3367-4bb7-a07e-4d851d84e929" />


### Запрос 2. Полный синтаксис
**Что хотим получить:** Преподаватели с курсами > 2 кредитов, у кого больше 1 курса, отсортированные по количеству.

```sql
SELECT 
    t.first_name,
    t.last_name,
    COUNT(c.course_id) AS course_count
FROM Teachers t
JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE c.credits > 2
GROUP BY t.teacher_id, t.first_name, t.last_name
HAVING COUNT(c.course_id) > 1
ORDER BY course_count DESC;
```
Результат - <img width="449" height="79" alt="image" src="https://github.com/user-attachments/assets/a16aeb0c-f96a-46d0-b807-429515bbe780" />

