package com.example.web.servlets;

import com.example.model.Student;
import com.example.service.StudentService;
import com.example.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.hibernate.Session;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    
    private StudentService studentService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        studentService = new StudentService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        switch (pathInfo) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/register":
                handleRegister(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        switch (pathInfo) {
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            Student student = studentService.findByEmail(email);
            
            if (student != null && student.getPassword().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", student);
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Une erreur est survenue lors de la connexion");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String filiere = request.getParameter("filiere");
        String phone = request.getParameter("phone");
        
        if (name == null || email == null || password == null || filiere == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || filiere.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Vérifier si l'email existe déjà
            Student existingStudent = studentService.findByEmail(email);
            if (existingStudent != null) {
                request.setAttribute("error", "Cet email est déjà utilisé");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Créer un nouvel étudiant
            Student newStudent = new Student();
            newStudent.setName(name);
            newStudent.setEmail(email);
            newStudent.setPassword(password);
            newStudent.setFiliere(filiere);
            newStudent.setPhone(phone);
            newStudent.setRole("student");
            
            studentService.save(newStudent);
            
            request.setAttribute("success", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            
        } catch (Exception e) {
            request.setAttribute("error", "Une erreur est survenue lors de l'inscription");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/");
    }
}
