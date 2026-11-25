# Домашнее задание 9. Процедуры, функции и блоки PL/pgSQL

## 1. Процедуры (3 шт.) + запрос просмотра всех процедур

### 1.1. Процедура добавления нового студента
```sql
CREATE OR REPLACE PROCEDURE add_student(
    p_id INT, 
    p_first_name VARCHAR, 
    p_last_name VARCHAR, 
    p_group_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Students (student_id, first_name, last_name, group_id)
    VALUES (p_id, p_first_name, p_last_name, p_group_id);
    RAISE NOTICE 'Студент % % успешно добавлен', p_first_name, p_last_name;
END;
$$;

-- Вызов процедуры:
CALL add_student(200, 'Иван', 'Процедуров', 1);
```

### 1.2. Процедура обновления оценки
```sql
CREATE OR REPLACE PROCEDURE update_grade(
    p_grade_id INT, 
    p_new_value INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Grades SET grade_value = p_new_value WHERE grade_id = p_grade_id;
    RAISE NOTICE 'Оценка с ID % обновлена на %', p_grade_id, p_new_value;
END;
$$;

-- Вызов процедуры:
CALL update_grade(1, 5);
```

### 1.3. Процедура перевода студента в другую группу
```sql
CREATE OR REPLACE PROCEDURE change_group(
    p_student_id INT, 
    p_new_group_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Students SET group_id = p_new_group_id WHERE student_id = p_student_id;
    RAISE NOTICE 'Студент % переведен в группу %', p_student_id, p_new_group_id;
END;
$$;

-- Вызов процедуры:
CALL change_group(1, 2);
```

### 1.4. Запрос просмотра всех процедур
**Что хотим получить:** Список всех созданных процедур в базе.
```sql
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_type = 'PROCEDURE';
```

---

## 2. Функции + Функции с переменными + запрос просмотра всех функций

### 2.1. Функция подсчета студентов в группе
```sql
CREATE OR REPLACE FUNCTION count_students_in_group(p_group_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Students WHERE group_id = p_group_id;
    RETURN v_count;
END;
$$;

-- Вызов:
SELECT count_students_in_group(1);
```

### 2.2. Функция получения среднего балла студента
```sql
CREATE OR REPLACE FUNCTION get_student_avg_grade(p_student_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_avg NUMERIC;
BEGIN
    SELECT AVG(grade_value) INTO v_avg FROM Grades WHERE student_id = p_student_id;
    RETURN v_avg;
END;
$$;

-- Вызов:
SELECT get_student_avg_grade(1);
```

### 2.3. Функция проверки, отличник ли студент
```sql
CREATE OR REPLACE FUNCTION is_excellent_student(p_student_id INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_avg NUMERIC;
BEGIN
    SELECT AVG(grade_value) INTO v_avg FROM Grades WHERE student_id = p_student_id;
    IF v_avg >= 4.5 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

-- Вызов:
SELECT is_excellent_student(1);
```

### Функции с переменными 

**1.** Функция, возвращающая имя и фамилию студента одной строкой.
```sql
CREATE OR REPLACE FUNCTION get_full_name(p_student_id INT)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_full_name VARCHAR;
BEGIN
    SELECT first_name || ' ' || last_name INTO v_full_name 
    FROM Students WHERE student_id = p_student_id;
    RETURN v_full_name;
END;
$$;

SELECT get_full_name(1);
```

**2.** Функция, возвращающая количество курсов у преподавателя.
```sql
CREATE OR REPLACE FUNCTION count_teacher_courses(p_teacher_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Courses WHERE teacher_id = p_teacher_id;
    RETURN v_count;
END;
$$;

SELECT count_teacher_courses(1);
```

**3.** Функция, возвращающая максимальный кредит среди курсов.
```sql
CREATE OR REPLACE FUNCTION get_max_credits()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_max NUMERIC;
BEGIN
    SELECT MAX(credits) INTO v_max FROM Courses;
    RETURN v_max;
END;
$$;

SELECT get_max_credits();
```

### Запрос просмотра всех функций
```sql
SELECT routine_name, routine_type, data_type 
FROM information_schema.routines 
WHERE routine_type = 'FUNCTION';
```

---

## 3. Блок DO 
*Анонимный блок кода, который выполняется один раз (не сохраняется в базе как процедура).*

```sql
DO $$
DECLARE
    v_total_students INT;
BEGIN
    SELECT COUNT(*) INTO v_total_students FROM Students;
    RAISE NOTICE 'В базе данных всего % студентов', v_total_students;
END;
$$;
```

---

## 4. Конструкция IF 

```sql
DO $$
DECLARE
    v_grade INT := 4;
BEGIN
    IF v_grade = 5 THEN
        RAISE NOTICE 'Отлично';
    ELSIF v_grade = 4 THEN
        RAISE NOTICE 'Хорошо';
    ELSE
        RAISE NOTICE 'Удовлетворительно или плохо';
    END IF;
END;
$$;
```

---

## 5. Конструкция CASE 

```sql
DO $$
DECLARE
    v_day INT := 3;
BEGIN
    CASE v_day
        WHEN 1 THEN RAISE NOTICE 'Понедельник';
        WHEN 2 THEN RAISE NOTICE 'Вторник';
        WHEN 3 THEN RAISE NOTICE 'Среда';
        ELSE RAISE NOTICE 'Другой день';
    END CASE;
END;
$$;
```

---

## 6. Цикл WHILE 

```sql
DO $$
DECLARE
    v_counter INT := 1;
BEGIN
    WHILE v_counter <= 5 LOOP
        RAISE NOTICE 'Итерация номер %', v_counter;
        v_counter := v_counter + 1;
    END LOOP;
END;
$$;
```

---

## 7. Обработка исключений (EXCEPTION) 

```sql
DO $$
DECLARE
    v_result INT;
BEGIN
    v_result := 10 / 0; -- Вызовет ошибку деления на ноль
    RAISE NOTICE 'Результат: %', v_result;
EXCEPTION
    WHEN division_by_zero THEN
        RAISE NOTICE 'Ошибка: Попытка деления на ноль!';
END;
$$;
```

---

## 8. RAISE 
*Команда `RAISE` используется для вывода сообщений или вызова исключений.*

```sql
DO $$
BEGIN
    RAISE NOTICE 'Это информационное сообщение';
    -- RAISE EXCEPTION 'Это вызовет ошибку и остановит блок';
END;
$$;
```
