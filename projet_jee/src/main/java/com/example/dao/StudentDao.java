package com.example.dao;

import com.example.model.Student;
import org.hibernate.Session;
import org.hibernate.query.Query;

public class StudentDao {

    public void save(Student student, Session session) {
        session.persist(student);
    }

    public Student findByEmail(String email, Session session) {
        Query<Student> query = session.createQuery("FROM Student WHERE email = :email", Student.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }
}
