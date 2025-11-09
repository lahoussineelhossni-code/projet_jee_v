package com.example.service;

import com.example.dao.ProductDao;
import com.example.dao.ProductImageDao;
import com.example.model.Product;
import com.example.model.ProductImage;
import com.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductService {

    private static final Logger LOGGER = Logger.getLogger(ProductService.class.getName());
    private ProductDao productDao;
    private ProductImageDao productImageDao;

    public ProductService() {
        this.productDao = new ProductDao();
        this.productImageDao = new ProductImageDao();
    }

    public void save(Product product) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            productDao.save(product, session);

            transaction.commit();
            LOGGER.log(Level.INFO, "Produit sauvegardé avec succès: {0}", product.getName());
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la sauvegarde du produit", e);
            throw new RuntimeException("Erreur lors de la sauvegarde du produit", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    public List<Product> findAll() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            List<Product> products = productDao.findAll(session);

            LOGGER.log(Level.INFO, "Nombre de produits trouvés: {0}", products.size());

            return products;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des produits", e);
            throw new RuntimeException("Erreur lors de la récupération des produits", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    public Product findById(Long id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return productDao.findById(id, session);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération du produit", e);
            throw new RuntimeException("Erreur lors de la récupération du produit", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    public void update(Product product) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            productDao.update(product, session);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour du produit", e);
            throw new RuntimeException("Erreur lors de la mise à jour du produit", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    public void delete(Long id) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            Product product = productDao.findById(id, session);
            if (product != null) {
                productDao.delete(product, session);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression du produit", e);
            throw new RuntimeException("Erreur lors de la suppression du produit", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
    
    public List<Product> findByOwner(com.example.model.Student owner) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return productDao.findByOwner(owner, session);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des produits par propriétaire", e);
            throw new RuntimeException("Erreur lors de la récupération des produits par propriétaire", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
    
    public void saveProductImage(ProductImage productImage) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            productImageDao.save(productImage, session);
            
            transaction.commit();
            LOGGER.log(Level.INFO, "Image sauvegardée avec succès: {0}", productImage.getFilename());
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la sauvegarde de l'image", e);
            throw new RuntimeException("Erreur lors de la sauvegarde de l'image", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
    
    public void deleteProductImage(Long imageId, String uploadPath) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            ProductImage image = productImageDao.findById(imageId, session);
            if (image != null) {
                // Supprimer le fichier physique
                if (image.getFilepath() != null) {
                    String imagePath = uploadPath + java.io.File.separator + image.getFilepath();
                    java.io.File imageFile = new java.io.File(imagePath);
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }
                // Supprimer l'entité
                productImageDao.delete(image, session);
            }
            
            transaction.commit();
            LOGGER.log(Level.INFO, "Image supprimée avec succès: ID={0}", imageId);
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression de l'image", e);
            throw new RuntimeException("Erreur lors de la suppression de l'image", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}