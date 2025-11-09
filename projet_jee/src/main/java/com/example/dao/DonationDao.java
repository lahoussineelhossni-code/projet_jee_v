package com.example.dao;

import com.example.model.Donation;
import org.hibernate.Session;
import java.util.List;

public class DonationDao {

    public void save(Donation donation, Session session) {
        session.persist(donation);
    }

    public List<Donation> findAll(Session session) {
        // Utilisation de LEFT JOIN FETCH pour charger owner en même temps
        // et éviter les problèmes de lazy loading
        String hql = "SELECT DISTINCT d FROM Donation d LEFT JOIN FETCH d.owner";
        return session.createQuery(hql, Donation.class).getResultList();
    }

    public Donation findById(Long id, Session session) {
        String hql = "SELECT d FROM Donation d LEFT JOIN FETCH d.owner WHERE d.id = :id";
        return session.createQuery(hql, Donation.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    public void update(Donation donation, Session session) {
        session.merge(donation);
    }

    public void delete(Donation donation, Session session) {
        session.remove(donation);
    }
    
    public List<Donation> findByOwner(com.example.model.Student owner, Session session) {
        String hql = "SELECT DISTINCT d FROM Donation d LEFT JOIN FETCH d.owner WHERE d.owner = :owner";
        return session.createQuery(hql, Donation.class)
                .setParameter("owner", owner)
                .getResultList();
    }
}