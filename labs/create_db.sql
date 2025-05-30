-- Типы ENUM
CREATE TYPE attestation_result AS ENUM ('Аттестовать', 'Не аттестовать', 'Аттестовать условно', 'Другое');
CREATE TYPE commissioner_role AS ENUM ('Член комиссии', 'Председатель', 'Секретарь');

-- Таблица Отдел
CREATE TABLE departments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    manager_id INT,
    title VARCHAR(255) NOT NULL
);

-- Таблица Профессия
CREATE TABLE professions (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INT,
    title VARCHAR(255) NOT NULL
);

-- Таблица Сотрудник
CREATE TABLE employees (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    profession_id INT NOT NULL,
    department_id INT,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) NOT NULL
);

-- Таблица Вопросов
CREATE TABLE questions (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    profession_id INT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL
);

-- Таблица Аттестации
CREATE TABLE attestations (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    certificant_id INT NOT NULL,
    profession_id INT NOT NULL,
    attestation_start TIMESTAMP NOT NULL,
    attestation_end TIMESTAMP NOT NULL,
    grade INT,
    result attestation_result
);

-- Таблица Члены комиссии
CREATE TABLE commissioners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    commissioner_id INT NOT NULL,
    attestation_id INT NOT NULL,
    commissioner_role commissioner_role DEFAULT 'Член комиссии'
);

-- Таблица Отзыв на аттестацию
CREATE TABLE attestation_feedback (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    chief_id INT NOT NULL,
    attestation_id INT NOT NULL,
    feedback TEXT NOT NULL,
    is_substitute BOOLEAN DEFAULT FALSE
);

-- Таблица Аттестационные вопросы
CREATE TABLE attestation_questions (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    attestation_id INT NOT NULL,
    question_id INT NOT NULL
);

-- Внешние ключи
ALTER TABLE departments
    ADD FOREIGN KEY (manager_id) REFERENCES employees(id);

ALTER TABLE professions
    ADD FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE;

ALTER TABLE employees
    ADD FOREIGN KEY (profession_id) REFERENCES professions(id),
    ADD FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE;

ALTER TABLE questions
    ADD FOREIGN KEY (profession_id) REFERENCES professions(id);

ALTER TABLE attestations
    ADD FOREIGN KEY (certificant_id) REFERENCES employees(id),
    ADD FOREIGN KEY (profession_id) REFERENCES professions(id);

ALTER TABLE commissioners
    ADD FOREIGN KEY (commissioner_id) REFERENCES employees(id),
    ADD FOREIGN KEY (attestation_id) REFERENCES attestations(id);

ALTER TABLE attestation_feedback
    ADD FOREIGN KEY (chief_id) REFERENCES employees(id),
    ADD FOREIGN KEY (attestation_id) REFERENCES attestations(id);

ALTER TABLE attestation_questions
    ADD FOREIGN KEY (attestation_id) REFERENCES attestations(id),
    ADD FOREIGN KEY (question_id) REFERENCES questions(id);
