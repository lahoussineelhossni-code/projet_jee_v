<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Donation" %>
<%@ page import="com.example.model.Student" %>
<%
    List<Donation> donations = (List<Donation>) request.getAttribute("donations");
    Student currentUser = (Student) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dons - Plateforme d'échange étudiant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .donation-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .donation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .donation-icon {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .owner-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 10px;
            margin-top: 10px;
        }
        .search-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 3rem;
        }
        .donation-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.9em;
        }
        .nav-tabs .nav-link.active {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
        }
        .nav-tabs .nav-link {
            color: #28a745;
        }
        .nav-tabs .nav-link:hover {
            border-color: #28a745;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/donations">
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
                    <% if (currentUser != null) { %>
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
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">
                                <i class="fas fa-sign-in-alt me-1"></i>Connexion
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="register.jsp">
                                <i class="fas fa-user-plus me-1"></i>Inscription
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Search Section -->
    <section class="search-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h1 class="display-5 mb-4">
                        <i class="fas fa-gift me-3"></i>Dons généreux
                    </h1>
                    <p class="lead mb-4">Découvrez les objets donnés par vos camarades étudiants</p>
                    
                    <div class="row">
                        <div class="col-md-8 mx-auto">
                            <div class="input-group">
                                <input type="text" class="form-control form-control-lg" placeholder="Rechercher un don...">
                                <button class="btn btn-light btn-lg" type="button">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Donations Section -->
    <section class="py-5">
        <div class="container">
            <div class="row mb-4">
                <div class="col-md-6">
                    <h3>Dons disponibles</h3>
                </div>
                <div class="col-md-6 text-end">
                    <% if (currentUser != null) { %>
                        <a href="${pageContext.request.contextPath}/donations/add" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Faire un don
                        </a>
                    <% } else { %>
                        <a href="login.jsp" class="btn btn-outline-success">
                            <i class="fas fa-sign-in-alt me-2"></i>Connectez-vous pour donner
                        </a>
                    <% } %>
                </div>
            </div>
            
            <% if (currentUser != null) { %>
            <div class="row mb-4">
                <div class="col-12">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link <%= (request.getAttribute("filter") == null || "all".equals(request.getAttribute("filter"))) ? "active" : "" %>" 
                               href="${pageContext.request.contextPath}/donations">
                                <i class="fas fa-list me-1"></i>Tous les dons
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link <%= "mine".equals(request.getAttribute("filter")) ? "active" : "" %>" 
                               href="${pageContext.request.contextPath}/donations?filter=mine">
                                <i class="fas fa-user me-1"></i>Mes dons
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link <%= "others".equals(request.getAttribute("filter")) ? "active" : "" %>" 
                               href="${pageContext.request.contextPath}/donations?filter=others">
                                <i class="fas fa-users me-1"></i>Dons des autres
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <% } %>

            <% if (donations != null && !donations.isEmpty()) { %>
                <div class="row">
                    <% for (Donation donation : donations) { 
                       boolean isMine = currentUser != null && donation.getOwner().getId().equals(currentUser.getId());
                    %>
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card donation-card h-100 <%= isMine ? "border-success" : "" %>">
                                <% if (isMine) { %>
                                <div class="card-header bg-success text-white">
                                    <i class="fas fa-user-check me-2"></i>Mon don
                                </div>
                                <% } %>
                                <div class="donation-icon">
                                    <i class="fas fa-gift fa-3x mb-3"></i>
                                    <h5 class="card-title text-white"><%= donation.getTitle() %></h5>
                                </div>
                                <div class="card-body">
                                    <p class="card-text"><%= donation.getDescription() %></p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="donation-badge">
                                            <i class="fas fa-gift me-1"></i>GRATUIT
                                        </span>
                                        <small class="text-muted">
                                            <i class="fas fa-user me-1"></i><%= donation.getOwner().getName() %>
                                        </small>
                                    </div>
                                    <div class="owner-info">
                                        <small class="text-muted">
                                            <i class="fas fa-graduation-cap me-1"></i><%= donation.getOwner().getFiliere() %>
                                            <% if (donation.getOwner().getPhone() != null && !donation.getOwner().getPhone().isEmpty()) { %>
                                                <br><i class="fas fa-phone me-1"></i><%= donation.getOwner().getPhone() %>
                                            <% } %>
                                        </small>
                                    </div>
                                </div>
                                <div class="card-footer bg-transparent">
                                    <div class="d-grid">
                                        <button class="btn btn-outline-success">
                                            <i class="fas fa-hand-holding-heart me-2"></i>Je suis intéressé
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="text-center py-5">
                    <i class="fas fa-gift fa-4x text-muted mb-4"></i>
                    <h4 class="text-muted">Aucun don disponible</h4>
                    <p class="text-muted">Soyez le premier à faire un don généreux !</p>
                    <% if (currentUser != null) { %>
                        <a href="${pageContext.request.contextPath}/donations/add" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Faire un don
                        </a>
                    <% } else { %>
                        <a href="login.jsp" class="btn btn-outline-success">
                            <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container text-center">
            <p>&copy; 2024 Plateforme d'échange étudiant. Tous droits réservés.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
