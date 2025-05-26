-- Выбор из одной таблицы
UPDATE employees 
SET first_name = 'Пётр'
WHERE id IN (SELECT id FROM employees WHERE first_name = 'Иван');

-- Выбор из двух и более таблиц, соединённых inner join
UPDATE employees 
SET department_id = 2
WHERE id IN (
  SELECT e.id
  FROM employees e
  INNER JOIN professions p ON e.profession_id = p.id
  WHERE p.title = 'Тестировщик'
);

-- Фильтр where
UPDATE attestations
SET grade = 4
WHERE id IN (
  SELECT id FROM attestations WHERE result = 'Аттестовать условно'
);

-- Изменить роль члена комиссии
UPDATE commissioners
SET commissioner_role = 'Секретарь'
WHERE id IN (
  SELECT c.id
  FROM commissioners c
  INNER JOIN employees e ON c.commissioner_id = e.id
  WHERE e.second_name = 'Иванов'
);

-- Изменить отзывы
UPDATE attestation_feedback
SET feedback = 'Отличный результат'
WHERE attestation_id IN (
  SELECT id FROM attestations WHERE grade >= 5
);