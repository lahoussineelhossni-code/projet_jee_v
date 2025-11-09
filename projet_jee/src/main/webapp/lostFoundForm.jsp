<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.Student" %>
<%
    Student currentUser = (Student) session.getAttribute("user");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signaler un objet - Plateforme d'échange étudiant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .form-header {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .form-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
        }
        .form-control:focus {
            border-color: #ffc107;
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }
        .lostfound-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-graduation-cap me-2"></i>Échange Étudiant
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">
                            <i class="fas fa-shopping-cart me-1"></i>Ventes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/donations">
                            <i class="fas fa-gift me-1"></i>Dons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/lostfound">
                            <i class="fas fa-search me-1"></i>Objets trouvés
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i><%= currentUser.getName() %>
                        </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/add">Ajouter un produit</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/donations/add">Ajouter un don</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/lostfound/add">Signaler un objet</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Déconnexion</a></li>
                            </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-card">
                    <div class="form-header">
                        <i class="fas fa-search fa-3x mb-3"></i>
                        <h3>Signaler un objet trouvé</h3>
                        <p class="mb-0">Aidez à retrouver le propriétaire d'un objet perdu</p>
                    </div>
                    <div class="form-body">
                        <% if (error != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i><%= error %>
                            </div>
                        <% } %>
                        
                        <% if (success != null) { %>
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i><%= success %>
                            </div>
                        <% } %>
                        
                        <div class="lostfound-info">
                            <h5 class="text-warning mb-3">
                                <i class="fas fa-info-circle me-2"></i>À propos des objets trouvés
                            </h5>
                            <p class="mb-0">
                                Si vous avez trouvé un objet perdu sur le campus, signalez-le ici pour aider son propriétaire 
                                à le retrouver. Plus vous donnez de détails, plus il sera facile de retrouver le bon propriétaire.
                            </p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/lostfound/add" method="post">
                            <div class="mb-4">
                                <label for="title" class="form-label">
                                    <i class="fas fa-tag me-2"></i>Titre de l'annonce
                                </label>
                                <input type="text" class="form-control" id="title" name="title" required 
                                       placeholder="Ex: Clés trouvées, Téléphone perdu, Sac à dos...">
                            </div>
                            
                            <div class="mb-4">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-2"></i>Description détaillée
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="5" required 
                                          placeholder="Décrivez l'objet trouvé : couleur, marque, état, caractéristiques particulières..."></textarea>
                                <small class="form-text text-muted">
                                    Plus votre description est précise, plus il sera facile pour le propriétaire de reconnaître son objet.
                                </small>
                            </div>
                            
                            <div class="mb-4">
                                <label for="location" class="form-label">
                                    <i class="fas fa-map-marker-alt me-2"></i>Lieu de découverte
                                </label>
                                <input type="text" class="form-control" id="location" name="location" required 
                                       placeholder="Ex: Bibliothèque, Cafétéria, Salle de cours A12, Parking...">
                                <small class="form-text text-muted">
                                    Indiquez l'endroit exact où vous avez trouvé l'objet.
                                </small>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-warning btn-submit">
                                            <i class="fas fa-bullhorn me-2"></i>Publier l'annonce
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <a href="${pageContext.request.contextPath}/lostfound" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Annuler
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                        
                        <div class="mt-4 p-3 bg-light rounded">
                            <h6 class="text-warning mb-2">
                                <i class="fas fa-lightbulb me-2"></i>Conseils pour signaler un objet
                            </h6>
                            <ul class="mb-0 small">
                                <li>Soyez précis dans la description de l'objet</li>
                                <li>Indiquez le lieu exact de découverte</li>
                                <li>Si l'objet contient des informations personnelles, ne les divulguez pas publiquement</li>
                                <li>Contactez directement le propriétaire une fois qu'il se manifeste</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
