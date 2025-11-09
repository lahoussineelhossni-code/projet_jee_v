package com.example.util;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
public class HibernateTest {
    public static void main(String[] args) {
        try {
            SessionFactory sessionFactory = new
                    Configuration().configure("hibernate.cfg.xml").buildSessionFactory();
            System.out.println("Hibernate setup successful!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}