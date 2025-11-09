# Plateforme d'échange étudiant

## 📋 Table des matières

1. [Description du projet](#description-du-projet)
2. [Technologies utilisées](#technologies-utilisées)
3. [Architecture du projet](#architecture-du-projet)
4. [Fonctionnalités](#fonctionnalités)
5. [Structure du projet](#structure-du-projet)
6. [Installation et configuration](#installation-et-configuration)
7. [Base de données](#base-de-données)
8. [Guide d'utilisation](#guide-dutilisation)
9. [API et Routes](#api-et-routes)
10. [Sécurité](#sécurité)
11. [Améliorations futures](#améliorations-futures)

---

## 🎯 Description du projet

La **Plateforme d'échange étudiant** est une application web J2EE permettant aux étudiants d'un établissement de :
- **Vendre** des objets (livres, matériel informatique, meubles, etc.)
- **Donner** des objets gratuitement à d'autres étudiants
- **Signaler** des objets trouvés ou perdus sur le campus

L'application facilite l'échange et la solidarité entre étudiants tout en offrant une interface moderne et intuitive.

### Objectifs du projet

- Créer une plateforme d'échange entre étudiants
- Gérer trois types de publications : ventes, dons, objets trouvés
- Permettre aux utilisateurs de gérer leurs propres publications
- Faciliter la recherche et la consultation des annonces
- Intégrer un système d'upload et d'affichage d'images

---

## 🛠 Technologies utilisées

### Backend
- **Java** : Langage de programmation principal
- **Jakarta EE 9+** : Framework Java Enterprise
- **Hibernate 7.1.4** : ORM (Object-Relational Mapping) pour la gestion de la base de données
- **Jakarta Servlet API 6.2** : Pour la création des servlets
- **MySQL** : Système de gestion de base de données relationnelle
- **Maven** : Gestionnaire de dépendances et build

### Frontend
- **JSP (JavaServer Pages)** : Pour la génération de pages web dynamiques
- **Bootstrap 5.1.3** : Framework CSS pour le design responsive
- **Font Awesome 6.0** : Bibliothèque d'icônes
- **JavaScript** : Pour les interactions client-side

### Outils
- **Lombok** : Pour réduire le code boilerplate
- **JDBC MySQL Connector 9.4** : Driver pour la connexion à MySQL

---

## 🏗 Architecture du projet

### Architecture MVC (Model-View-Controller)

Le projet suit une architecture MVC classique :

```
┌─────────────────────────────────────────────────────────┐
│                     Vue (JSP)                           │
│  - Interface utilisateur                                │
│  - Présentation des données                             │
└─────────────────────────────────────────────────────────┘
                        ↕
┌─────────────────────────────────────────────────────────┐
│                 Contrôleur (Servlets)                   │
│  - Gestion des requêtes HTTP                            │
│  - Validation des données                               │
│  - Coordination entre Vue et Modèle                     │
└─────────────────────────────────────────────────────────┘
                        ↕
┌─────────────────────────────────────────────────────────┐
│                  Modèle (Services/DAO)                  │
│  - Logique métier                                       │
│  - Accès aux données                                    │
│  - Entités JPA/Hibernate                                │
└─────────────────────────────────────────────────────────┘
                        ↕
┌─────────────────────────────────────────────────────────┐
│              Base de données (MySQL)                    │
│  - Stockage persistant des données                      │
└─────────────────────────────────────────────────────────┘
```

### Couches de l'application

1. **Couche Présentation (View)**
   - Pages JSP pour l'interface utilisateur
   - Bootstrap pour le design responsive
   - JavaScript pour les interactions

2. **Couche Contrôleur**
   - Servlets pour gérer les requêtes HTTP
   - Gestion des sessions utilisateur
   - Redirections et forwarding

3. **Couche Service**
   - Logique métier de l'application
   - Gestion des transactions
   - Validation des données

4. **Couche DAO (Data Access Object)**
   - Accès à la base de données
   - Requêtes HQL (Hibernate Query Language)
   - Gestion des entités

5. **Couche Modèle**
   - Entités JPA/Hibernate
   - Relations entre entités
   - Annotations de mapping

---

## ✨ Fonctionnalités

### 1. Authentification et gestion des utilisateurs

#### Inscription
- Formulaire d'inscription avec validation
- Champs : nom, email, mot de passe, filière, téléphone (optionnel)
- Vérification de l'unicité de l'email
- Attribution automatique du rôle "student"

#### Connexion
- Authentification par email et mot de passe
- Gestion de session utilisateur
- Redirection selon l'état de connexion

#### Déconnexion
- Invalidation de la session
- Redirection vers la page d'accueil

### 2. Gestion des produits (Ventes)

#### Affichage des produits
- Liste de tous les produits disponibles
- Affichage des images, prix, description, vendeur
- Filtrage par propriétaire :
  - **Tous les produits** : Affiche tous les produits
  - **Mes produits** : Affiche uniquement les produits de l'utilisateur connecté
  - **Produits des autres** : Affiche les produits des autres utilisateurs

#### Recherche de produits
- Recherche par nom ou description
- Recherche en temps réel
- Conservation de la recherche lors du filtrage

#### Ajout de produit
- Formulaire d'ajout avec validation
- Upload de jusqu'à 4 images par produit
- Génération de noms de fichiers uniques (UUID)
- Stockage des images dans le système de fichiers
- Enregistrement des métadonnées en base de données

#### Modification de produit
- Édition des informations (nom, description, prix)
- Ajout de nouvelles images (jusqu'à 4 au total)
- Suppression d'images individuelles
- Vérification de la propriété avant modification

#### Suppression de produit
- Suppression avec confirmation
- Suppression des images physiques associées
- Suppression en cascade des images en base de données
- Redirection vers "Mes produits" après suppression

#### Détails du produit
- Affichage complet des informations
- Galerie d'images avec navigation
- Informations du vendeur (nom, filière, téléphone)
- Boutons de contact (téléphone, WhatsApp)
- Boutons Modifier/Supprimer pour le propriétaire

### 3. Gestion des dons

#### Affichage des dons
- Liste de tous les dons disponibles
- Filtrage par propriétaire (tous, mes dons, dons des autres)
- Affichage des informations du donateur

#### Ajout de don
- Formulaire simple (titre, description)
- Association automatique à l'utilisateur connecté
- Badge "GRATUIT" pour identifier les dons

#### Consultation des dons
- Affichage des dons avec informations du donateur
- Possibilité de contacter le donateur

### 4. Gestion des objets trouvés

#### Affichage des objets
- Liste des objets signalés
- Filtrage par propriétaire (tous, mes objets, objets des autres)
- Affichage du lieu de découverte

#### Ajout d'objet trouvé
- Formulaire avec titre, description, lieu
- Association à l'utilisateur qui a trouvé l'objet
- Affichage des informations de contact

#### Consultation des objets
- Affichage des détails de l'objet
- Informations du personne qui a trouvé l'objet
- Possibilité de contacter pour récupérer l'objet

### 5. Gestion des images

#### Upload d'images
- Support de multiples formats (JPG, PNG, GIF)
- Limite de 4 images par produit
- Validation de la taille des fichiers (max 10MB par image)
- Génération de noms uniques pour éviter les conflits

#### Affichage des images
- Affichage de la première image sur la carte produit
- Galerie complète dans la page de détails
- Navigation entre les images via miniatures
- Modal pour agrandir les images

#### Suppression d'images
- Suppression individuelle d'images
- Suppression des fichiers physiques
- Mise à jour de la base de données

---

## 📁 Structure du projet

```
projet_jee/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/
│   │   │       ├── dao/                    # Couche d'accès aux données
│   │   │       │   ├── DonationDao.java
│   │   │       │   ├── LostAndFoundDao.java
│   │   │       │   ├── ProductDao.java
│   │   │       │   ├── ProductImageDao.java
│   │   │       │   └── StudentDao.java
│   │   │       │
│   │   │       ├── model/                  # Entités JPA
│   │   │       │   ├── Donation.java
│   │   │       │   ├── LostAndFound.java
│   │   │       │   ├── Product.java
│   │   │       │   ├── ProductImage.java
│   │   │       │   └── Student.java
│   │   │       │
│   │   │       ├── service/                # Couche service (logique métier)
│   │   │       │   ├── DonationService.java
│   │   │       │   ├── LostAndFoundService.java
│   │   │       │   ├── ProductService.java
│   │   │       │   └── StudentService.java
│   │   │       │
│   │   │       ├── util/                   # Utilitaires
│   │   │       │   ├── HibernateUtil.java
│   │   │       │   └── HibernateTest.java
│   │   │       │
│   │   │       └── web/
│   │   │           └── servlets/           # Contrôleurs (Servlets)
│   │   │               ├── AuthServlet.java
│   │   │               ├── DonationServlet.java
│   │   │               ├── ImageServlet.java
│   │   │               ├── LostAndFoundServlet.java
│   │   │               └── ProductServlet.java
│   │   │
│   │   ├── resources/
│   │   │   └── hibernate.cfg.xml          # Configuration Hibernate
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                # Descripteur de déploiement
│   │       │
│   │       ├── index.jsp                  # Page d'accueil
│   │       ├── login.jsp                  # Page de connexion
│   │       ├── register.jsp               # Page d'inscription
│   │       │
│   │       ├── products.jsp               # Liste des produits
│   │       ├── productForm.jsp            # Formulaire d'ajout de produit
│   │       ├── productEdit.jsp            # Formulaire d'édition de produit
│   │       ├── productDetails.jsp         # Détails d'un produit
│   │       │
│   │       ├── donations.jsp              # Liste des dons
│   │       ├── donationForm.jsp           # Formulaire d'ajout de don
│   │       │
│   │       ├── lostFound.jsp              # Liste des objets trouvés
│   │       └── lostFoundForm.jsp          # Formulaire d'ajout d'objet trouvé
│   │
│   └── test/                              # Tests unitaires (à implémenter)
│
├── target/                                # Fichiers compilés (généré)
├── pom.xml                                # Configuration Maven
└── README.md                              # Ce fichier
```

---

## 🚀 Installation et configuration

### Prérequis

- **Java JDK** 11 ou supérieur
- **Apache Maven** 3.6 ou supérieur
- **MySQL** 8.0 ou supérieur
- **Serveur d'application** : Apache Tomcat 10+ (ou équivalent compatible Jakarta EE 9+)
- **IDE** : IntelliJ IDEA, Eclipse, ou VS Code (recommandé)

### Installation

1. **Cloner le projet**
   ```bash
   git clone <url-du-projet>
   cd projet_jee
   ```

2. **Configurer la base de données MySQL**

   Créer la base de données :
   ```sql
   CREATE DATABASE student_platform;
   ```

   Modifier la configuration dans `src/main/resources/hibernate.cfg.xml` :
   ```xml
   <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/student_platform?useSSL=false&amp;serverTimezone=UTC</property>
   <property name="hibernate.connection.username">votre_username</property>
   <property name="hibernate.connection.password">votre_password</property>
   ```

3. **Compiler le projet avec Maven**
   ```bash
   mvn clean compile
   ```

4. **Créer le fichier WAR**
   ```bash
   mvn clean package
   ```
   Le fichier `projet_jee.war` sera généré dans le dossier `target/`

5. **Déployer sur Tomcat**
   - Copier le fichier WAR dans le dossier `webapps/` de Tomcat
   - Démarrer Tomcat
   - Accéder à l'application : `http://localhost:8080/projet_jee/`

### Configuration Hibernate

Hibernate est configuré pour créer automatiquement les tables (`hibernate.hbm2ddl.auto=update`). Les tables suivantes seront créées automatiquement :

- `students` : Utilisateurs de la plateforme
- `products` : Produits à vendre
- `product_images` : Images des produits
- `donations` : Dons
- `lost_and_found` : Objets trouvés

---

## 🗄 Base de données

### Schéma de la base de données

#### Table `students`
```sql
CREATE TABLE students (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    filiere VARCHAR(255),
    phone VARCHAR(255),
    role VARCHAR(50) DEFAULT 'student'
);
```

#### Table `products`
```sql
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    student_id BIGINT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

#### Table `product_images`
```sql
CREATE TABLE product_images (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    filename VARCHAR(255),
    filepath VARCHAR(500),
    product_id BIGINT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
```

#### Table `donations`
```sql
CREATE TABLE donations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    student_id BIGINT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

#### Table `lost_and_found`
```sql
CREATE TABLE lost_and_found (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    location VARCHAR(255),
    student_id BIGINT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

### Relations entre les entités

- **Student → Product** : One-to-Many (un étudiant peut avoir plusieurs produits)
- **Student → Donation** : One-to-Many (un étudiant peut faire plusieurs dons)
- **Student → LostAndFound** : One-to-Many (un étudiant peut signaler plusieurs objets)
- **Product → ProductImage** : One-to-Many (un produit peut avoir plusieurs images)
- **Product → Student** : Many-to-One (plusieurs produits appartiennent à un étudiant)

---

## 📖 Guide d'utilisation

### Pour les utilisateurs

#### 1. Inscription
1. Accéder à la page d'inscription
2. Remplir le formulaire (nom, email, mot de passe, filière)
3. Optionnellement ajouter un numéro de téléphone
4. Cliquer sur "S'inscrire"

#### 2. Connexion
1. Accéder à la page de connexion
2. Saisir l'email et le mot de passe
3. Cliquer sur "Se connecter"

#### 3. Ajouter un produit à vendre
1. Se connecter
2. Cliquer sur "Ajouter un produit" dans le menu
3. Remplir le formulaire (nom, description, prix)
4. Sélectionner jusqu'à 4 images
5. Cliquer sur "Publier le produit"

#### 4. Modifier un produit
1. Accéder aux détails de votre produit
2. Cliquer sur "Modifier"
3. Modifier les informations souhaitées
4. Ajouter ou supprimer des images si nécessaire
5. Cliquer sur "Enregistrer les modifications"

#### 5. Supprimer un produit
1. Accéder aux détails de votre produit
2. Cliquer sur "Supprimer"
3. Confirmer la suppression

#### 6. Rechercher un produit
1. Aller sur la page des produits
2. Saisir un mot-clé dans la barre de recherche
3. Cliquer sur l'icône de recherche ou appuyer sur Entrée

#### 7. Filtrer les produits
1. Sur la page des produits, utiliser les onglets :
   - **Tous les produits** : Affiche tous les produits
   - **Mes produits** : Affiche uniquement vos produits
   - **Produits des autres** : Affiche les produits des autres utilisateurs

#### 8. Contacter un vendeur
1. Accéder aux détails d'un produit
2. Cliquer sur "Contacter le vendeur"
3. Une conversation WhatsApp s'ouvre automatiquement (si le téléphone est disponible)

### Pour les développeurs

#### Ajouter une nouvelle fonctionnalité

1. **Créer l'entité** dans `model/`
   ```java
   @Entity
   @Table(name = "nom_table")
   public class NomEntite {
       // Propriétés et annotations
   }
   ```

2. **Créer le DAO** dans `dao/`
   ```java
   public class NomDao {
       // Méthodes d'accès aux données
   }
   ```

3. **Créer le Service** dans `service/`
   ```java
   public class NomService {
       // Logique métier
   }
   ```

4. **Créer le Servlet** dans `web/servlets/`
   ```java
   @WebServlet("/nom/*")
   public class NomServlet extends HttpServlet {
       // Gestion des requêtes HTTP
   }
   ```

5. **Créer les pages JSP** dans `webapp/`
   - Page de liste
   - Page de formulaire
   - Page de détails (si nécessaire)

---

## 🔌 API et Routes

### Routes d'authentification

- `GET /auth/logout` - Déconnexion
- `POST /auth/login` - Connexion
- `POST /auth/register` - Inscription

### Routes des produits

- `GET /products` - Liste des produits (avec filtres optionnels : `?filter=mine|others`, `?search=terme`)
- `GET /products/add` - Formulaire d'ajout de produit
- `POST /products/add` - Ajouter un produit
- `GET /products/{id}` - Détails d'un produit
- `GET /products/{id}/edit` - Formulaire d'édition de produit
- `POST /products/{id}/update` - Mettre à jour un produit
- `GET /products/{id}/delete` - Supprimer un produit
- `GET /products/{productId}/image/{imageId}/delete` - Supprimer une image

### Routes des dons

- `GET /donations` - Liste des dons (avec filtres optionnels)
- `GET /donations/add` - Formulaire d'ajout de don
- `POST /donations/add` - Ajouter un don

### Routes des objets trouvés

- `GET /lostfound` - Liste des objets trouvés (avec filtres optionnels)
- `GET /lostfound/add` - Formulaire d'ajout d'objet trouvé
- `POST /lostfound/add` - Ajouter un objet trouvé

### Routes des images

- `GET /images/{filename}` - Servir une image

---

## 🔒 Sécurité

### Mesures de sécurité implémentées

1. **Authentification**
   - Vérification de l'email et du mot de passe
   - Gestion de session utilisateur
   - Protection des routes nécessitant une authentification

2. **Autorisation**
   - Vérification de la propriété avant modification/suppression
   - Seul le propriétaire peut modifier ou supprimer ses publications
   - Messages d'erreur appropriés en cas d'accès non autorisé

3. **Validation des données**
   - Validation côté serveur des formulaires
   - Vérification des types de données
   - Limitation de la taille des fichiers uploadés

4. **Gestion des erreurs**
   - Messages d'erreur clairs pour l'utilisateur
   - Journalisation des erreurs pour le débogage
   - Gestion des exceptions

### Améliorations de sécurité recommandées

- [ ] Hashage des mots de passe (BCrypt)
- [ ] Protection CSRF (Cross-Site Request Forgery)
- [ ] Validation et sanitization des entrées utilisateur
- [ ] Limitation du taux de requêtes (Rate Limiting)
- [ ] HTTPS pour les connexions sécurisées

---

## 🎨 Interface utilisateur

### Design

- **Framework CSS** : Bootstrap 5.1.3
- **Thème** : Design moderne avec dégradés de couleurs
- **Responsive** : Adaptation aux différentes tailles d'écran
- **Icônes** : Font Awesome 6.0

### Pages principales

1. **Page d'accueil** (`index.jsp`)
   - Présentation de la plateforme
   - Navigation vers les différentes sections
   - Appels à l'action

2. **Page des produits** (`products.jsp`)
   - Liste des produits avec images
   - Barre de recherche
   - Filtres par propriétaire
   - Cartes produits avec informations essentielles

3. **Page de détails** (`productDetails.jsp`)
   - Informations complètes du produit
   - Galerie d'images
   - Informations du vendeur
   - Boutons d'action

4. **Formulaire d'ajout/édition** (`productForm.jsp`, `productEdit.jsp`)
   - Formulaire intuitif
   - Aperçu des images
   - Validation en temps réel

---

## 📊 Fonctionnalités avancées

### Filtrage et recherche

- **Recherche textuelle** : Recherche par nom ou description
- **Filtrage par propriétaire** : Tous, mes publications, publications des autres
- **Combinaison** : Recherche et filtrage peuvent être combinés

### Gestion des images

- **Upload multiple** : Jusqu'à 4 images par produit
- **Stockage** : Images stockées dans le système de fichiers
- **Métadonnées** : Informations stockées en base de données
- **Affichage** : Galerie avec navigation et modal d'agrandissement
- **Suppression** : Suppression individuelle ou en cascade

### Distinction visuelle

- **Badges** : Identification des publications de l'utilisateur
- **Bordures colorées** : Différenciation visuelle
- **En-têtes** : Indication claire de la propriété

---

## 🧪 Tests

### Tests à implémenter

1. **Tests unitaires**
   - Tests des services
   - Tests des DAO
   - Tests de validation

2. **Tests d'intégration**
   - Tests des servlets
   - Tests de la base de données
   - Tests des relations entre entités

3. **Tests fonctionnels**
   - Tests des flux utilisateur
   - Tests des formulaires
   - Tests de l'upload d'images

---

## 🐛 Gestion des erreurs

### Types d'erreurs gérées

1. **Erreurs de validation**
   - Champs obligatoires manquants
   - Formats invalides
   - Valeurs hors limites

2. **Erreurs d'authentification**
   - Identifiants incorrects
   - Session expirée
   - Accès non autorisé

3. **Erreurs de base de données**
   - Connexion échouée
   - Requêtes échouées
   - Contraintes violées

4. **Erreurs de fichiers**
   - Fichiers trop volumineux
   - Formats non supportés
   - Erreurs d'upload

### Journalisation

- Utilisation de `java.util.logging.Logger`
- Niveaux de log : INFO, WARNING, SEVERE
- Logs détaillés pour le débogage

---

## 📈 Améliorations futures

### Fonctionnalités à ajouter

1. **Système de messagerie**
   - Messages entre utilisateurs
   - Notifications de nouveaux messages

2. **Système de favoris**
   - Ajouter des produits aux favoris
   - Liste des favoris

3. **Système de commentaires**
   - Commentaires sur les produits
   - Questions/réponses

4. **Système de notation**
   - Notation des vendeurs
   - Avis sur les transactions

5. **Recherche avancée**
   - Filtres par prix
   - Filtres par filière
   - Tri des résultats

6. **Pagination**
   - Pagination des résultats
   - Limite du nombre d'éléments par page

7. **Administration**
   - Panneau d'administration
   - Gestion des utilisateurs
   - Modération des publications

8. **Notifications**
   - Notifications par email
   - Notifications en temps réel

9. **Statistiques**
   - Tableau de bord utilisateur
   - Statistiques des publications

10. **Export de données**
    - Export en PDF
    - Export en Excel

---

## 📝 Points techniques importants

### Hibernate et JPA

- **Mapping ORM** : Utilisation d'Hibernate pour le mapping objet-relationnel
- **Lazy Loading** : Chargement à la demande des relations
- **Fetch Joins** : Utilisation de JOIN FETCH pour éviter les problèmes de lazy loading
- **Cascade** : Suppression en cascade des images lors de la suppression d'un produit
- **Transactions** : Gestion des transactions pour garantir l'intégrité des données

### Gestion des fichiers

- **Upload** : Utilisation de `@MultipartConfig` pour gérer les uploads
- **Stockage** : Images stockées dans `uploads/products/`
- **Noms uniques** : Utilisation d'UUID pour générer des noms de fichiers uniques
- **Servir les images** : Servlet dédié pour servir les images (`ImageServlet`)

### Sessions et authentification

- **Sessions HTTP** : Utilisation de `HttpSession` pour gérer l'authentification
- **Attributs de session** : Stockage de l'utilisateur connecté dans la session
- **Protection des routes** : Vérification de l'authentification avant accès aux routes protégées

### Architecture des servlets

- **Annotations** : Utilisation de `@WebServlet` pour le mapping des URLs
- **Path Info** : Utilisation de `pathInfo` pour gérer les routes REST-like
- **Méthodes HTTP** : Séparation des méthodes GET et POST
- **Redirections** : Utilisation de `sendRedirect` pour les redirections
- **Forwarding** : Utilisation de `RequestDispatcher` pour le forwarding

---

## 📚 Bibliographie et ressources

### Documentation utilisée

- [Jakarta EE Documentation](https://jakarta.ee/)
- [Hibernate User Guide](https://docs.jboss.org/hibernate/orm/current/userguide/html_single/Hibernate_User_Guide.html)
- [Bootstrap Documentation](https://getbootstrap.com/docs/5.1/)
- [Servlet API Documentation](https://jakarta.ee/specifications/servlet/)

### Outils et frameworks

- **Maven** : Gestion des dépendances
- **Hibernate** : ORM
- **Bootstrap** : Framework CSS
- **Font Awesome** : Icônes

---

## 👥 Auteur

- **Nom** : [Votre nom]
- **Institution** : [Nom de l'institution]
- **Année** : 2024

---

## 📄 Licence

Ce projet est développé dans le cadre d'un projet académique.

---

## 🎓 Conclusion

Cette plateforme d'échange étudiant offre une solution complète pour faciliter les échanges entre étudiants. Elle intègre les technologies modernes du développement web Java (Jakarta EE, Hibernate, JSP) et offre une interface utilisateur moderne et intuitive.

### Points forts du projet

- ✅ Architecture MVC bien structurée
- ✅ Séparation claire des responsabilités
- ✅ Gestion complète des trois types de publications
- ✅ Système d'upload et d'affichage d'images
- ✅ Recherche et filtrage avancés
- ✅ Interface utilisateur moderne et responsive
- ✅ Gestion des permissions et de la sécurité

### Compétences démontrées

- Maîtrise de Java et Jakarta EE
- Connaissance d'Hibernate et JPA
- Développement web avec JSP
- Gestion de base de données MySQL
- Architecture logicielle (MVC)
- Développement frontend (Bootstrap, JavaScript)
- Gestion de projet avec Maven

---

## 📞 Support

Pour toute question ou problème, veuillez consulter la documentation ou contacter le développeur.

---

**Dernière mise à jour** : 2024

