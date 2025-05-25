-- Выбор из одной таблицы
INSERT INTO attestation_questions (attestation_id, question_id)
SELECT 1, id FROM questions WHERE profession_id = 1;

-- Использование констант
INSERT INTO departments (title)
SELECT 'Новый отдел';

-- Декартово произведение
INSERT INTO commissioners (commissioner_id, attestation_id)
SELECT e.id, a.id
FROM employees e, attestations a
WHERE e.id = 1 AND a.id = 1;

-- Выбор из двух и более таблиц, соединённых inner join
INSERT INTO attestation_feedback (chief_id, attestation_id, feedback)
SELECT e.id, a.id, 'Хороший сотрудник'
FROM employees e
INNER JOIN attestations a ON a.certificant_id = e.id
WHERE a.result = 'Аттестовать';

-- Фильтр where
INSERT INTO professions (department_id, title)
SELECT id, 'Тестировщик' FROM departments WHERE title = 'Отдел ИТ';