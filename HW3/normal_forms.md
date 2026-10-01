# Домашнее задание 3. Нормализация

## 1. Проверка на 3НФ и НФБК

Все 5 таблиц (Groups, Students, Teachers, Courses, Grades) находятся в 3НФ и НФБК.

**Groups** (group_id, group_name, faculty)
- 1НФ: все значения атомарные.
- 2НФ: ключ простой (group_id), частичных зависимостей нет.
- 3НФ: нет транзитивных зависимостей.
- НФБК: единственный детерминант — group_id (потенциальный ключ).

**Students** (student_id, first_name, last_name, group_id, email, enrollment_date)
- 1НФ: да.
- 2НФ: да.
- 3НФ: все неключевые атрибуты зависят только от student_id.
- НФБК: да.

**Teachers** (teacher_id, first_name, last_name, department, phone)
- 1НФ, 2НФ, 3НФ, НФБК: да.

**Courses** (course_id, course_name, credits, teacher_id, total_hours)
- 1НФ, 2НФ, 3НФ, НФБК: да.

**Grades** (grade_id, student_id, course_id, grade_value, date)
- 1НФ, 2НФ, 3НФ, НФБК: да.

**Вывод:** таблицы уже нормализованы. Ошибок нет.

---

## 2. Примеры нарушений (искусственные)

### Пример 1. Нарушение 2НФ

**Плохая таблица:**
Grades_Bad (student_id, course_id, student_name, course_name, grade_value)
- Первичный ключ: (student_id, course_id)
- student_name зависит только от student_id (частичная зависимость).
- course_name зависит только от course_id (частичная зависимость).

**Аномалия:**
- При добавлении нового студента нужно указывать курс, даже если он ещё не выбрал.
- При удалении курса теряется информация о студенте.

**Решение:**
- Вынести student_name в таблицу Students.
- Вынести course_name в таблицу Courses.
- Оставить в Grades только grade_value.

---

### Пример 2. Нарушение 3НФ

**Плохая таблица:**
Students_Bad (student_id, first_name, last_name, group_id, group_name, faculty)
- Первичный ключ: student_id
- group_name зависит от group_id (транзитивная зависимость).
- faculty зависит от group_id (транзитивная зависимость).

**Аномалия:**
- При смене названия группы нужно обновлять все строки студентов.
- При удалении студента теряется информация о группе.

**Решение:**
- Вынести group_name и faculty в таблицу Groups.
- Оставить в Students только group_id (внешний ключ).

---

## 3. Итоговая структура (в 3НФ и НФБК)

- Groups (group_id, group_name, faculty)
- Students (student_id, first_name, last_name, group_id, email, enrollment_date)
- Teachers (teacher_id, first_name, last_name, department, phone)
- Courses (course_id, course_name, credits, teacher_id, total_hours)
- Grades (grade_id, student_id, course_id, grade_value, date)
