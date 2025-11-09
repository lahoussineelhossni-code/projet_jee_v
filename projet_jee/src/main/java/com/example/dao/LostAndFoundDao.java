package com.example.dao;

import com.example.model.LostAndFound;
import com.example.model.Student;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

public class LostAndFoundDao {
    
    public void save(LostAndFound lostAndFound, Session session) {
        session.persist(lostAndFound);
    }
    
    public List<LostAndFound> findAll(Session session) {
        // Utilisation de LEFT JOIN FETCH pour charger owner en même temps
        // et éviter les problèmes de lazy loading
        String hql = "SELECT DISTINCT l FROM LostAndFound l LEFT JOIN FETCH l.owner";
        return session.createQuery(hql, LostAndFound.class).getResultList();
    }
    
    public List<LostAndFound> findByOwner(Student owner, Session session) {
        String hql = "SELECT DISTINCT l FROM LostAndFound l LEFT JOIN FETCH l.owner WHERE l.owner = :owner";
        return session.createQuery(hql, LostAndFound.class)
                .setParameter("owner", owner)
                .getResultList();
    }
    
    public LostAndFound findById(Long id, Session session) {
        String hql = "SELECT l FROM LostAndFound l LEFT JOIN FETCH l.owner WHERE l.id = :id";
        return session.createQuery(hql, LostAndFound.class)
                .setParameter("id", id)
                .uniqueResult();
    }
    
    public void update(LostAndFound lostAndFound, Session session) {
        session.merge(lostAndFound);
    }
    
    public void delete(LostAndFound lostAndFound, Session session) {
        session.remove(lostAndFound);
    }
}
