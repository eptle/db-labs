from app import app, queries
from flask import render_template, url_for, request, redirect, flash
import psycopg2

# Главные страницы

@app.route('/')
@app.route('/index', methods=['POST', 'GET'])
def employees():
    employees = queries.get_all_employees()
    print(employees)
    return render_template('employees.html', title='Список сотрудников', employees=employees)

@app.route('/attestations', methods=['GET', 'POST'])
def attestations():
    attestations = queries.get_attestation_list()
    print(attestations)
    return render_template('attestations.html', title='Аттестации', attestations=attestations)

@app.route('/questions', methods=['GET', 'POST'])
def questions():
    questions = queries.get_questions_list()
    print(questions)
    return render_template('questions.html', title='Вопросы', questions=questions)

@app.route('/departments', methods=['GET', 'POST'])
def departments():
    departments = queries.get_department_list()
    print(questions)
    return render_template('departments.html', title='Отделы', departments=departments)

# Создание

@app.route('/create-attestation', methods=['GET', 'POST'])
def create_attestation():
    return render_template('create_attestations.html', title='Аттестовать сотрудника')

@app.route('/create-question', methods=['GET', 'POST'])
def create_question():
    if request.method == 'POST':
        question = request.form['question']
        answer = request.form['answer']
        profession_ids = request.form.getlist('professions')  # список строк

        if not profession_ids:
            flash("Выберите хотя бы одну профессию!", "danger")
            return redirect(url_for('create_question'))

        # Преобразуем строки в int
        profession_ids = [int(pid) for pid in profession_ids]

        queries.create_questions(question, answer, profession_ids)

        flash("Вопрос(ы) успешно добавлены!", "success")
        return redirect(url_for('questions'))

    professions = queries.get_profession_list()
    return render_template('create_question.html', title='Создать вопрос', professions=professions)

@app.route('/create-user', methods=['GET', 'POST'])
def create_user():
    return render_template('create_user.html', title='Добавить сотрудника')

@app.route('/create-department', methods=['GET', 'POST'])
def create_department():
    return render_template('create_department.html', title='Добавить отдел')

# Просмотр сущности

@app.route('/view-attestation/<attestation_id>', methods=['GET', 'POST'])
def view_attestation(attestation_id: int):
    return render_template('view_attestation.html', title='Просмотр аттестации')

# Удаление

@app.route('/delete-employee', methods=['GET', 'POST'])
def delete_employee():
    redirect("employees")

@app.route('/delete-department', methods=['GET', 'POST'])
def delete_department():
    department_id = request.form.get('department_id')
    if not department_id:
        flash("ID отдела не передан!", "danger")
        return redirect(url_for('departments'))

    try:
        department_id = int(department_id)
    except ValueError:
        flash("Неверный ID отдела!", "danger")
        return redirect(url_for('departments'))

    try:
        queries.delete_department_by_id(department_id)
        flash("Отдел успешно удалён!", "success")
    except psycopg2.errors.ForeignKeyViolation:
        flash("В отделе есть люди, удалите их из отдела", "danger")
    return redirect(url_for('departments'))

@app.route('/delete-question', methods=['GET', 'POST'])
def delete_question():
    question_id = request.form.get('question_id')
    if not question_id:
        flash("ID вопроса не передан!", "danger")
        return redirect(url_for('questions'))

    try:
        question_id = int(question_id)
    except ValueError:
        flash("Неверный ID вопроса!", "danger")
        return redirect(url_for('questions'))

    queries.delete_question_by_id(question_id)
    flash("Вопрос успешно удалён!", "success")
    return redirect(url_for('questions'))