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
    <title>Ajouter un produit - Plateforme d'échange étudiant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .image-preview {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            min-height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .image-preview img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
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
                        <i class="fas fa-plus-circle fa-3x mb-3"></i>
                        <h3>Ajouter un produit</h3>
                        <p class="mb-0">Mettez en vente vos objets inutilisés</p>
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
                        
                        <form action="${pageContext.request.contextPath}/products/add" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label for="name" class="form-label">
                                        <i class="fas fa-tag me-2"></i>Nom du produit
                                    </label>
                                    <input type="text" class="form-control" id="name" name="name" required 
                                           placeholder="Ex: MacBook Pro 13 pouces">
                                </div>
                                
                                <div class="col-md-4 mb-3">
                                    <label for="price" class="form-label">
                                        <i class="fas fa-money-bill-wave me-2"></i>Prix (DH)
                                    </label>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           step="0.01" min="0" required placeholder="0.00">
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-2"></i>Description
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4" required placeholder="Décrivez votre produit en détail..."></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <label for="images" class="form-label">
                                    <i class="fas fa-images me-2"></i>Images du produit
                                </label>
                                <input type="file" class="form-control" id="images" name="images" 
                                       multiple accept="image/*" onchange="previewImages(this)">
                                <small class="form-text text-muted">
                                    Vous pouvez sélectionner jusqu'à 4 images (JPG, PNG, GIF)
                                </small>
                                
                                <div id="imagePreview" class="image-preview mt-3" style="display: none;">
                                    <div class="text-muted">
                                        <i class="fas fa-image fa-2x mb-2"></i>
                                        <p>Aperçu des images</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary btn-submit">
                                            <i class="fas fa-plus me-2"></i>Publier le produit
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-grid">
                                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Annuler
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewImages(input) {
            const preview = document.getElementById('imagePreview');
            preview.innerHTML = '';
            preview.style.display = 'block';
            
            if (input.files && input.files.length > 0) {
                for (let i = 0; i < Math.min(input.files.length, 4); i++) {
                    const file = input.files[i];
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'me-2 mb-2';
                        img.style.width = '100px';
                        img.style.height = '100px';
                        img.style.objectFit = 'cover';
                        preview.appendChild(img);
                    };
                    
                    reader.readAsDataURL(file);
                }
            } else {
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html>
