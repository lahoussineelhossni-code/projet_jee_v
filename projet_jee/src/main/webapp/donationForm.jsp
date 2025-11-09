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
    <title>Faire un don - Plateforme d'échange étudiant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        .donation-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
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
                        <i class="fas fa-heart fa-3x mb-3"></i>
                        <h3>Faire un don généreux</h3>
                        <p class="mb-0">Partagez vos objets avec la communauté étudiante</p>
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
                        
                        <div class="donation-info">
                            <h5 class="text-success mb-3">
                                <i class="fas fa-info-circle me-2"></i>À propos des dons
                            </h5>
                            <p class="mb-0">
                                Les dons sont des objets que vous souhaitez donner gratuitement à d'autres étudiants. 
                                C'est un excellent moyen de créer de la solidarité et d'aider vos camarades qui pourraient 
                                avoir besoin de ces objets.
                            </p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/donations/add" method="post">
                            <div class="mb-4">
                                <label for="title" class="form-label">
                                    <i class="fas fa-tag me-2"></i>Titre du don
                                </label>
                                <input type="text" class="form-control" id="title" name="title" required 
                                       placeholder="Ex: Livres de programmation, Vêtements, Meubles...">
                            </div>
                            
                            <div class="mb-4">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-2"></i>Description détaillée
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="5" required 
                                          placeholder="Décrivez l'objet que vous souhaitez donner : état, marque, modèle, pourquoi vous le donnez..."></textarea>
                                <small class="form-text text-muted">
                                    Plus votre description est détaillée, plus il sera facile pour les autres étudiants de comprendre ce que vous offrez.
                                </small>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-success btn-submit">
                                            <i class="fas fa-heart me-2"></i>Publier le don
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <a href="${pageContext.request.contextPath}/donations" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Annuler
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                        
                        <div class="mt-4 p-3 bg-light rounded">
                            <h6 class="text-success mb-2">
                                <i class="fas fa-lightbulb me-2"></i>Conseils pour un bon don
                            </h6>
                            <ul class="mb-0 small">
                                <li>Vérifiez que l'objet est en bon état avant de le donner</li>
                                <li>Soyez précis dans votre description</li>
                                <li>Indiquez si vous pouvez livrer ou si l'étudiant doit venir chercher</li>
                                <li>Répondez rapidement aux messages des intéressés</li>
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
