package com.example.dao;

import com.example.model.ProductImage;
import org.hibernate.Session;

import java.util.List;

public class ProductImageDao {
    
    public void save(ProductImage image, Session session) {
        session.persist(image);
    }
    
    public List<ProductImage> findByProduct(Long productId, Session session) {
        String hql = "SELECT img FROM ProductImage img WHERE img.product.id = :productId";
        return session.createQuery(hql, ProductImage.class)
                .setParameter("productId", productId)
                .getResultList();
    }
    
    public void delete(ProductImage image, Session session) {
        session.remove(image);
    }
    
    public ProductImage findById(Long id, Session session) {
        return session.get(ProductImage.class, id);
    }
}
