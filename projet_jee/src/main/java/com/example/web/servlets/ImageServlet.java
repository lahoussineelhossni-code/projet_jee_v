package com.example.web.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Retirer le premier slash et normaliser le chemin
        String imagePath = pathInfo.substring(1).replace('/', File.separatorChar);
        
        // Construire le chemin complet du fichier
        // Le chemin peut être soit juste le nom du fichier, soit le chemin complet depuis uploads/products/
        String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
        String filePath;
        
        if (imagePath.startsWith("uploads" + File.separator + "products" + File.separator)) {
            // Chemin complet fourni
            filePath = getServletContext().getRealPath("") + File.separator + imagePath;
        } else {
            // Juste le nom du fichier
            filePath = uploadDir + File.separator + imagePath;
        }
        
        File imageFile = new File(filePath);
        
        if (!imageFile.exists() || !imageFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Déterminer le type MIME
        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLengthLong(imageFile.length());
        
        // Copier le fichier dans la réponse
        try (FileInputStream fileInputStream = new FileInputStream(imageFile);
             OutputStream outputStream = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
    }
}

