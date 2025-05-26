-- Количество аттестаций по каждой профессии
SELECT p.title AS profession, COUNT(*) AS attestation_count
FROM attestations a
JOIN professions p ON a.profession_id = p.id
GROUP BY p.title;

-- Средняя оценка по профессиям, где результат — "Аттестовать"
SELECT p.title AS profession, AVG(a.grade) AS avg_grade
FROM attestations a
JOIN professions p ON a.profession_id = p.id
WHERE a.result = 'Аттестовать'
GROUP BY p.title;

-- Количество сотрудников в каждом отделе, отсортированное по убыванию
SELECT d.title AS department, COUNT(e.id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.title
ORDER BY employee_count DESC;

-- Сотрудники, проходившие аттестации с максимальной оценкой выше 5
SELECT certificant_id, MAX(grade) AS max_grade
FROM attestations
GROUP BY certificant_id
HAVING MAX(grade) >= 5;

-- Аттестации с максимальной оценкой среди всех
SELECT a.id, e.first_name, e.second_name, a.grade
FROM attestations a
JOIN employees e ON a.certificant_id = e.id
WHERE a.grade = (
    SELECT MAX(grade)
    FROM attestations
);

-- Сотрудники, которые не участвовали ни в одной аттестации
SELECT e.id, e.first_name, e.second_name
FROM employees e
WHERE e.id NOT IN (
    SELECT certificant_id FROM attestations
);

-- Список сотрудников, участвовавших как аттестуемые или как члены комиссии
SELECT e.id, e.first_name, e.second_name
FROM employees e
WHERE e.id IN (
    SELECT certificant_id FROM attestations
)
UNION
SELECT e.id, e.first_name, e.second_name
FROM employees e
WHERE e.id IN (
    SELECT commissioner_id FROM commissioners
);

-- Аттестации с оценкой выше, чем все оценки по профессии с id = 3
SELECT id, grade
FROM attestations
WHERE grade > ALL (
    SELECT grade
    FROM attestations
    WHERE profession_id = 3 AND grade IS NOT NULL
);

-- Сотрудники, у которых есть отзывы
SELECT e.id, e.first_name, e.second_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM attestation_feedback f
    WHERE f.chief_id = e.id
);

-- Профессии, по которым есть и вопросы, и аттестации
SELECT profession_id
FROM questions
INTERSECT
SELECT profession_id
FROM attestations;

-- Сотрудники, участвовавшие в аттестации, но не оставившие отзыв
SELECT e.id, e.first_name, e.second_name
FROM employees e
WHERE e.id IN (
    SELECT certificant_id FROM attestations
)
EXCEPT
SELECT e.id, e.first_name, e.second_name
FROM employees e
JOIN attestation_feedback f ON e.id = f.chief_id;