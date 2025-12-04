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

<img width="402" height="874" alt="Simulator Screenshot - iPhone 17 - 2025-12-04 at 02 28 29" src="https://github.com/user-attachments/assets/d0898103-f361-4472-843a-a06232c02729" />
<img width="402" height="874" alt="Simulator Screenshot - iPhone 17 - 2025-12-04 at 02 28 44" src="https://github.com/user-attachments/assets/84882c02-4622-428a-a183-7432bd0c586b" />

