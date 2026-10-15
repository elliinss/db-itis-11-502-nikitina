### COUNT() — количество

**Запрос 1.** Посчитать общее количество студентов.
**Что хотим получить:** Общее число студентов в базе.

```sql
SELECT COUNT(*) AS total_students
FROM Students;
```

**Запрос 2.** Посчитать количество студентов в каждой группе.
**Что хотим получить:** Сколько человек учится в каждой группе.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id;
```

---

### SUM() — сумма

**Запрос 1.** Посчитать сумму всех кредитов по курсам.
**Что хотим получить:** Общее количество кредитов всех курсов.

```sql
SELECT SUM(credits) AS total_credits
FROM Courses;
```

**Запрос 2.** Посчитать сумму кредитов по каждому преподавателю.
**Что хотим получить:** Сколько кредитов ведёт каждый преподаватель.

```sql
SELECT teacher_id, SUM(credits) AS total_credits
FROM Courses
GROUP BY teacher_id;
```

---

### AVG() — среднее

**Запрос 1.** Средний балл по всем оценкам.
**Что хотим получить:** Средний балл среди всех студентов.

```sql
SELECT AVG(grade_value) AS avg_grade
FROM Grades;
```

**Запрос 2.** Средний балл по каждому курсу.
**Что хотим получить:** Какой средний балл у студентов по каждому предмету.

```sql
SELECT course_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY course_id;
```
---

### MIN() — минимум

**Запрос 1.** Минимальная оценка по всем студентам.
**Что хотим получить:** Самая низкая оценка в базе.

```sql
SELECT MIN(grade_value) AS min_grade
FROM Grades;
```

**Запрос 2.** Минимальная оценка по каждому курсу.
**Что хотим получить:** Самый низкий балл по каждому предмету.

```sql
SELECT course_id, MIN(grade_value) AS min_grade
FROM Grades
GROUP BY course_id;
```

---

### MAX() — максимум

**Запрос 1.** Максимальная оценка по всем студентам.
**Что хотим получить:** Самая высокая оценка в базе.

```sql
SELECT MAX(grade_value) AS max_grade
FROM Grades;
```

**Запрос 2.** Максимальная оценка по каждому курсу.
**Что хотим получить:** Самый высокий балл по каждому предмету.

```sql
SELECT course_id, MAX(grade_value) AS max_grade
FROM Grades
GROUP BY course_id;
```

---

### STRING_AGG() — объединение строк

**Запрос 1.** Собрать все фамилии студентов в одну строку.
**Что хотим получить:** Список всех фамилий через запятую.

```sql
SELECT STRING_AGG(last_name, ', ') AS all_last_names
FROM Students;
```

**Запрос 2.** Собрать названия курсов для каждого преподавателя в одну строку.
**Что хотим получить:** Список курсов каждого преподавателя через запятую.

```sql
SELECT teacher_id, STRING_AGG(course_name, ', ') AS courses
FROM Courses
GROUP BY teacher_id;
```

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

**Запрос 2.** Средний балл по каждому студенту.
**Что хотим получить:** Средняя оценка каждого студента.

```sql
SELECT student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY student_id;
```

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

**Запрос 2.** Студенты со средним баллом выше 4.
**Что хотим получить:** Студенты-отличники (средний балл > 4).

```sql
SELECT student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY student_id
HAVING AVG(grade_value) > 4;
```

---

## Часть c. GROUPING SETS, ROLLUP, CUBE 

### GROUPING SETS

**Запрос 1.** Количество студентов по группам и факультетам отдельно.
**Что хотим получить:** Сводка по группам и отдельно по факультетам.

```sql
SELECT group_id, faculty, COUNT(*) AS student_count
FROM Students s
JOIN Groups g ON s.group_id = g.group_id
GROUP BY GROUPING SETS ((group_id), (faculty));
```

**Запрос 2.** Средний балл по курсам и студентам отдельно.
**Что хотим получить:** Средний балл по каждому курсу и по каждому студенту.

```sql
SELECT course_id, student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY GROUPING SETS ((course_id), (student_id));
```

---

### ROLLUP

**Запрос 1.** Количество студентов по группам с итогом.
**Что хотим получить:** Число студентов по группам + общий итог.

```sql
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY ROLLUP (group_id);
```

**Запрос 2.** Средний балл по курсам и по всем курсам вместе.
**Что хотим получить:** Средний балл по каждому курсу + общий средний балл.

```sql
SELECT course_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY ROLLUP (course_id);
```

---

### CUBE

**Запрос 1.** Количество студентов по группам и факультетам со всеми комбинациями.
**Что хотим получить:** Все возможные комбинации группировок.

```sql
SELECT group_id, faculty, COUNT(*) AS student_count
FROM Students s
JOIN Groups g ON s.group_id = g.group_id
GROUP BY CUBE (group_id, faculty);
```

**Запрос 2.** Средний балл по курсам и студентам со всеми комбинациями.
**Что хотим получить:** Все возможные комбинации группировок.

```sql
SELECT course_id, student_id, AVG(grade_value) AS avg_grade
FROM Grades
GROUP BY CUBE (course_id, student_id);
```

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
