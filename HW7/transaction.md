## 1. Базовые операции с транзакциями (BEGIN, COMMIT, ROLLBACK)

### 1.1. Успешная транзакция (BEGIN ... COMMIT)
**Цель:** Добавить нового студента и обновить название его группы.
```sql
BEGIN;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (99, 'Тест', 'Тестов', 1);
UPDATE Groups SET group_name = 'ПИ-21-1 (Обновленная)' WHERE group_id = 1;
COMMIT;
```
Скриншот 1: <img width="851" height="521" alt="Снимок экрана — 2026-11-18 в 17 48 04" src="https://github.com/user-attachments/assets/ba3090ba-0185-49de-bf25-71c8f09b8b9c" />
Скриншот 2: <img width="665" height="456" alt="Снимок экрана — 2026-11-18 в 17 49 50" src="https://github.com/user-attachments/assets/5a5e604b-f185-4a18-892f-4539394f3432" />

### Сценарий 1.2. Транзакция с ошибкой (BEGIN ... ROLLBACK)
**Цель:** Попробовать добавить студента, но отменить изменения.
```sql
BEGIN;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (100, 'Отмена', 'Отменов', 1);
UPDATE Groups SET group_name = 'ПИ-21-1 (Ошибка)' WHERE group_id = 1;
ROLLBACK;
```
Скриншот 1: <img width="839" height="518" alt="image" src="https://github.com/user-attachments/assets/07706548-1511-4784-aa2f-20854e7d4048" />
Скриншот 2: <img width="827" height="515" alt="image" src="https://github.com/user-attachments/assets/8052ea3b-6967-4180-96b7-5ec8fb0d8305" />


### Сценарий 1.3. Ошибка в транзакции
**Цель:** Посмотреть, как PostgreSQL автоматически откатывает транзакцию при ошибке (деление на ноль).
```sql
BEGIN;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (101, 'Ошибка', 'Ошибкин', 1);
SELECT 1/0;
COMMIT; 
```
Скриншот 1: <img width="846" height="517" alt="image" src="https://github.com/user-attachments/assets/827b8660-93fe-4df1-86f3-ea8beb57cdf1" />
Скриншот 2: <img width="812" height="538" alt="image" src="https://github.com/user-attachments/assets/4949fd21-2d04-470e-b9b3-9a6783a7dd1a" />



---

## 2. Уровни изоляции

### 2.1. READ UNCOMMITTED / READ COMMITTED
**Цель:** Проверить «грязное чтение» (dirty read). В PostgreSQL `READ UNCOMMITTED` работает как `READ COMMITTED`, поэтому грязное чтение невозможно.

**Сценарий 2.1.1 (Грязное чтение не работает):**
```sql
-- T1: 
BEGIN;
UPDATE Students SET first_name = 'Грязный' WHERE student_id = 1;

-- T2: 
SELECT first_name FROM Students WHERE student_id = 1; -- Увидим старое имя, не "Грязный"
```
Скриншот 1: <img width="240" height="173" alt="image" src="https://github.com/user-attachments/assets/4e083325-6e09-4ad8-b9e0-5c3a31336e8e" />
Скриншот 2: <img width="836" height="558" alt="image" src="https://github.com/user-attachments/assets/2b9800d3-32fd-4d60-9f0a-55e20f6db62a" />
**Вывод:** В Т2 отображается старое значение «Алексей», что подтверждает невозможность грязного чтения.



### 2.2. READ COMMITTED (Неповторяющееся чтение)
**Цель:** Увидеть, как данные меняются между двумя SELECT в одной транзакции.
```sql
-- T1
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT first_name FROM Students WHERE student_id = 2; 

-- T2
BEGIN;
UPDATE Students SET first_name = 'Мария (Обновлено)' WHERE student_id = 2;
COMMIT;

-- T1 
SELECT first_name FROM Students WHERE student_id = 2;
COMMIT;
```
Скриншот 1: <img width="1396" height="1074" alt="image" src="https://github.com/user-attachments/assets/78da8164-885b-4584-8318-79d591636187" />
Скриншот 2: <img width="240" height="160" alt="image" src="https://github.com/user-attachments/assets/15c02fb6-f812-46af-8536-5b0d865fd16d" />
Скриншот 3: <img width="240" height="224" alt="image" src="https://github.com/user-attachments/assets/a43f2f8b-8bc8-422a-a46f-8afea82e3749" />
**Вывод:** В рамках транзакции T1 один и тот же запрос выдал разные результаты до и после коммита в T2. Это и есть неповторяющееся чтение.


