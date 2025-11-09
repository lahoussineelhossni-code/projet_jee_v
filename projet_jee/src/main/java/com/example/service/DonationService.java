package com.example.service;

import com.example.dao.DonationDao;
import com.example.model.Donation;
import com.example.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class DonationService {
    
    private DonationDao donationDao;
    
    public DonationService() {
        this.donationDao = new DonationDao();
    }
    
    public void save(Donation donation) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            donationDao.save(donation, session);
            session.getTransaction().commit();
        } catch (Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }
    
    public List<Donation> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return donationDao.findAll(session);
        } finally {
            session.close();
        }
    }
    
    public List<Donation> findByOwner(com.example.model.Student owner) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return donationDao.findByOwner(owner, session);
        } finally {
            session.close();
        }
    }
    
    public Donation findById(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return donationDao.findById(id, session);
        } finally {
            session.close();
        }
    }
    
    public void update(Donation donation) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            session.beginTransaction();
            donationDao.update(donation, session);
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
            Donation donation = donationDao.findById(id, session);
            if (donation != null) {
                donationDao.delete(donation, session);
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
