# Guide Rapide - Plateforme d'échange étudiant

## 🚀 Démarrage rapide

### 1. Configuration de la base de données

```sql
CREATE DATABASE student_platform;
```

Modifier `src/main/resources/hibernate.cfg.xml` :
```xml
<property name="hibernate.connection.username">root</property>
<property name="hibernate.connection.password">votre_mot_de_passe</property>
```

### 2. Compilation et déploiement

```bash
mvn clean package
# Copier target/projet_jee.war dans webapps/ de Tomcat
```

### 3. Accès à l'application

```
http://localhost:8080/projet_jee/
```

---

## 📋 Fonctionnalités principales

### ✅ Authentification
- Inscription / Connexion / Déconnexion
- Gestion de session

### ✅ Gestion des produits
- Ajouter / Modifier / Supprimer
- Upload d'images (max 4)
- Recherche et filtrage
- Distinction "mes produits" / "produits des autres"

### ✅ Gestion des dons
- Ajouter / Consulter
- Filtrage par propriétaire

### ✅ Gestion des objets trouvés
- Ajouter / Consulter
- Filtrage par propriétaire

---

## 🔗 Routes principales

| Route | Méthode | Description |
|-------|---------|-------------|
| `/` | GET | Page d'accueil |
| `/auth/login` | POST | Connexion |
| `/auth/register` | POST | Inscription |
| `/auth/logout` | GET | Déconnexion |
| `/products` | GET | Liste des produits |
| `/products/add` | GET/POST | Ajouter un produit |
| `/products/{id}` | GET | Détails d'un produit |
| `/products/{id}/edit` | GET | Éditer un produit |
| `/products/{id}/update` | POST | Mettre à jour un produit |
| `/products/{id}/delete` | GET | Supprimer un produit |
| `/donations` | GET | Liste des dons |
| `/donations/add` | GET/POST | Ajouter un don |
| `/lostfound` | GET | Liste des objets trouvés |
| `/lostfound/add` | GET/POST | Ajouter un objet trouvé |
| `/images/{filename}` | GET | Afficher une image |

---

## 🗂 Structure des packages

```
com.example/
├── dao/          # Accès aux données
├── model/        # Entités JPA
├── service/      # Logique métier
├── util/         # Utilitaires
└── web/servlets/ # Contrôleurs
```

---

## 🎯 Cas d'utilisation principaux

### Utilisateur non authentifié
1. Consulter les produits, dons, objets trouvés
2. Rechercher des produits
3. S'inscrire
4. Se connecter

### Utilisateur authentifié
1. Ajouter un produit avec images
2. Modifier ses produits
3. Supprimer ses produits
4. Ajouter un don
5. Ajouter un objet trouvé
6. Contacter les vendeurs
7. Filtrer ses publications

---

## 🔒 Sécurité

- ✅ Authentification par session
- ✅ Vérification de la propriété avant modification/suppression
- ✅ Protection des routes nécessitant une authentification
- ⚠️ Hashage des mots de passe (à implémenter)

---

## 📝 Notes importantes

- Les images sont stockées dans `uploads/products/`
- La base de données est créée automatiquement par Hibernate
- Le timeout de session est de 30 minutes
- Maximum 4 images par produit
- Taille max d'image : 10MB

---

## 🐛 Dépannage

### Problème de connexion à la base de données
- Vérifier les identifiants dans `hibernate.cfg.xml`
- Vérifier que MySQL est démarré
- Vérifier que la base de données existe

### Images non affichées
- Vérifier que le dossier `uploads/products/` existe
- Vérifier les permissions du dossier
- Vérifier les chemins dans la base de données

### Erreur 404 sur les servlets
- Vérifier que les annotations `@WebServlet` sont correctes
- Vérifier que le serveur est bien redémarré après modifications

---

Pour plus de détails, consulter le **README.md** complet.

