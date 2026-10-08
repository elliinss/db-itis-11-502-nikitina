### Запрос 1.
**Формулировка:** Вывести оценки студентов и написать словами, что это за оценка.

```sql
SELECT 
    s.first_name,
    s.last_name,
    g.grade_value,
    CASE 
        WHEN g.grade_value = 5 THEN 'Отлично'
        WHEN g.grade_value = 4 THEN 'Хорошо'
        ELSE 'Удовлетворительно'
    END AS grade_text
FROM Grades g
JOIN Students s ON g.student_id = s.student_id;
```

### Запрос 2. Курс — "лёгкий" или "сложный"
**Формулировка:** Вывести курсы и указать, лёгкий он или сложный по количеству кредитов.

```sql
SELECT 
    course_name,
    credits,
    CASE 
        WHEN credits <= 3 THEN 'Лёгкий'
        ELSE 'Сложный'
    END AS difficulty
FROM Courses;
```

---

## Часть 2. JOIN 

### INNER JOIN

**Запрос 1.** Студенты и их группы.

```sql
SELECT s.first_name, s.last_name, gr.group_name
FROM Students s
INNER JOIN Groups gr ON s.group_id = gr.group_id;
```

**Запрос 2.** Оценки и названия курсов.

```sql
SELECT s.first_name, s.last_name, c.course_name, g.grade_value
FROM Grades g
INNER JOIN Students s ON g.student_id = s.student_id
INNER JOIN Courses c ON g.course_id = c.course_id;
```

---

### LEFT JOIN

**Запрос 1.** Все студенты, даже без оценок.

```sql
SELECT s.first_name, s.last_name, g.grade_value
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id;
```

**Запрос 2.** Все группы, даже без студентов.

```sql
SELECT gr.group_name, s.first_name, s.last_name
FROM Groups gr
LEFT JOIN Students s ON gr.group_id = s.group_id;
```

---

### RIGHT JOIN

**Запрос 1.** Все оценки и их студенты.

```sql
SELECT g.grade_value, s.first_name, s.last_name
FROM Grades g
RIGHT JOIN Students s ON g.student_id = s.student_id;
```

**Запрос 2.** Все преподаватели и их курсы.

```sql
SELECT t.first_name, t.last_name, c.course_name
FROM Courses c
RIGHT JOIN Teachers t ON c.teacher_id = t.teacher_id;
```

---

### CROSS JOIN

**Запрос 1.** Все комбинации студентов и курсов.

```sql
SELECT s.first_name, s.last_name, c.course_name
FROM Students s
CROSS JOIN Courses c;
```

**Запрос 2.** Все комбинации групп и преподавателей.

```sql
SELECT gr.group_name, t.first_name, t.last_name
FROM Groups gr
CROSS JOIN Teachers t;
```

---

### FULL OUTER JOIN

**Запрос 1.** Все студенты и все оценки.

```sql
SELECT s.first_name, s.last_name, g.grade_value
FROM Students s
FULL OUTER JOIN Grades g ON s.student_id = g.student_id;
```

**Запрос 2.** Все курсы и все оценки.

```sql
SELECT c.course_name, g.grade_value
FROM Courses c
FULL OUTER JOIN Grades g ON c.course_id = g.course_id;
```
