package com.example.service;

import com.example.dao.StudentDao;
import com.example.model.Student;
import com.example.util.HibernateUtil;
import org.hibernate.Session;

public class StudentService {
    
    private StudentDao studentDao;
    
    public StudentService() {
        this.studentDao = new StudentDao();
    }


    public void save(Student student) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            studentDao.save(student, session);
            session.getTransaction().commit();
        } catch (Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }
    
    public Student findByEmail(String email) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return studentDao.findByEmail(email, session);
        } finally {
            session.close();
        }
    }
}
