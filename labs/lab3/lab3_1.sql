-- Вывести таблицу сотрудников
SELECT * FROM employees;

-- Получить 5 первых сотрудников по ID.
SELECT id, first_name, second_name FROM employees
ORDER BY id
LIMIT 5;

-- Получить уникальные значения ID отделов, в которых есть сотрудники.
SELECT DISTINCT department_id FROM employees;

-- Подсчитать общее количество аттестаций.
SELECT COUNT(*) FROM attestations;

-- Подсчитать общее и уникальное количество профессий среди сотрудников.
SELECT 
    COUNT(profession_id) AS total_professions,
    COUNT(DISTINCT profession_id) AS unique_professions
FROM employees;

-- Найти минимальную, максимальную и среднюю оценку по аттестациям.
SELECT 
    MIN(grade) AS min_grade,
    MAX(grade) AS max_grade,
    AVG(grade) AS avg_grade
FROM attestations;

-- Сформировать полное имя сотрудника в верхнем регистре и посчитать длину всех его ФИО.
SELECT 
    id,
    UPPER(first_name) || ' ' || UPPER(second_name) AS full_name_upper,
    LENGTH(first_name) + LENGTH(second_name) + LENGTH(middle_name) AS total_length
FROM employees;

-- Показать сотрудников, прошедших аттестацию, с указанием профессии.
SELECT 
    e.first_name || ' ' || e.second_name AS employee_name,
    p.title AS profession,
    a.result
FROM employees e
JOIN attestations a ON e.id = a.certificant_id
JOIN professions p ON p.id = a.profession_id
WHERE a.result IN ('Аттестовать', 'Аттестовать условно');

-- Найти сотрудников, которые ещё не проходили аттестацию.
SELECT 
    e.first_name || ' ' || e.second_name AS employee_name
FROM employees e
LEFT JOIN attestations a ON e.id = a.certificant_id
WHERE a.id IS NULL;

-- Список аттестаций с ФИО сотрудника, датами и длительностью в днях
SELECT 
    a.id,
    e.first_name || ' ' || e.second_name AS employee_name,
    a.attestation_start,
    a.attestation_end,
    a.attestation_end - a.attestation_start AS duration
FROM attestations a
JOIN employees e ON e.id = a.certificant_id
ORDER BY a.attestation_start DESC;
