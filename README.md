# Arista — Application de suivi d’exercices et de sommeil  
Projet réalisé dans le cadre de ma formation Développeur iOS (OpenClassrooms)

Arista est une petite application iOS développée en **SwiftUI**, permettant de saisir et suivre des **exercices physiques** ainsi que des **cycles de sommeil**.  
L’utilisateur peut ajouter ses données via une **modale** contenant un formulaire, afficher la liste de ses entrées et les supprimer.

Ce projet m’a permis de pratiquer la persistence locale, l’architecture MVVM et l’écriture de tests unitaires.

---

## Fonctionnalités

- Ajout d’un exercice ou d’une donnée de sommeil via une modale
- Formulaire simple avec validation basique
- Affichage des listes (exercices / sommeil)
- Suppression d’éléments
- Persistence des données avec **Core Data**

---

## Technologies utilisées

- **SwiftUI**
- **Core Data**
- **Architecture MVVM**
- **Repository pattern**
- **Tests unitaires (stack Core Data in-memory)**

---

## Architecture

- **Views** → Interface SwiftUI  
- **ViewModels** → Gestion de l’état et logique liée aux vues  
- **Repository** → Accès aux données Core Data  
- **PersistenceController** → Configuration et gestion du contexte

---

## Captures d’écran

<img width="546" height="1063" alt="CleanShot 2025-12-04 at 02 33 54@2x" src="https://github.com/user-attachments/assets/015bec31-d91b-4690-842b-fbefd5364b84" />
<img width="546" height="1063" alt="CleanShot 2025-12-04 at 02 35 10@2x" src="https://github.com/user-attachments/assets/c2aa7f36-d0dc-4811-a9b5-68e5d8f736a9" />
