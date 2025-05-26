-- Выбор из одной таблицы
DELETE FROM attestation_questions
WHERE question_id IN (
  SELECT id FROM questions WHERE question ILIKE '%дебет%'
);

DELETE FROM questions
WHERE question ILIKE '%дебет%';

-- Выбор из двух и более таблиц, соединённых inner join
DELETE FROM commissioners
WHERE id IN (
  SELECT c.id
  FROM commissioners c
  INNER JOIN employees e ON c.commissioner_id = e.id
  WHERE e.first_name = 'Пётр'
);

-- Фильтр where
DELETE FROM professions
WHERE id NOT IN (SELECT DISTINCT profession_id FROM employees);

-- удалить неудачные аттестации
DELETE FROM attestations
WHERE id IN (
  SELECT id FROM attestations WHERE result = 'Не аттестовать'
);

-- Удаление отзывов заменяющих руководителей
DELETE FROM attestation_feedback
WHERE id IN (
  SELECT id FROM attestation_feedback WHERE is_substitute = TRUE
);