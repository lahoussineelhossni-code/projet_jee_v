<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="java.util.List" %> 
<%@ page import="com.example.model.Product" %> 
<%@ page import="com.example.model.Student" %> 
<%@ page import="java.net.URLEncoder" %> 
<% 
  List<Product> products = (List<Product>) request.getAttribute("products"); 
  Student currentUser = (Student) session.getAttribute("user");
  String searchQuery = (String) request.getAttribute("searchQuery");
  String filter = (String) request.getAttribute("filter");
  if (searchQuery == null) searchQuery = "";
  if (filter == null) filter = "all";
%>
    <!DOCTYPE html>
    <html lang="fr">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Produits à vendre - Plateforme d'échange étudiant</title>
        <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
        />
        <link
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
          rel="stylesheet"
        />
        <style>
          .product-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
          }
          .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
          }
          .product-image {
            height: 200px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
          }
          .product-image-container img:hover {
            transform: scale(1.05);
            transition: transform 0.3s ease;
          }
          .price-tag {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 1.1em;
          }
          .owner-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 10px;
            margin-top: 10px;
          }
                        .search-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 3rem;
          }
          .nav-tabs .nav-link.active {
            background-color: #667eea;
            color: white;
            border-color: #667eea;
          }
          .nav-tabs .nav-link {
            color: #667eea;
          }
          .nav-tabs .nav-link:hover {
            border-color: #667eea;
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
                  <a class="nav-link active" href="${pageContext.request.contextPath}/products">
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
                      <a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout"
                        >Déconnexion</a
                      >
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

        <!-- Search Section -->
        <section class="search-section">
          <div class="container">
            <div class="row">
              <div class="col-lg-8 mx-auto text-center">
                <h1 class="display-5 mb-4">
                  <i class="fas fa-shopping-cart me-3"></i>Produits à vendre
                </h1>
                <p class="lead mb-4">
                  Découvrez les objets vendus par vos camarades étudiants
                </p>

                <div class="row">
                  <div class="col-md-8 mx-auto">
                    <form method="get" action="${pageContext.request.contextPath}/products" class="input-group">
                      <input
                        type="text"
                        class="form-control form-control-lg"
                        name="search"
                        placeholder="Rechercher un produit..."
                        value="<%= searchQuery %>"
                      />
                      <% if (filter != null && !filter.equals("all")) { %>
                      <input type="hidden" name="filter" value="<%= filter %>" />
                      <% } %>
                      <button class="btn btn-light btn-lg" type="submit">
                        <i class="fas fa-search"></i>
                      </button>
                      <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                      <a href="${pageContext.request.contextPath}/products<%= filter != null && !filter.equals("all") ? "?filter=" + filter : "" %>" 
                         class="btn btn-outline-light btn-lg">
                        <i class="fas fa-times"></i>
                      </a>
                      <% } %>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Products Section -->
        <section class="py-5">
          <div class="container">
            <div class="row mb-4">
              <div class="col-md-6">
                <h3>Produits disponibles</h3>
              </div>
              <div class="col-md-6 text-end">
                <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/products/add" class="btn btn-primary">
                  <i class="fas fa-plus me-2"></i>Ajouter un produit
                </a>
                <% } else { %>
                <a href="login.jsp" class="btn btn-outline-primary">
                  <i class="fas fa-sign-in-alt me-2"></i>Connectez-vous pour
                  vendre
                </a>
                <% } %>
              </div>
            </div>
            
            <% if (currentUser != null) { %>
            <div class="row mb-4">
              <div class="col-12">
                <ul class="nav nav-tabs" role="tablist">
                  <li class="nav-item" role="presentation">
                    <a class="nav-link <%= filter == null || "all".equals(filter) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/products<%= !searchQuery.isEmpty() ? "?search=" + URLEncoder.encode(searchQuery, "UTF-8") : "" %>">
                      <i class="fas fa-list me-1"></i>Tous les produits
                    </a>
                  </li>
                  <li class="nav-item" role="presentation">
                    <a class="nav-link <%= "mine".equals(filter) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/products?filter=mine<%= !searchQuery.isEmpty() ? "&search=" + URLEncoder.encode(searchQuery, "UTF-8") : "" %>">
                      <i class="fas fa-user me-1"></i>Mes produits
                    </a>
                  </li>
                  <li class="nav-item" role="presentation">
                    <a class="nav-link <%= "others".equals(filter) ? "active" : "" %>" 
                       href="${pageContext.request.contextPath}/products?filter=others<%= !searchQuery.isEmpty() ? "&search=" + URLEncoder.encode(searchQuery, "UTF-8") : "" %>">
                      <i class="fas fa-users me-1"></i>Produits des autres
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <% } %>

            <% if (products != null && !products.isEmpty()) { %>
            <div class="row">
              <% for (Product product : products) { 
                 boolean isMine = currentUser != null && product.getOwner().getId().equals(currentUser.getId());
              %>
              <div class="col-lg-4 col-md-6 mb-4">
                <div class="card product-card h-100 <%= isMine ? "border-primary" : "" %>">
                  <% if (isMine) { %>
                  <div class="card-header bg-primary text-white">
                    <i class="fas fa-user-check me-2"></i>Mon produit
                  </div>
                  <% } %>
                  
                  <!-- Images du produit -->
                  <div class="product-image-container" style="height: 200px; overflow: hidden; background: #f8f9fa;">
                    <% if (product.getImages() != null && !product.getImages().isEmpty()) { 
                         String imagePath = product.getImages().get(0).getFilepath();
                         // Nettoyer le chemin pour l'URL
                         if (imagePath != null && imagePath.contains("/")) {
                           imagePath = imagePath.substring(imagePath.lastIndexOf('/') + 1);
                         } else if (imagePath != null && imagePath.contains("\\")) {
                           imagePath = imagePath.substring(imagePath.lastIndexOf('\\') + 1);
                         }
                    %>
                      <img src="${pageContext.request.contextPath}/images/<%= imagePath %>" 
                           class="card-img-top" 
                           alt="<%= product.getName() %>"
                           style="width: 100%; height: 100%; object-fit: cover; cursor: pointer;"
                           onerror="this.onerror=null; this.parentElement.innerHTML='<div class=\'d-flex align-items-center justify-content-center h-100\'><i class=\'fas fa-image fa-3x text-muted\'></i></div>';">
                    <% } else { %>
                      <div class="d-flex align-items-center justify-content-center h-100">
                        <i class="fas fa-image fa-3x text-muted"></i>
                      </div>
                    <% } %>
                  </div>
                  
                  <div class="card-body">
                    <h5 class="card-title"><%= product.getName() %></h5>
                    <p class="card-text text-muted" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                      <%= product.getDescription() %>
                    </p>
                    <div
                      class="d-flex justify-content-between align-items-center"
                    >
                      <span class="price-tag"
                        ><%= product.getPrice() %> DH</span
                      >
                      <small class="text-muted">
                        <i class="fas fa-user me-1"></i><%=
                        product.getOwner().getName() %>
                      </small>
                    </div>
                    <div class="owner-info">
                      <small class="text-muted">
                        <i class="fas fa-graduation-cap me-1"></i><%=
                        product.getOwner().getFiliere() %> <% if
                        (product.getOwner().getPhone() != null &&
                        !product.getOwner().getPhone().isEmpty()) { %> <br /><i
                          class="fas fa-phone me-1"
                        ></i
                        ><%= product.getOwner().getPhone() %> <% } %>
                      </small>
                    </div>
                  </div>
                  <div class="card-footer bg-transparent">
                    <div class="d-grid">
                      <a href="${pageContext.request.contextPath}/products/<%= product.getId() %>" class="btn btn-outline-primary">
                        <i class="fas fa-eye me-2"></i>Voir détails
                      </a>
                    </div>
                  </div>
                </div>
              </div>
              <% } %>
            </div>
            <% } else { %>
            <div class="text-center py-5">
              <i class="fas fa-shopping-cart fa-4x text-muted mb-4"></i>
              <h4 class="text-muted">Aucun produit disponible</h4>
              <p class="text-muted">
                Soyez le premier à mettre en vente un produit !
              </p>
              <% if (currentUser != null) { %>
              <a href="${pageContext.request.contextPath}/products/add" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>Ajouter un produit
              </a>
              <% } else { %>
              <a href="login.jsp" class="btn btn-outline-primary">
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
            <p>
              &copy; 2024 Plateforme d'échange étudiant. Tous droits réservés.
            </p>
          </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
          function showImageGallery(productId) {
            // TODO: Implémenter une galerie d'images modale si nécessaire
            console.log('Afficher la galerie pour le produit:', productId);
          }
        </script>
      </body>
    </html>
