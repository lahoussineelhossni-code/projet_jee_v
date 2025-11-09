package com.example.web.servlets;

import com.example.dao.ProductImageDao;
import com.example.model.Product;
import com.example.model.ProductImage;
import com.example.model.Student;
import com.example.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/products/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProductServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProductServlet.class.getName());
    private ProductService productService;
    private ProductImageDao productImageDao;
    private static final String UPLOAD_DIR = "uploads" + File.separator + "products";
    
    @Override
    public void init() throws ServletException {
        super.init();
        productService = new ProductService();
        productImageDao = new ProductImageDao();
        
        // Créer le dossier d'upload s'il n'existe pas
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        LOGGER.info("ProductServlet initialisé avec succès. Upload dir: " + uploadPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        LOGGER.log(Level.INFO, "doGet appelé avec pathInfo: {0}", pathInfo);

        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        String filter = request.getParameter("filter"); // "mine" ou "others"
        String searchQuery = request.getParameter("search"); // Recherche

        if (pathInfo == null || pathInfo.equals("/")) {
            // Afficher la liste des produits
            try {
                List<Product> allProducts = productService.findAll();
                
                // Appliquer la recherche si présente
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    String searchLower = searchQuery.toLowerCase();
                    allProducts = allProducts.stream()
                            .filter(p -> p.getName().toLowerCase().contains(searchLower) ||
                                        (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                            .collect(Collectors.toList());
                }
                
                List<Product> myProducts = currentUser != null ? productService.findByOwner(currentUser) : new ArrayList<>();
                
                List<Product> products;
                if ("mine".equals(filter) && currentUser != null) {
                    products = myProducts;
                    // Appliquer la recherche sur mes produits aussi
                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        String searchLower = searchQuery.toLowerCase();
                        products = products.stream()
                                .filter(p -> p.getName().toLowerCase().contains(searchLower) ||
                                            (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                                .collect(Collectors.toList());
                    }
                    request.setAttribute("filter", "mine");
                } else if ("others".equals(filter) && currentUser != null) {
                    products = allProducts.stream()
                            .filter(p -> !p.getOwner().getId().equals(currentUser.getId()))
                            .collect(Collectors.toList());
                    // Appliquer la recherche sur les produits des autres aussi
                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        String searchLower = searchQuery.toLowerCase();
                        products = products.stream()
                                .filter(p -> p.getName().toLowerCase().contains(searchLower) ||
                                            (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                                .collect(Collectors.toList());
                    }
                    request.setAttribute("filter", "others");
                } else {
                    products = allProducts;
                    request.setAttribute("filter", "all");
                }
                
                request.setAttribute("myProducts", myProducts);
                request.setAttribute("products", products);
                request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
                request.getRequestDispatcher("/products.jsp").forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des produits", e);
                request.setAttribute("error", "Erreur lors du chargement des produits: " + e.getMessage());
                request.getRequestDispatcher("/products.jsp").forward(request, response);
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
                request.getRequestDispatcher("/productForm.jsp").forward(request, response);
                break;
            case "/edit":
                // Redirection - nécessite un ID
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
            case "/delete":
                // Redirection - nécessite un ID
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
            default:
                // Vérifier si c'est un ID de produit (format: /123) ou une action (format: /123/edit, /123/delete, /123/image/456/delete)
                if (pathInfo.startsWith("/") && pathInfo.length() > 1) {
                    String[] pathParts = pathInfo.substring(1).split("/");
                    try {
                        Long productId = Long.parseLong(pathParts[0]);
                        
                        if (pathParts.length > 1) {
                            String action = pathParts[1];
                            switch (action) {
                                case "edit":
                                    handleEditProduct(productId, request, response);
                                    break;
                                case "delete":
                                    handleDeleteProduct(productId, request, response);
                                    break;
                                case "image":
                                    // Format: /productId/image/imageId/delete
                                    if (pathParts.length >= 4 && "delete".equals(pathParts[3])) {
                                        Long imageId = Long.parseLong(pathParts[2]);
                                        handleDeleteImage(productId, imageId, request, response);
                                    } else {
                                        handleProductDetails(productId, request, response);
                                    }
                                    break;
                                default:
                                    handleProductDetails(productId, request, response);
                                    break;
                            }
                        } else {
                            handleProductDetails(productId, request, response);
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "PathInfo non valide: {0}", pathInfo);
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } else {
                    LOGGER.log(Level.WARNING, "PathInfo non trouvé: {0}", pathInfo);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        LOGGER.log(Level.INFO, "doPost appelé avec pathInfo: {0}", pathInfo);

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (pathInfo) {
            case "/add":
                handleAddProduct(request, response);
                break;
            case "/update":
                handleUpdateProduct(request, response);
                break;
            default:
                // Vérifier si c'est une action avec ID (format: /123/update)
                if (pathInfo.startsWith("/") && pathInfo.length() > 1) {
                    String[] pathParts = pathInfo.substring(1).split("/");
                    try {
                        Long productId = Long.parseLong(pathParts[0]);
                        if (pathParts.length > 1 && "update".equals(pathParts[1])) {
                            handleUpdateProduct(request, response);
                        } else {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        }
                    } catch (NumberFormatException e) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                break;
        }
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");

        if (currentUser == null) {
            LOGGER.warning("Tentative d'ajout de produit sans connexion");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");

        LOGGER.log(Level.INFO, "Tentative d'ajout produit: nom={0}, description={1}, prix={2}",
                new Object[]{name, description, priceStr});

        if (name == null || description == null || priceStr == null ||
                name.trim().isEmpty() || description.trim().isEmpty() || priceStr.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires");
            request.getRequestDispatcher("/productForm.jsp").forward(request, response);
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);

            if (price <= 0) {
                request.setAttribute("error", "Le prix doit être supérieur à 0");
                request.getRequestDispatcher("/productForm.jsp").forward(request, response);
                return;
            }

            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setOwner(currentUser);

            // Sauvegarder le produit d'abord pour obtenir son ID
            productService.save(product);

            // Traiter les images uploadées
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            List<Part> fileParts = request.getParts().stream()
                    .filter(part -> "images".equals(part.getName()) && part.getSize() > 0)
                    .collect(Collectors.toList());

            int imageCount = 0;
            for (Part filePart : fileParts) {
                if (imageCount >= 4) break; // Limiter à 4 images
                
                String fileName = filePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    // Générer un nom de fichier unique
                    String fileExtension = fileName.substring(fileName.lastIndexOf('.'));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    String filePath = uploadDir.getAbsolutePath() + File.separator + uniqueFileName;
                    
                    // Sauvegarder le fichier
                    try (java.io.InputStream inputStream = filePart.getInputStream()) {
                        Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    }
                    
                    // Créer l'entité ProductImage et la sauvegarder
                    // Utiliser "/" pour les chemins web (URLs) au lieu de File.separator
                    ProductImage productImage = new ProductImage();
                    productImage.setFilename(fileName);
                    productImage.setFilepath(uniqueFileName); // Stocker juste le nom du fichier
                    productImage.setProduct(product);
                    
                    // Sauvegarder l'image en base de données
                    productService.saveProductImage(productImage);
                    
                    imageCount++;
                    LOGGER.log(Level.INFO, "Image sauvegardée: {0}", filePath);
                }
            }

            LOGGER.log(Level.INFO, "Produit ajouté avec succès: {0} avec {1} images", 
                    new Object[]{product.getName(), imageCount});

            // Rediriger vers la liste des produits après ajout
            response.sendRedirect(request.getContextPath() + "/products?filter=mine");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Prix invalide: {0}", priceStr);
            request.setAttribute("error", "Le prix doit être un nombre valide");
            request.getRequestDispatcher("/productForm.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'ajout du produit", e);
            request.setAttribute("error", "Une erreur est survenue lors de l'ajout du produit: " + e.getMessage());
            request.getRequestDispatcher("/productForm.jsp").forward(request, response);
        }
    }
    
    private void handleProductDetails(Long productId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Product product = productService.findById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produit introuvable");
                return;
            }
            
            HttpSession session = request.getSession();
            Student currentUser = (Student) session.getAttribute("user");
            
            // Vérifier si le produit appartient à l'utilisateur connecté
            boolean isOwner = currentUser != null && product.getOwner().getId().equals(currentUser.getId());
            
            request.setAttribute("product", product);
            request.setAttribute("isOwner", isOwner);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/productDetails.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des détails du produit", e);
            request.setAttribute("error", "Erreur lors du chargement des détails du produit: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
    
    private void handleEditProduct(Long productId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            Product product = productService.findById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produit introuvable");
                return;
            }
            
            // Vérifier que l'utilisateur est le propriétaire
            if (!product.getOwner().getId().equals(currentUser.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Vous n'êtes pas autorisé à modifier ce produit");
                return;
            }
            
            request.setAttribute("product", product);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/productEdit.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération du produit pour édition", e);
            request.setAttribute("error", "Erreur lors du chargement du produit: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
    
    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String productIdStr = request.getParameter("productId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        
        if (productIdStr == null || name == null || description == null || priceStr == null ||
                productIdStr.trim().isEmpty() || name.trim().isEmpty() || 
                description.trim().isEmpty() || priceStr.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires");
            if (productIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/products/" + productIdStr + "/edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
            return;
        }
        
        try {
            Long productId = Long.parseLong(productIdStr);
            Product product = productService.findById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produit introuvable");
                return;
            }
            
            // Vérifier que l'utilisateur est le propriétaire
            if (!product.getOwner().getId().equals(currentUser.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Vous n'êtes pas autorisé à modifier ce produit");
                return;
            }
            
            double price = Double.parseDouble(priceStr);
            if (price <= 0) {
                request.setAttribute("error", "Le prix doit être supérieur à 0");
                response.sendRedirect(request.getContextPath() + "/products/" + productId + "/edit");
                return;
            }
            
            // Mettre à jour le produit
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            
            productService.update(product);
            
            // Traiter les nouvelles images si fournies
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            List<Part> fileParts = request.getParts().stream()
                    .filter(part -> "images".equals(part.getName()) && part.getSize() > 0)
                    .collect(Collectors.toList());
            
            int existingImageCount = product.getImages() != null ? product.getImages().size() : 0;
            int maxNewImages = 4 - existingImageCount;
            
            if (maxNewImages > 0 && !fileParts.isEmpty()) {
                int imageCount = 0;
                for (Part filePart : fileParts) {
                    if (imageCount >= maxNewImages) break;
                    
                    String fileName = filePart.getSubmittedFileName();
                    if (fileName != null && !fileName.isEmpty()) {
                        String fileExtension = fileName.substring(fileName.lastIndexOf('.'));
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                        String filePath = uploadDir.getAbsolutePath() + File.separator + uniqueFileName;
                        
                        try (java.io.InputStream inputStream = filePart.getInputStream()) {
                            Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                        }
                        
                        ProductImage productImage = new ProductImage();
                        productImage.setFilename(fileName);
                        productImage.setFilepath(uniqueFileName);
                        productImage.setProduct(product);
                        
                        productService.saveProductImage(productImage);
                        imageCount++;
                    }
                }
            }
            
            LOGGER.log(Level.INFO, "Produit mis à jour avec succès: {0}", product.getName());
            response.sendRedirect(request.getContextPath() + "/products/" + productId);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "ID ou prix invalide");
            request.setAttribute("error", "Données invalides");
            if (productIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/products/" + productIdStr + "/edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour du produit", e);
            request.setAttribute("error", "Une erreur est survenue lors de la mise à jour: " + e.getMessage());
            if (productIdStr != null) {
                response.sendRedirect(request.getContextPath() + "/products/" + productIdStr + "/edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        }
    }
    
    private void handleDeleteProduct(Long productId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            Product product = productService.findById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produit introuvable");
                return;
            }
            
            // Vérifier que l'utilisateur est le propriétaire
            if (!product.getOwner().getId().equals(currentUser.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Vous n'êtes pas autorisé à supprimer ce produit");
                return;
            }
            
            // Supprimer les images physiques
            if (product.getImages() != null) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                for (ProductImage image : product.getImages()) {
                    if (image.getFilepath() != null) {
                        String imagePath = uploadPath + File.separator + image.getFilepath();
                        File imageFile = new File(imagePath);
                        if (imageFile.exists()) {
                            imageFile.delete();
                        }
                    }
                }
            }
            
            // Supprimer le produit (les images seront supprimées en cascade)
            productService.delete(productId);
            
            LOGGER.log(Level.INFO, "Produit supprimé avec succès: ID={0}", productId);
            response.sendRedirect(request.getContextPath() + "/products?filter=mine");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression du produit", e);
            request.setAttribute("error", "Une erreur est survenue lors de la suppression: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/products/" + productId);
        }
    }
    
    private void handleDeleteImage(Long productId, Long imageId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Student currentUser = (Student) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            Product product = productService.findById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produit introuvable");
                return;
            }
            
            // Vérifier que l'utilisateur est le propriétaire
            if (!product.getOwner().getId().equals(currentUser.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Vous n'êtes pas autorisé à supprimer cette image");
                return;
            }
            
            // Vérifier que l'image appartient au produit
            boolean imageBelongsToProduct = product.getImages() != null && 
                    product.getImages().stream().anyMatch(img -> img.getId().equals(imageId));
            
            if (!imageBelongsToProduct) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image introuvable");
                return;
            }
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            productService.deleteProductImage(imageId, uploadPath);
            
            LOGGER.log(Level.INFO, "Image supprimée avec succès: ID={0}", imageId);
            response.sendRedirect(request.getContextPath() + "/products/" + productId + "/edit");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression de l'image", e);
            request.setAttribute("error", "Une erreur est survenue lors de la suppression de l'image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/products/" + productId + "/edit");
        }
    }
}