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
Результат - <img width="519" height="221" alt="image" src="https://github.com/user-attachments/assets/f11c45be-01ff-4229-9bae-cd4698ad8c85" />


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
Результат - <img width="396" height="148" alt="image" src="https://github.com/user-attachments/assets/4bd1eecf-97c9-4187-a084-6fb7e75c5f80" />


---

## Часть 2. JOIN 

### INNER JOIN

**Запрос 1.** Студенты и их группы.

```sql
SELECT s.first_name, s.last_name, gr.group_name
FROM Students s
INNER JOIN Groups gr ON s.group_id = gr.group_id;
```
Результат - <img width="506" height="160" alt="image" src="https://github.com/user-attachments/assets/68019230-c36a-4c51-beb9-ed08eb81ffe5" />


**Запрос 2.** Оценки и названия курсов.

```sql
SELECT s.first_name, s.last_name, c.course_name, g.grade_value
FROM Grades g
INNER JOIN Students s ON g.student_id = s.student_id
INNER JOIN Courses c ON g.course_id = c.course_id;
```
Результат - <img width="611" height="221" alt="image" src="https://github.com/user-attachments/assets/43d764d0-b81b-46e2-ac5a-78908e05c780" />


---

### LEFT JOIN

**Запрос 1.** Все студенты, даже без оценок.

```sql
SELECT s.first_name, s.last_name, g.grade_value
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id;
```
Результат - <img width="521" height="218" alt="image" src="https://github.com/user-attachments/assets/e9960993-6537-4f8b-9dcb-e5e22fa75e03" />


**Запрос 2.** Все группы, даже без студентов.

```sql
SELECT gr.group_name, s.first_name, s.last_name
FROM Groups gr
LEFT JOIN Students s ON gr.group_id = s.group_id;
```
Результат - <img width="533" height="188" alt="image" src="https://github.com/user-attachments/assets/4f61346d-e183-4ad9-bd9e-fa95e88ff0f1" />


---

### RIGHT JOIN

**Запрос 1.** Все оценки и их студенты.

```sql
SELECT g.grade_value, s.first_name, s.last_name
FROM Grades g
RIGHT JOIN Students s ON g.student_id = s.student_id;
```
Результат - <img width="449" height="240" alt="image" src="https://github.com/user-attachments/assets/c56e359c-f44b-408f-8f2a-51db08c84f54" />


**Запрос 2.** Все преподаватели и их курсы.

```sql
SELECT t.first_name, t.last_name, c.course_name
FROM Courses c
RIGHT JOIN Teachers t ON c.teacher_id = t.teacher_id;
```
Результат - <img width="524" height="159" alt="image" src="https://github.com/user-attachments/assets/28ac3d5c-3710-4f25-b93f-3aff174613aa" />

---

### CROSS JOIN

**Запрос 1.** Все комбинации студентов и курсов.

```sql
SELECT s.first_name, s.last_name, c.course_name
FROM Students s
CROSS JOIN Courses c;
```
Результат - <img width="511" height="294" alt="image" src="https://github.com/user-attachments/assets/6bb9e3da-d942-4753-9390-9469add1a1dd" />


**Запрос 2.** Все комбинации групп и преподавателей.

```sql
SELECT gr.group_name, t.first_name, t.last_name
FROM Groups gr
CROSS JOIN Teachers t;
```
Результат - <img width="518" height="297" alt="image" src="https://github.com/user-attachments/assets/15e5be89-f843-4bf5-ac3e-16e012f148ac" />


---

### FULL OUTER JOIN

**Запрос 1.** Все студенты и все оценки.

```sql
SELECT s.first_name, s.last_name, g.grade_value
FROM Students s
FULL OUTER JOIN Grades g ON s.student_id = g.student_id;
```
Результат - <img width="448" height="243" alt="image" src="https://github.com/user-attachments/assets/b09338d9-2237-4474-afb2-3ae8b0446047" />


**Запрос 2.** Все курсы и все оценки.

```sql
SELECT c.course_name, g.grade_value
FROM Courses c
FULL OUTER JOIN Grades g ON c.course_id = g.course_id;
```
Результат - <img width="312" height="270" alt="image" src="https://github.com/user-attachments/assets/7cd83c7a-7e5d-44d6-8f5b-5e4c55084721" />

