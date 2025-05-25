-- Удаление таблиц с зависимостями в правильном порядке
DROP TABLE IF EXISTS attestation_questions CASCADE;
DROP TABLE IF EXISTS attestation_feedback CASCADE;
DROP TABLE IF EXISTS commissioners CASCADE;
DROP TABLE IF EXISTS attestations CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS professions CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- Удаление типов ENUM
DROP TYPE IF EXISTS commissioner_role;
DROP TYPE IF EXISTS attestation_result;
