from app.db import execute_query


def get_all_employees():
    return execute_query("""
        SELECT e.id, e.first_name, e.second_name, e.middle_name, p.title as profession, d.title as department
        FROM employees e
        JOIN departments d ON e.department_id = d.id
        JOIN professions p ON e.profession_id = p.id
        ORDER BY second_name, first_name
    """)


def get_last_attestation(FIO: str):
    pass


def get_profession_list():
    return execute_query("""
    SELECT id, title as profession FROM professions
    """)


def get_department_list():
    return execute_query("""
    SELECT 
        d.id,
        d.title AS department,
        m.second_name || ' ' || m.first_name || ' ' || m.middle_name AS manager_name,
        COUNT(e.id) AS employee_count
    FROM departments d
    LEFT JOIN employees m ON d.manager_id = m.id
    LEFT JOIN employees e ON e.department_id = d.id
    GROUP BY d.id, d.title, m.first_name, m.second_name, m.middle_name
    ORDER BY d.title;
    """)


def get_attestation_list():
    return execute_query("""
    SELECT
        a.id,
        e.second_name || ' ' || e.first_name || ' ' || e.middle_name AS full_name,
        p.title AS profession,
        a.grade AS average_grade,
        a.attestation_end as date,
        json_agg(
            json_build_object(
                'full_name', c_e.second_name || ' ' || c_e.first_name || ' ' || c_e.middle_name,
                'profession', cp.title,
                'role', c.commissioner_role
            )
        ) AS commissioners
    FROM
        attestations a
    JOIN employees e ON a.certificant_id = e.id
    JOIN professions p ON e.profession_id = p.id
    LEFT JOIN commissioners c ON a.id = c.attestation_id
    LEFT JOIN employees c_e ON c.commissioner_id = c_e.id
    LEFT JOIN professions cp ON c_e.profession_id = cp.id
    GROUP BY a.id, e.second_name, e.first_name, e.middle_name, p.title, a.grade
    ORDER BY date DESC;
    """)


def get_questions_list():
    return execute_query("""
    SELECT 
        q.id AS id,
        q.question,
        p.title AS profession,
        q.answer
    FROM questions q
    JOIN professions p ON q.profession_id = p.id
    ORDER BY q.id;
    """)


def create_questions(question_text, answer_text, profession_ids):
    query = """
        INSERT INTO questions (profession_id, question, answer)
        VALUES (%s, %s, %s)
    """
    for prof_id in profession_ids:
        execute_query(query, (prof_id, question_text, answer_text), commit=True, fetchall=False)


def delete_question_by_id(question_id):
    query = "DELETE FROM questions WHERE id = %s"
    execute_query(query, (question_id,), commit=True, fetchall=False)

    
def delete_department_by_id(department_id):
    query = "DELETE FROM departments WHERE id = %s"
    execute_query(query, (department_id,), commit=True, fetchall=False)
