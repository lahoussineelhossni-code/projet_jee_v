<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ page
import="com.example.model.Student" %> <% Student currentUser = (Student)
session.getAttribute("user"); %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Plateforme d'échange étudiant</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      .hero-section {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 100px 0;
      }
      .card-hover {
        transition: transform 0.3s ease;
      }
      .card-hover:hover {
        transform: translateY(-5px);
      }
      .navbar-brand {
        font-weight: bold;
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
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
        >
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
            <% if (currentUser != null) { %>
            <li class="nav-item dropdown">
              <a
                class="nav-link dropdown-toggle"
                href="#"
                id="navbarDropdown"
                role="button"
                data-bs-toggle="dropdown"
              >
                <i class="fas fa-user me-1"></i><%= currentUser.getName() %>
              </a>
              <ul class="dropdown-menu">
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/products/add"
                    >Ajouter un produit</a
                  >
                </li>
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/donations/add"
                    >Ajouter un don</a
                  >
                </li>
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/lostfound/add"
                    >Signaler un objet</a
                  >
                </li>
                <li><hr class="dropdown-divider" /></li>
                <li>
                  <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">Déconnexion</a>
                </li>
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

    <!-- Hero Section -->
    <section class="hero-section text-center">
      <div class="container">
        <h1 class="display-4 mb-4">Plateforme d'échange étudiant</h1>
        <p class="lead mb-4">
          Vendez, donnez ou retrouvez des objets entre étudiants de votre
          établissement
        </p>
        <% if (currentUser == null) { %>
        <a href="register.jsp" class="btn btn-light btn-lg me-3">
          <i class="fas fa-user-plus me-2"></i>Rejoindre la communauté
        </a>
        <a href="login.jsp" class="btn btn-outline-light btn-lg">
          <i class="fas fa-sign-in-alt me-2"></i>Se connecter
        </a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/products/add" class="btn btn-light btn-lg me-3">
          <i class="fas fa-plus me-2"></i>Ajouter une annonce
        </a>
        <% } %>
      </div>
    </section>

    <!-- Services Section -->
    <section class="py-5">
      <div class="container">
        <h2 class="text-center mb-5">Nos services</h2>
        <div class="row">
          <div class="col-md-4 mb-4">
            <div class="card h-100 card-hover">
              <div class="card-body text-center">
                <i class="fas fa-shopping-cart fa-3x text-primary mb-3"></i>
                <h5 class="card-title">Ventes</h5>
                <p class="card-text">
                  Vendez vos objets inutilisés à d'autres étudiants à des prix
                  abordables.
                </p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary"
                  >Voir les ventes</a
                >
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="card h-100 card-hover">
              <div class="card-body text-center">
                <i class="fas fa-gift fa-3x text-success mb-3"></i>
                <h5 class="card-title">Dons</h5>
                <p class="card-text">
                  Donnez vos objets à ceux qui en ont besoin et créez de la
                  solidarité.
                </p>
                <a href="${pageContext.request.contextPath}/donations" class="btn btn-success"
                  >Voir les dons</a
                >
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="card h-100 card-hover">
              <div class="card-body text-center">
                <i class="fas fa-search fa-3x text-warning mb-3"></i>
                <h5 class="card-title">Objets trouvés</h5>
                <p class="card-text">
                  Retrouvez vos objets perdus ou aidez d'autres à retrouver les
                  leurs.
                </p>
                <a href="${pageContext.request.contextPath}/lostfound" class="btn btn-warning"
                  >Voir les objets</a
                >
              </div>
            </div>
          </div>
        </div>
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
