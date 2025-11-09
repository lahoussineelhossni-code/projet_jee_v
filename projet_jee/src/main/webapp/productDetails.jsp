<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.example.model.Product" %> 
<%@ page import="com.example.model.Student" %> 
<%@ page import="com.example.model.ProductImage" %> 
<% 
  Product product = (Product) request.getAttribute("product");
  Student currentUser = (Student) session.getAttribute("user");
  Boolean isOwner = (Boolean) request.getAttribute("isOwner");
  if (isOwner == null) isOwner = false;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du produit - <%= product != null ? product.getName() : "Produit" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .product-detail-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .product-detail-image:hover {
            transform: scale(1.02);
        }
        .thumbnail-image {
            width: 100%;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            border: 3px solid transparent;
            transition: all 0.3s ease;
        }
        .thumbnail-image:hover {
            border-color: #667eea;
            transform: scale(1.05);
        }
        .thumbnail-image.active {
            border-color: #667eea;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.5);
        }
        .price-display {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
        }
        .owner-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 20px;
        }
        .product-info-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        .badge-owner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
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

    <!-- Product Details Section -->
    <section class="py-5">
        <div class="container">
            <% if (product != null) { %>
            <div class="row mb-4">
                <div class="col-12">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Retour à la liste
                    </a>
                </div>
            </div>
            
            <div class="row">
                <!-- Images Section -->
                <div class="col-lg-6 mb-4">
                    <div class="product-info-card">
                        <% if (product.getImages() != null && !product.getImages().isEmpty()) { 
                             ProductImage firstImage = product.getImages().get(0);
                             String firstImagePath = firstImage != null ? firstImage.getFilepath() : null;
                             if (firstImagePath != null) {
                               if (firstImagePath.contains("/")) {
                                 firstImagePath = firstImagePath.substring(firstImagePath.lastIndexOf('/') + 1);
                               } else if (firstImagePath.contains("\\")) {
                                 firstImagePath = firstImagePath.substring(firstImagePath.lastIndexOf('\\') + 1);
                               }
                             }
                        %>
                            <!-- Image principale -->
                            <div class="mb-4">
                                <img id="mainImage" 
                                     src="${pageContext.request.contextPath}/images/<%= firstImagePath != null ? firstImagePath : "" %>" 
                                     alt="<%= product.getName() %>" 
                                     class="product-detail-image"
                                     onclick="openImageModal(this.src)"
                                     onerror="this.onerror=null; this.parentElement.innerHTML='<div class=\'text-center py-5\'><i class=\'fas fa-image fa-5x text-muted mb-3\'></i><p class=\'text-muted\'>Image non disponible</p></div>';">
                            </div>
                            
                            <!-- Miniatures -->
                            <% if (product.getImages().size() > 1) { %>
                            <div class="row g-2">
                                <% for (int i = 0; i < product.getImages().size(); i++) { 
                                     ProductImage img = product.getImages().get(i);
                                     String imagePath = img != null ? img.getFilepath() : null;
                                     if (imagePath != null) {
                                       if (imagePath.contains("/")) {
                                         imagePath = imagePath.substring(imagePath.lastIndexOf('/') + 1);
                                       } else if (imagePath.contains("\\")) {
                                         imagePath = imagePath.substring(imagePath.lastIndexOf('\\') + 1);
                                       }
                                     }
                                     if (imagePath != null && !imagePath.isEmpty()) {
                                %>
                                <div class="col-3">
                                    <img src="${pageContext.request.contextPath}/images/<%= imagePath %>" 
                                         alt="Image <%= i + 1 %>" 
                                         class="thumbnail-image <%= i == 0 ? "active" : "" %>"
                                         onclick="changeMainImage(this, '<%= imagePath %>')"
                                         onerror="this.style.display='none';">
                                </div>
                                <%   }
                                     } %>
                            </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-image fa-5x text-muted mb-3"></i>
                                <p class="text-muted">Aucune image disponible</p>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Product Info Section -->
                <div class="col-lg-6">
                    <div class="product-info-card">
                        <% if (isOwner) { %>
                        <div class="mb-3">
                            <span class="badge-owner">
                                <i class="fas fa-user-check me-2"></i>Mon produit
                            </span>
                        </div>
                        <% } %>
                        
                        <h1 class="mb-3"><%= product.getName() %></h1>
                        
                        <div class="price-display mb-4">
                            <%= product.getPrice() %> DH
                        </div>
                        
                        <div class="mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-align-left me-2"></i>Description
                            </h5>
                            <p class="text-muted" style="white-space: pre-wrap;"><%= product.getDescription() %></p>
                        </div>
                        
                        <hr class="my-4">
                        
                        <!-- Owner Information -->
                        <div class="owner-card mb-4">
                            <h5 class="mb-3">
                                <i class="fas fa-user me-2"></i>Informations du vendeur
                            </h5>
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-user-circle fa-2x text-primary me-3"></i>
                                <div>
                                    <strong><%= product.getOwner().getName() %></strong>
                                    <br>
                                    <small class="text-muted">
                                        <i class="fas fa-graduation-cap me-1"></i><%= product.getOwner().getFiliere() %>
                                    </small>
                                </div>
                            </div>
                            <% if (product.getOwner().getPhone() != null && !product.getOwner().getPhone().isEmpty()) { %>
                            <div class="mt-3">
                                <a href="tel:<%= product.getOwner().getPhone() %>" class="btn btn-outline-primary btn-sm me-2">
                                    <i class="fas fa-phone me-1"></i><%= product.getOwner().getPhone() %>
                                </a>
                                <a href="https://wa.me/<%= product.getOwner().getPhone().replaceAll("[^0-9]", "") %>" 
                                   target="_blank" 
                                   class="btn btn-success btn-sm">
                                    <i class="fab fa-whatsapp me-1"></i>WhatsApp
                                </a>
                            </div>
                            <% } %>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="d-grid gap-2">
                            <% if (isOwner) { %>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/products/<%= product.getId() %>/edit" class="btn btn-warning btn-lg w-100">
                                        <i class="fas fa-edit me-2"></i>Modifier
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <button class="btn btn-danger btn-lg w-100" onclick="confirmDelete(<%= product.getId() %>)">
                                        <i class="fas fa-trash me-2"></i>Supprimer
                                    </button>
                                </div>
                            </div>
                            <% } else if (currentUser != null) { %>
                            <button class="btn btn-primary btn-lg" onclick="contactSeller()">
                                <i class="fas fa-envelope me-2"></i>Contacter le vendeur
                            </button>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-lg">
                                <i class="fas fa-sign-in-alt me-2"></i>Connectez-vous pour contacter
                            </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-exclamation-triangle fa-4x text-warning mb-4"></i>
                <h3>Produit introuvable</h3>
                <p class="text-muted">Le produit que vous recherchez n'existe pas ou a été supprimé.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    <i class="fas fa-arrow-left me-2"></i>Retour à la liste
                </a>
            </div>
            <% } %>
        </div>
    </section>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Image du produit</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="Product Image" style="max-width: 100%; max-height: 70vh;">
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container text-center">
            <p>&copy; 2024 Plateforme d'échange étudiant. Tous droits réservés.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changeMainImage(thumbnail, imagePath) {
            // Mettre à jour l'image principale
            const mainImage = document.getElementById('mainImage');
            mainImage.src = '${pageContext.request.contextPath}/images/' + imagePath;
            
            // Mettre à jour les miniatures actives
            document.querySelectorAll('.thumbnail-image').forEach(img => {
                img.classList.remove('active');
            });
            thumbnail.classList.add('active');
        }
        
        function openImageModal(imageSrc) {
            const modalImage = document.getElementById('modalImage');
            modalImage.src = imageSrc;
            const modal = new bootstrap.Modal(document.getElementById('imageModal'));
            modal.show();
        }
        
        function contactSeller() {
            <% if (product != null && product.getOwner().getPhone() != null && !product.getOwner().getPhone().isEmpty()) { %>
            const phone = '<%= product.getOwner().getPhone().replaceAll("[^0-9]", "") %>';
            const whatsappUrl = 'https://wa.me/' + phone + '?text=Bonjour, je suis intéressé par votre produit: <%= product.getName() %>';
            window.open(whatsappUrl, '_blank');
            <% } else { %>
            alert('Les coordonnées du vendeur ne sont pas disponibles.');
            <% } %>
        }
        
        function confirmDelete(productId) {
            if (confirm('Êtes-vous sûr de vouloir supprimer ce produit ? Cette action est irréversible.')) {
                window.location.href = '${pageContext.request.contextPath}/products/' + productId + '/delete';
            }
        }
    </script>
</body>
</html>