### 2.3. REPEATABLE READ
**Цель:** Проверить, что T1 не видит изменения от T2, пока не завершится.
```sql
-- T1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT first_name FROM Students WHERE student_id = 3; 

-- T2
UPDATE Students SET first_name = 'Дмитрий (Новый)' WHERE student_id = 3;
COMMIT;

-- T1 
SELECT first_name FROM Students WHERE student_id = 3;
COMMIT;
```
Скриншот 1: <img width="240" height="208" alt="image" src="https://github.com/user-attachments/assets/9129f46c-4705-4f4d-9f5e-94a48e56737c" />
Скриншот 2: <img width="1480" height="1056" alt="image" src="https://github.com/user-attachments/assets/6ec60cc2-b533-4f71-9ef6-7d4b4566ec8d" />
Скриншот 3: <img width="1472" height="1102" alt="image" src="https://github.com/user-attachments/assets/a320e2ff-fa52-456e-9dca-d82bbe890427" />
**Вывод:** В режиме `REPEATABLE READ` транзакция T1 видит только те данные, которые были зафиксированы на момент её начала. Изменения из T2 стали видны только после завершения T1 (COMMIT).


**Фантомное чтение через INSERT:**
```sql
-- T1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM Students WHERE group_id = 1; 

-- T2
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (102, 'Фантом', 'Фантомов', 1);
COMMIT;

-- T1 (снова)
SELECT COUNT(*) FROM Students WHERE group_id = 1; 
COMMIT;
```
Скриншот 1: <img width="240" height="186" alt="image" src="https://github.com/user-attachments/assets/5ae729f2-bcb3-453a-b94e-66113e1922b2" />
Скриншот 2: <img width="1124" height="841" alt="image" src="https://github.com/user-attachments/assets/b6c93d0c-ab9a-4071-9e1e-f0a24d4aea6b" />
**Вывод:** В режиме REPEATABLE READ количество строк в T1 не изменилось после вставки и коммита новой строки в T2. Фантомное чтение предотвращено.


### 2.4. SERIALIZABLE
**Цель:** Смоделировать конфликт двух транзакций и поймать ошибку сериализации.
```sql
-- T1
BEGIN ISOLATION LEVEL SERIALIZABLE;
UPDATE Students SET first_name = 'Сериал' WHERE student_id = 1;

-- T2
BEGIN ISOLATION LEVEL SERIALIZABLE;
UPDATE Students SET first_name = 'Сериал2' WHERE student_id = 1;

-- T1
COMMIT;

-- T2
COMMIT; -- ОШИБКА: could not serialize access due to concurrent update
```
Скриншот 1: <img width="240" height="165" alt="image" src="https://github.com/user-attachments/assets/57be8238-5180-46ed-82fd-83dedcdede8e" />
Скриншот 2: <img width="1332" height="980" alt="image" src="https://github.com/user-attachments/assets/bccdaed3-3ecd-495c-a3b8-2518405d5e47" />



---

## 3. Точки сохранения (SAVEPOINT)

### Сценарий 3.1. Одна точка сохранения
```sql
BEGIN;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (103, 'Точка', 'Сохранения', 1);
SAVEPOINT my_savepoint;
UPDATE Students SET first_name = 'Измененный' WHERE student_id = 103;
-- Передумали делать UPDATE
ROLLBACK TO my_savepoint;
COMMIT;
```
Скриншот 1: <img width="1496" height="1036" alt="image" src="https://github.com/user-attachments/assets/71f70a90-d95f-406e-81fd-e3adc5d7d9ae" />
Скриншот 2: <img width="1752" height="1176" alt="image" src="https://github.com/user-attachments/assets/5217ac52-5dc8-4ffa-ad6f-6cfa46cccb22" />



### Сценарий 3.2. Две точки сохранения
```sql
BEGIN;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (104, 'Тест', 'Тестов', 1);
SAVEPOINT save1;
INSERT INTO Students (student_id, first_name, last_name, group_id) VALUES (105, 'Тест2', 'Тестов2', 1);
SAVEPOINT save2;
UPDATE Students SET first_name = 'Изменен' WHERE student_id = 104;
ROLLBACK TO save1;
COMMIT;
```
Скриншот 1: <img width="1428" height="1038" alt="image" src="https://github.com/user-attachments/assets/8dea290d-4a45-45cd-92a5-0bca47fa84ba" />
Скриншот 2: <img width="1644" height="1190" alt="image" src="https://github.com/user-attachments/assets/e9ca7a46-dc15-4fd5-8af4-5c55cc950284" />


---

## Выводы

**Что я увидела в ходе экспериментов:**
1. В PostgreSQL уровни `READ UNCOMMITTED` и `READ COMMITTED` работают одинаково — грязное чтение невозможно.
2. На уровне `READ COMMITTED` возможно неповторяющееся чтение (один и тот же запрос в одной транзакции может дать разные результаты).
3. На уровне `REPEATABLE READ` данные изолированы, фантомные строки не появляются, пока транзакция не завершится.
4. На уровне `SERIALIZABLE` при одновременном обновлении одной строки одна из транзакций откатывается с ошибкой сериализации.
5. `SAVEPOINT` позволяет откатить часть изменений, не отменяя всю транзакцию.
