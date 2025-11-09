package com.example.service;

import com.example.dao.LostAndFoundDao;
import com.example.model.LostAndFound;
import com.example.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class LostAndFoundService {
    
    private LostAndFoundDao lostAndFoundDao;
    
    public LostAndFoundService() {
        this.lostAndFoundDao = new LostAndFoundDao();
    }
    
    public void save(LostAndFound lostAndFound) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            lostAndFoundDao.save(lostAndFound, session);
            session.getTransaction().commit();
        } catch (Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }
    
    public List<LostAndFound> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return lostAndFoundDao.findAll(session);
        } finally {
            session.close();
        }
    }
    
    public List<LostAndFound> findByOwner(com.example.model.Student owner) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return lostAndFoundDao.findByOwner(owner, session);
        } finally {
            session.close();
        }
    }
    
    public LostAndFound findById(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return lostAndFoundDao.findById(id, session);
        } finally {
            session.close();
        }
    }
    
    public void update(LostAndFound lostAndFound) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            lostAndFoundDao.update(lostAndFound, session);
            session.getTransaction().commit();
        } catch (Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }
    
    public void delete(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            LostAndFound lostAndFound = lostAndFoundDao.findById(id, session);
            if (lostAndFound != null) {
                lostAndFoundDao.delete(lostAndFound, session);
            }
            session.getTransaction().commit();
        } catch (Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
