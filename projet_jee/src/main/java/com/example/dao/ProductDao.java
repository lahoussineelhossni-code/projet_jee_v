package com.example.dao;

import com.example.model.Product;
import org.hibernate.Session;
import java.util.List;

public class ProductDao {

    public void save(Product product, Session session) {
        session.persist(product);
    }

    public List<Product> findAll(Session session) {
        // Utilisation de LEFT JOIN FETCH pour charger owner et images en même temps
        // et éviter les problèmes de lazy loading
        String hql = "SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.owner LEFT JOIN FETCH p.images";
        return session.createQuery(hql, Product.class).getResultList();
    }

    public Product findById(Long id, Session session) {
        String hql = "SELECT p FROM Product p LEFT JOIN FETCH p.owner LEFT JOIN FETCH p.images WHERE p.id = :id";
        return session.createQuery(hql, Product.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    public void update(Product product, Session session) {
        session.merge(product);
    }

    public void delete(Product product, Session session) {
        session.remove(product);
    }
    
    public List<Product> findByOwner(com.example.model.Student owner, Session session) {
        String hql = "SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.owner LEFT JOIN FETCH p.images WHERE p.owner = :owner";
        return session.createQuery(hql, Product.class)
                .setParameter("owner", owner)
                .getResultList();
    }
}