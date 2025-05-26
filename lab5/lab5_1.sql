-- Список аттестаций с ФИО сотрудника и результатом
CREATE VIEW attestation_summary AS
SELECT
    a.id AS attestation_id,
    e.second_name || ' ' || e.first_name || ' ' || e.middle_name AS full_name,
    p.title AS profession,
    a.attestation_start,
    a.attestation_end,
    a.grade,
    a.result
FROM attestations a
JOIN employees e ON a.certificant_id = e.id
JOIN professions p ON a.profession_id = p.id;

-- Список сотрудников с их отделом и профессией
CREATE VIEW employee_details AS
SELECT
    e.id AS employee_id,
    e.second_name || ' ' || e.first_name || ' ' || e.middle_name AS full_name,
    d.title AS department,
    p.title AS profession
FROM employees e
JOIN departments d ON e.department_id = d.id
JOIN professions p ON e.profession_id = p.id;

-- Список членов комиссий с ролями и аттестациями
CREATE VIEW commissioners_view AS
SELECT
    c.id AS commissioner_record_id,
    e.second_name || ' ' || e.first_name || ' ' || e.middle_name AS commissioner_name,
    c.commissioner_role,
    a.id AS attestation_id,
    a.attestation_start
FROM commissioners c
JOIN employees e ON c.commissioner_id = e.id
JOIN attestations a ON c.attestation_id = a.id;

-- Отзывы руководителей по аттестациям
CREATE VIEW attestation_feedback_view AS
SELECT
    af.id AS feedback_id,
    e.second_name || ' ' || e.first_name || ' ' || e.middle_name AS chief_name,
    af.attestation_id,
    af.feedback,
    af.is_substitute
FROM attestation_feedback af
JOIN employees e ON af.chief_id = e.id;

-- Вопросы, заданные на конкретной аттестации
CREATE VIEW attestation_questions_view AS
SELECT
    aq.attestation_id,
    q.id AS question_id,
    q.question,
    q.answer
FROM attestation_questions aq
JOIN questions q ON aq.question_id = q.id;


SELECT * FROM attestation_summary;
SELECT * FROM employee_details;
SELECT * FROM commissioners_view;
SELECT * FROM attestation_feedback_view;
SELECT * FROM attestation_questions_view;