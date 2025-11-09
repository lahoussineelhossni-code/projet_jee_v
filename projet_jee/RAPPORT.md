# Rapport de Projet - Plateforme d'échange étudiant

## 📑 Table des matières

1. [Introduction](#introduction)
2. [Contexte et objectifs](#contexte-et-objectifs)
3. [Analyse et conception](#analyse-et-conception)
4. [Architecture technique](#architecture-technique)
5. [Implémentation](#implémentation)
6. [Fonctionnalités détaillées](#fonctionnalités-détaillées)
7. [Tests et validation](#tests-et-validation)
8. [Résultats et bilan](#résultats-et-bilan)
9. [Conclusion et perspectives](#conclusion-et-perspectives)

---

## 1. Introduction

### 1.1 Présentation du projet

La **Plateforme d'échange étudiant** est une application web développée en Java Enterprise Edition (Jakarta EE) permettant aux étudiants d'un établissement d'échanger des objets entre eux. L'application offre trois services principaux :
- La vente d'objets entre étudiants
- Le don d'objets gratuits
- La signalisation d'objets trouvés ou perdus

### 1.2 Problématique

Dans un contexte étudiant, les besoins d'échange de matériel (livres, matériel informatique, meubles) sont fréquents. Cependant, il n'existe pas toujours de solution centralisée et adaptée pour faciliter ces échanges. Cette plateforme répond à ce besoin en offrant :
- Une interface simple et intuitive
- Une gestion centralisée des annonces
- Un système de recherche efficace
- Une gestion des images pour illustrer les annonces

### 1.3 Objectifs

- Développer une application web complète avec Java EE
- Implémenter une architecture MVC propre
- Gérer trois types d'entités différentes (Produits, Dons, Objets trouvés)
- Intégrer un système d'upload et de gestion d'images
- Offrir une expérience utilisateur moderne et responsive

---

## 2. Contexte et objectifs

### 2.1 Technologies choisies

#### Backend
- **Java** : Langage de programmation orienté objet
- **Jakarta EE 9+** : Framework Java Enterprise pour le développement d'applications web
- **Hibernate 7.1.4** : ORM pour simplifier l'accès aux données
- **MySQL** : Base de données relationnelle

#### Frontend
- **JSP** : JavaServer Pages pour la génération de pages dynamiques
- **Bootstrap 5.1.3** : Framework CSS pour un design responsive
- **JavaScript** : Pour les interactions client-side
- **Font Awesome** : Bibliothèque d'icônes

#### Outils
- **Maven** : Gestionnaire de dépendances
- **Lombok** : Réduction du code boilerplate

### 2.2 Choix architecturaux

#### Architecture MVC
L'architecture Model-View-Controller a été choisie pour :
- Séparer clairement les responsabilités
- Faciliter la maintenance
- Améliorer la testabilité
- Suivre les bonnes pratiques Java EE

#### Pattern DAO
Le pattern Data Access Object est utilisé pour :
- Isoler l'accès aux données
- Faciliter les changements de base de données
- Améliorer la réutilisabilité

---

## 3. Analyse et conception

### 3.1 Modèle de données

#### Entité Student (Étudiant)
- **Propriétés** : id, name, email, password, filiere, phone, role
- **Relations** : One-to-Many avec Product, Donation, LostAndFound

#### Entité Product (Produit)
- **Propriétés** : id, name, description, price
- **Relations** : Many-to-One avec Student, One-to-Many avec ProductImage

#### Entité ProductImage (Image de produit)
- **Propriétés** : id, filename, filepath
- **Relations** : Many-to-One avec Product

#### Entité Donation (Don)
- **Propriétés** : id, title, description
- **Relations** : Many-to-One avec Student

#### Entité LostAndFound (Objet trouvé)
- **Propriétés** : id, title, description, location
- **Relations** : Many-to-One avec Student

### 3.2 Diagramme de classes

```
┌─────────────────┐
│    Student      │
├─────────────────┤
│ - id            │
│ - name          │
│ - email         │
│ - password      │
│ - filiere       │
│ - phone         │
│ - role          │
└─────────────────┘
        │
        │ 1
        │
        │ *
┌───────┴──────────┬──────────────────┐
│                  │                  │
│    Product       │   Donation       │   LostAndFound
├───────────────┤  ├──────────────┤  ├──────────────┤
│ - id          │  │ - id         │  │ - id         │
│ - name        │  │ - title      │  │ - title      │
│ - description │  │ - description│  │ - description│
│ - price       │  │              │  │ - location   │
└───────────────┘  └──────────────┘  └──────────────┘
        │
        │ 1
        │
        │ *
┌───────┴──────────┐
│  ProductImage    │
├──────────────────┤
│ - id             │
│ - filename       │
│ - filepath       │
└──────────────────┘
```

### 3.3 Cas d'utilisation

#### Utilisateur non authentifié
- Consulter les produits, dons, objets trouvés
- Rechercher des produits
- S'inscrire
- Se connecter

#### Utilisateur authentifié
- Ajouter un produit, don, objet trouvé
- Modifier ses propres publications
- Supprimer ses propres publications
- Contacter les vendeurs/donateurs
- Filtrer les publications (tous, mes publications, publications des autres)

---

## 4. Architecture technique

### 4.1 Architecture en couches

```
┌─────────────────────────────────────────┐
│         Couche Présentation             │
│  (JSP - Vue)                            │
│  - Interface utilisateur                │
│  - Affichage des données                │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│         Couche Contrôleur               │
│  (Servlets)                             │
│  - Gestion des requêtes HTTP            │
│  - Validation des données               │
│  - Coordination Vue/Modèle              │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│         Couche Service                  │
│  (Services)                             │
│  - Logique métier                       │
│  - Gestion des transactions             │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│         Couche DAO                      │
│  (Data Access Object)                   │
│  - Accès aux données                    │
│  - Requêtes HQL                         │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│         Couche Modèle                   │
│  (Entités JPA)                          │
│  - Modélisation des données             │
│  - Relations entre entités              │
└─────────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────────┐
│         Base de données                 │
│  (MySQL)                                │
│  - Stockage persistant                  │
└─────────────────────────────────────────┘
```

### 4.2 Flux de données

#### Ajout d'un produit

```
1. Utilisateur remplit le formulaire (JSP)
   ↓
2. Soumission du formulaire (POST)
   ↓
3. ProductServlet reçoit la requête
   ↓
4. Validation des données
   ↓
5. ProductService traite la logique métier
   ↓
6. Upload des images dans le système de fichiers
   ↓
7. ProductDao sauvegarde en base de données
   ↓
8. ProductImageDao sauvegarde les métadonnées des images
   ↓
9. Redirection vers la liste des produits
```

#### Affichage d'un produit

```
1. Utilisateur clique sur un produit
   ↓
2. Requête GET vers ProductServlet
   ↓
3. ProductService récupère le produit (avec images)
   ↓
4. ProductDao exécute une requête avec JOIN FETCH
   ↓
5. Les données sont passées à la JSP
   ↓
6. La JSP affiche le produit avec ses images
```

### 4.3 Gestion des sessions

- **Authentification** : L'utilisateur est stocké dans la session après connexion
- **Vérification** : Chaque action nécessitant une authentification vérifie la session
- **Expiration** : La session expire après 30 minutes d'inactivité
- **Déconnexion** : La session est invalidée lors de la déconnexion

---

## 5. Implémentation

### 5.1 Gestion des produits

#### Ajout de produit
- Formulaire avec validation
- Upload de fichiers multiples
- Génération de noms de fichiers uniques
- Stockage des métadonnées en base

#### Modification de produit
- Pré-remplissage du formulaire
- Mise à jour des données
- Ajout de nouvelles images
- Suppression d'images existantes

#### Suppression de produit
- Suppression avec confirmation
- Suppression des images physiques
- Suppression en cascade en base de données

### 5.2 Gestion des images

#### Upload
- Validation du type de fichier
- Limitation de la taille (10MB par image)
- Limitation du nombre (4 images max)
- Génération de noms uniques (UUID)

#### Stockage
- Images stockées dans `uploads/products/`
- Métadonnées stockées en base de données
- Chemin relatif stocké pour l'accès

#### Affichage
- Servlet dédié pour servir les images
- Support de différents formats
- Gestion des erreurs (image non trouvée)

### 5.3 Recherche et filtrage

#### Recherche
- Recherche par nom ou description
- Recherche insensible à la casse
- Conservation de la recherche lors du filtrage

#### Filtrage
- Filtre par propriétaire (tous, mes publications, publications des autres)
- Combinaison recherche + filtrage
- Mise à jour dynamique des résultats

### 5.4 Sécurité

#### Authentification
- Vérification des identifiants
- Gestion de session
- Protection des routes

#### Autorisation
- Vérification de la propriété
- Seul le propriétaire peut modifier/supprimer
- Messages d'erreur appropriés

---

## 6. Fonctionnalités détaillées

### 6.1 Authentification

#### Inscription
- Validation des champs
- Vérification de l'unicité de l'email
- Hashage du mot de passe (à implémenter)
- Attribution du rôle "student"

#### Connexion
- Vérification des identifiants
- Création de session
- Stockage de l'utilisateur en session
- Redirection selon l'état

### 6.2 Gestion des produits

#### Liste des produits
- Affichage avec images
- Pagination (à implémenter)
- Tri (à implémenter)
- Filtres et recherche

#### Détails du produit
- Informations complètes
- Galerie d'images
- Informations du vendeur
- Boutons d'action

#### Ajout/Modification
- Formulaire intuitif
- Validation en temps réel
- Aperçu des images
- Gestion des erreurs

### 6.3 Gestion des dons

#### Liste des dons
- Affichage des dons
- Filtrage par propriétaire
- Recherche

#### Ajout de don
- Formulaire simple
- Association à l'utilisateur
- Validation

### 6.4 Gestion des objets trouvés

#### Liste des objets
- Affichage des objets
- Filtrage par propriétaire
- Recherche

#### Ajout d'objet
- Formulaire avec lieu
- Association à l'utilisateur
- Validation

---

## 7. Tests et validation

### 7.1 Tests fonctionnels

#### Scénarios testés
- ✅ Inscription d'un nouvel utilisateur
- ✅ Connexion avec des identifiants valides
- ✅ Connexion avec des identifiants invalides
- ✅ Ajout d'un produit avec images
- ✅ Modification d'un produit
- ✅ Suppression d'un produit
- ✅ Recherche de produits
- ✅ Filtrage des produits
- ✅ Ajout de don
- ✅ Ajout d'objet trouvé

### 7.2 Tests de sécurité

#### Scénarios testés
- ✅ Accès non autorisé aux routes protégées
- ✅ Tentative de modification d'un produit d'un autre utilisateur
- ✅ Tentative de suppression d'un produit d'un autre utilisateur
- ✅ Upload de fichiers non autorisés

### 7.3 Validation des données

#### Champs validés
- ✅ Champs obligatoires
- ✅ Format email
- ✅ Format prix (nombre positif)
- ✅ Taille des fichiers
- ✅ Type de fichiers (images uniquement)
- ✅ Nombre d'images (maximum 4)

---

## 8. Résultats et bilan

### 8.1 Fonctionnalités réalisées

- ✅ Système d'authentification complet
- ✅ Gestion des produits (CRUD complet)
- ✅ Gestion des dons (CRUD)
- ✅ Gestion des objets trouvés (CRUD)
- ✅ Système d'upload et d'affichage d'images
- ✅ Recherche de produits
- ✅ Filtrage par propriétaire
- ✅ Distinction visuelle des publications
- ✅ Interface utilisateur moderne et responsive
- ✅ Gestion des permissions

### 8.2 Points forts

- Architecture MVC bien structurée
- Code organisé et maintenable
- Interface utilisateur intuitive
- Gestion complète des images
- Recherche et filtrage efficaces
- Sécurité implémentée

### 8.3 Points à améliorer

- Hashage des mots de passe (BCrypt)
- Pagination des résultats
- Système de messagerie
- Notifications
- Tests unitaires et d'intégration
- Gestion des erreurs plus fine
- Validation côté client (JavaScript)

---

## 9. Conclusion et perspectives

### 9.1 Bilan du projet

Ce projet a permis de développer une application web complète utilisant les technologies Java Enterprise Edition. L'architecture MVC mise en place facilite la maintenance et l'évolution de l'application. Les fonctionnalités principales sont opérationnelles et l'interface utilisateur offre une expérience agréable.

### 9.2 Compétences acquises

- Maîtrise de Java EE (Jakarta EE)
- Utilisation d'Hibernate pour l'ORM
- Développement d'applications web avec JSP
- Gestion de base de données MySQL
- Architecture logicielle (MVC, DAO)
- Développement frontend (Bootstrap, JavaScript)
- Gestion de projet avec Maven

### 9.3 Perspectives d'évolution

#### Court terme
- Implémentation du hashage des mots de passe
- Ajout de la pagination
- Amélioration de la validation

#### Moyen terme
- Système de messagerie entre utilisateurs
- Système de favoris
- Notifications

#### Long terme
- Application mobile
- API REST pour intégration avec d'autres applications
- Système de paiement en ligne
- Application d'administration

---

## 📊 Statistiques du projet

- **Nombre de classes Java** : 15+
- **Nombre de pages JSP** : 10
- **Nombre de servlets** : 5
- **Nombre de tables** : 5
- **Lignes de code** : ~3000+
- **Temps de développement** : [À compléter]

---

## 📚 Références

1. Jakarta EE Specification - https://jakarta.ee/
2. Hibernate User Guide - https://docs.jboss.org/hibernate/orm/
3. Bootstrap Documentation - https://getbootstrap.com/
4. MySQL Documentation - https://dev.mysql.com/doc/

---

**Date de rédaction** : 2024
**Version** : 1.0

