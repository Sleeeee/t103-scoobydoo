# ScoobyDoo / Projet de manipulation de bases de données
Cours de Structures et données - Y. Delvigne, J. Noël - Mai 2024

## Objectif
Développer un site web en HTML - CSS - JS (vanilla), qui par des requêtes AJAX, récupère, poste, modifie, ou supprime des données de la base de données

Use cases
- Informations sur les épisodes
  - Afficher la liste des séries en fonction de son format
  - Sélectionner une série et afficher la liste de ses épisodes
  - Sélectionner un épisode, et en afficher le nombre de monstres et le nombre de personnages principaux connus
  - Depuis le menu d'un épisode, afficher soit les monstres et leurs caractéristiques, soit les acteurs de doublage
  - Affecter un monstre à un épisode
  - Modifier les attributs d'un monstre d'un épisode
  - Retirer un monstre d'un épisode
- Création d'attributs / de monstres
  - Créer un type, sous-type, ou espèce de monstre
  - Créer un nouveau monstre avec des attributs existants
- Feuille statistique
  - Afficher les compteurs des séries, épisodes par série/personnage/doubleur, monstres et les différents attributs
  - Pour chaque compteur, afficher la liste des éléments correspondants
  - Sélectionner un élément dans une des listes afin d'en modifier la valeur ou le supprimer

## Mise en place
La base de donnée tourne sous SQLAnywhere 12 (Sybase). Le fichier setup.sql permet de recréer les structures nécessaires au fonctionnement du site. Le fichier .db doit se situer à la racine du répertoire du projet.
