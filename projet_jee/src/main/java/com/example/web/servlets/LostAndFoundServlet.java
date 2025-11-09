package com.example.web.servlets;

import com.example.model.LostAndFound;
import com.example.model.Student;
import com.example.service.LostAndFoundService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/lostfound/*")
public class LostAndFoundServlet extends HttpServlet {
    
    private LostAndFoundService lostAndFoundService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        lostAndFoundService = new LostAndFoundService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        String filter = request.getParameter("filter"); // "mine" ou "others"
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Afficher la liste des objets trouvés
            try {
                List<LostAndFound> allLostAndFounds = lostAndFoundService.findAll();
                List<LostAndFound> myLostAndFounds = currentUser != null ? lostAndFoundService.findByOwner(currentUser) : new ArrayList<>();
                
                List<LostAndFound> lostAndFounds;
                if ("mine".equals(filter) && currentUser != null) {
                    lostAndFounds = myLostAndFounds;
                    request.setAttribute("filter", "mine");
                } else if ("others".equals(filter) && currentUser != null) {
                    lostAndFounds = allLostAndFounds.stream()
                            .filter(l -> !l.getOwner().getId().equals(currentUser.getId()))
                            .collect(Collectors.toList());
                    request.setAttribute("filter", "others");
                } else {
                    lostAndFounds = allLostAndFounds;
                    request.setAttribute("filter", "all");
                }
                
                request.setAttribute("myLostAndFounds", myLostAndFounds);
                request.setAttribute("lostAndFounds", lostAndFounds);
                request.getRequestDispatcher("/lostFound.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors du chargement des objets trouvés: " + e.getMessage());
                request.getRequestDispatcher("/lostFound.jsp").forward(request, response);
            }
            return;
        }
        
        switch (pathInfo) {
            case "/add":
                // Afficher le formulaire d'ajout
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }
                request.getRequestDispatcher("/lostFoundForm.jsp").forward(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        switch (pathInfo) {
            case "/add":
                handleAddLostAndFound(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleAddLostAndFound(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        
        if (title == null || description == null || location == null ||
            title.trim().isEmpty() || description.trim().isEmpty() || location.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires");
            request.getRequestDispatcher("/lostFoundForm.jsp").forward(request, response);
            return;
        }
        
        try {
            LostAndFound lostAndFound = new LostAndFound();
            lostAndFound.setTitle(title);
            lostAndFound.setDescription(description);
            lostAndFound.setLocation(location);
            lostAndFound.setOwner(currentUser);
            
            lostAndFoundService.save(lostAndFound);
            
            // Rediriger vers la liste des objets trouvés après ajout
            response.sendRedirect(request.getContextPath() + "/lostfound?filter=mine");
            
        } catch (Exception e) {
            request.setAttribute("error", "Une erreur est survenue lors de l'ajout de l'objet");
            request.getRequestDispatcher("/lostFoundForm.jsp").forward(request, response);
        }
    }
}
