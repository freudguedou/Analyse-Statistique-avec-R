# 📊 Analyse Statistique des Ventes avec R

**Auteur:** Freud GUEDOU  
**Date:** Juin 2025  
**Technologies:** R, ggplot2, dplyr, tidyr

## 📋 Description du Projet

Analyse statistique complète d'un dataset de ventes commerciales avec R. Ce projet démontre l'utilisation de statistiques descriptives, visualisations avancées avec ggplot2 et tests statistiques pour extraire des insights business.

## 🎯 Objectifs

- Réaliser des statistiques descriptives (moyenne, médiane, écart-type)
- Créer des visualisations professionnelles avec ggplot2
- Effectuer des tests statistiques (corrélation, t-test, ANOVA)
- Analyser les tendances et patterns de ventes
- Produire un rapport d'analyse complet

## 📊 Dataset Utilisé

**Source:** Données de ventes d'un commerce (simulées)  
**Période:** Janvier 2024 - Décembre 2024  
**Observations:** 365 jours de ventes  
**Variables:**
- `date` : Date de la transaction
- `produit` : Catégorie de produit (Électronique, Vêtements, Alimentation, Livres)
- `quantite` : Quantité vendue
- `prix_unitaire` : Prix par unité (FCFA)
- `montant_total` : Montant total de la vente
- `region` : Région de vente (Nord, Sud, Est, Ouest)
- `mode_paiement` : Mode de paiement (Cash, Mobile Money, Carte)

## 🔧 Prérequis

### Installation de R

- **Windows/Mac:** Téléchargez depuis [CRAN](https://cran.r-project.org/)
- **RStudio (recommandé):** [Télécharger RStudio](https://www.rstudio.com/products/rstudio/download/)

### Packages Requis

```r
install.packages(c("ggplot2", "dplyr", "tidyr", "readr", "lubridate", "scales", "corrplot"))
```

## 🚀 Installation et Utilisation

### 1. Cloner le dépôt

```bash
git clone https://github.com/votre-username/analyse-statistique-r.git
cd analyse-statistique-r
```

### 2. Ouvrir le projet dans RStudio

```r
# Ouvrir le fichier .Rproj ou
setwd("chemin/vers/analyse-statistique-r")
```

### 3. Exécuter l'analyse

```r
# Script principal
source("scripts/analyse_complete.R")

# Ou exécuter séparément
source("scripts/01_chargement_donnees.R")
source("scripts/02_statistiques_descriptives.R")
source("scripts/03_visualisations.R")
source("scripts/04_tests_statistiques.R")
```

## 📈 Analyses Réalisées

### 1. Statistiques Descriptives

- Mesures de tendance centrale (moyenne, médiane, mode)
- Mesures de dispersion (écart-type, variance, IQR)
- Statistiques par catégorie (produit, région)
- Analyse temporelle (évolution mensuelle)

### 2. Visualisations

- **Graphiques univariés:**
  - Histogrammes de distribution
  - Boîtes à moustaches (boxplots)
  - Graphiques en barres

- **Graphiques bivariés:**
  - Nuages de points (scatter plots)
  - Graphiques de corrélation
  - Séries temporelles

- **Graphiques multivariés:**
  - Facettes par catégorie
  - Heatmaps
  - Graphiques de densité

### 3. Tests Statistiques

- Test de normalité (Shapiro-Wilk)
- Test de Student (t-test)
- ANOVA (comparaison de moyennes)
- Corrélation de Pearson
- Chi-carré (indépendance)

## 📊 Résultats Clés

Les analyses révèlent :
- **Produit le plus vendu:** Électronique (35% des ventes)
- **Région la plus performante:** Sud (180K FCFA/mois)
- **Saisonnalité:** Pic de ventes en décembre (+40%)
- **Corrélation prix-quantité:** -0.45 (négative modérée)
- **Mode de paiement préféré:** Mobile Money (52%)

## 🛠️ Compétences Techniques Démontrées

- ✅ Manipulation de données avec dplyr
- ✅ Visualisation avec ggplot2
- ✅ Statistiques descriptives
- ✅ Tests d'hypothèses
- ✅ Analyse de corrélation
- ✅ Gestion de séries temporelles
- ✅ Création de rapports reproductibles

## 📁 Structure du Projet

```
analyse-statistique-r/
│
├── README.md
├── data/
│   └── ventes_2024.csv
├── scripts/
│   ├── 01_chargement_donnees.R
│   ├── 02_statistiques_descriptives.R
│   ├── 03_visualisations.R
│   └── 04_tests_statistiques.R
├── outputs/
│   ├── graphiques/
│   └── resultats/
└── docs/
    └── rapport_analyse.pdf
```

## 📈 Évolutions Possibles

- Modélisation prédictive (régression linéaire)
- Clustering des clients
- Analyse de séries temporelles avancée (ARIMA)
- Dashboard interactif avec Shiny
- Intégration avec une base de données
- Automatisation des rapports avec R Markdown

## 📚 Ressources Supplémentaires

- [R for Data Science](https://r4ds.had.co.nz/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- [CRAN Task Views: Statistics](https://cran.r-project.org/web/views/)

## 📄 Licence

Ce projet est libre d'utilisation à des fins éducatives.

## 📧 Contact

Pour toute question sur ce projet, n'hésitez pas à ouvrir une issue sur GitHub.

---

**Note:** Ce projet utilise des données simulées à des fins pédagogiques. Les résultats ne reflètent pas de véritables transactions commerciales.
