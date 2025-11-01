# ============================================================================
# ANALYSE STATISTIQUE COMPLÈTE DES VENTES
# Auteur: Freud GUEDOU
# Date: Juin 2025
# Description: Analyse descriptive, visualisations et tests statistiques
# ============================================================================

# ============================================================================
# 1. CHARGEMENT DES PACKAGES
# ============================================================================

# Installation des packages si nécessaire
packages <- c("ggplot2", "dplyr", "tidyr", "readr", "lubridate", 
              "scales", "corrplot", "gridExtra")

for(pkg in packages) {
  if(!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

cat("\n=== Packages chargés avec succès ===\n\n")

# ============================================================================
# 2. CHARGEMENT ET PRÉPARATION DES DONNÉES
# ============================================================================

# Chargement du dataset
ventes <- read_csv("data/ventes_2024.csv", show_col_types = FALSE)

# Conversion de la colonne date
ventes <- ventes %>%
  mutate(
    date = as.Date(date),
    mois = month(date, label = TRUE, abbr = FALSE),
    trimestre = quarter(date),
    jour_semaine = wday(date, label = TRUE, abbr = FALSE)
  )

cat("\n=== Données chargées ===\n")
cat("Nombre d'observations:", nrow(ventes), "\n")
cat("Nombre de variables:", ncol(ventes), "\n")
print(head(ventes, 3))

# ============================================================================
# 3. STATISTIQUES DESCRIPTIVES
# ============================================================================

cat("\n\n========================================\n")
cat("STATISTIQUES DESCRIPTIVES\n")
cat("========================================\n\n")

# --- 3.1 Statistiques générales ---
cat("--- Statistiques sur le montant total ---\n")
stats_montant <- summary(ventes$montant_total)
print(stats_montant)

cat("\nÉcart-type:", sd(ventes$montant_total), "\n")
cat("Variance:", var(ventes$montant_total), "\n")
cat("Coefficient de variation:", sd(ventes$montant_total) / mean(ventes$montant_total), "\n")

# --- 3.2 Statistiques par produit ---
cat("\n--- Ventes par produit ---\n")
stats_produit <- ventes %>%
  group_by(produit) %>%
  summarise(
    nombre_ventes = n(),
    montant_moyen = mean(montant_total),
    montant_total = sum(montant_total),
    quantite_moyenne = mean(quantite),
    quantite_totale = sum(quantite)
  ) %>%
  arrange(desc(montant_total))

print(stats_produit)

# --- 3.3 Statistiques par région ---
cat("\n--- Ventes par région ---\n")
stats_region <- ventes %>%
  group_by(region) %>%
  summarise(
    nombre_ventes = n(),
    montant_moyen = mean(montant_total),
    montant_total = sum(montant_total)
  ) %>%
  arrange(desc(montant_total))

print(stats_region)

# --- 3.4 Statistiques par mode de paiement ---
cat("\n--- Répartition par mode de paiement ---\n")
stats_paiement <- ventes %>%
  group_by(mode_paiement) %>%
  summarise(
    nombre_ventes = n(),
    pourcentage = round(n() / nrow(ventes) * 100, 2),
    montant_total = sum(montant_total)
  ) %>%
  arrange(desc(nombre_ventes))

print(stats_paiement)

# --- 3.5 Évolution mensuelle ---
cat("\n--- Évolution mensuelle des ventes ---\n")
stats_mensuelle <- ventes %>%
  group_by(mois) %>%
  summarise(
    nombre_ventes = n(),
    montant_total = sum(montant_total),
    montant_moyen = mean(montant_total)
  )

print(stats_mensuelle)

# ============================================================================
# 4. TESTS STATISTIQUES
# ============================================================================

cat("\n\n========================================\n")
cat("TESTS STATISTIQUES\n")
cat("========================================\n\n")

# --- 4.1 Test de normalité (Shapiro-Wilk) ---
cat("--- Test de normalité sur le montant total ---\n")
shapiro_test <- shapiro.test(ventes$montant_total)
cat("Statistique W:", shapiro_test$statistic, "\n")
cat("p-value:", shapiro_test$p.value, "\n")
cat("Interprétation:", 
    ifelse(shapiro_test$p.value > 0.05, 
           "Les données suivent une distribution normale",
           "Les données ne suivent pas une distribution normale"), "\n\n")

# --- 4.2 Corrélation entre quantité et prix unitaire ---
cat("--- Corrélation entre quantité et prix unitaire ---\n")
correlation <- cor.test(ventes$quantite, ventes$prix_unitaire)
cat("Coefficient de corrélation (Pearson):", correlation$estimate, "\n")
cat("p-value:", correlation$p.value, "\n")
cat("Interprétation:", 
    ifelse(abs(correlation$estimate) > 0.5,
           "Corrélation forte",
           ifelse(abs(correlation$estimate) > 0.3,
                  "Corrélation modérée",
                  "Corrélation faible")), "\n\n")

# --- 4.3 Test t de Student (comparaison de moyennes) ---
# Comparaison des ventes entre deux régions
cat("--- Test t: Comparaison des montants entre Sud et Nord ---\n")
ventes_sud <- ventes %>% filter(region == "Sud") %>% pull(montant_total)
ventes_nord <- ventes %>% filter(region == "Nord") %>% pull(montant_total)

t_test <- t.test(ventes_sud, ventes_nord)
cat("Moyenne Sud:", mean(ventes_sud), "\n")
cat("Moyenne Nord:", mean(ventes_nord), "\n")
cat("Différence:", mean(ventes_sud) - mean(ventes_nord), "\n")
cat("p-value:", t_test$p.value, "\n")
cat("Interprétation:", 
    ifelse(t_test$p.value < 0.05,
           "Différence significative entre les deux régions",
           "Pas de différence significative"), "\n\n")

# --- 4.4 ANOVA (comparaison de plusieurs groupes) ---
cat("--- ANOVA: Comparaison des montants entre tous les produits ---\n")
anova_test <- aov(montant_total ~ produit, data = ventes)
anova_summary <- summary(anova_test)
print(anova_summary)

cat("\nInterprétation:", 
    ifelse(anova_summary[[1]]$`Pr(>F)`[1] < 0.05,
           "Il existe une différence significative entre les produits",
           "Pas de différence significative entre les produits"), "\n\n")

# --- 4.5 Test du Chi-carré (indépendance) ---
cat("--- Test du Chi-carré: Indépendance produit vs région ---\n")
table_contingence <- table(ventes$produit, ventes$region)
chi_test <- chisq.test(table_contingence)
cat("Chi-carré:", chi_test$statistic, "\n")
cat("p-value:", chi_test$p.value, "\n")
cat("Interprétation:", 
    ifelse(chi_test$p.value < 0.05,
           "Les variables produit et région sont dépendantes",
           "Les variables produit et région sont indépendantes"), "\n\n")

# ============================================================================
# 5. INSIGHTS CLÉS
# ============================================================================

cat("\n\n========================================\n")
cat("INSIGHTS CLÉS\n")
cat("========================================\n\n")

# Produit le plus vendu
produit_top <- stats_produit %>% slice(1)
cat("✓ Produit le plus vendu:", produit_top$produit, "\n")
cat("  Montant total:", format(produit_top$montant_total, big.mark = " "), "FCFA\n")
cat("  Part de marché:", round(produit_top$montant_total / sum(ventes$montant_total) * 100, 2), "%\n\n")

# Région la plus performante
region_top <- stats_region %>% slice(1)
cat("✓ Région la plus performante:", region_top$region, "\n")
cat("  Montant moyen:", format(region_top$montant_moyen, big.mark = " "), "FCFA\n\n")

# Mode de paiement préféré
paiement_top <- stats_paiement %>% slice(1)
cat("✓ Mode de paiement préféré:", paiement_top$mode_paiement, "\n")
cat("  Pourcentage:", paiement_top$pourcentage, "%\n\n")

# Mois le plus rentable
mois_top <- stats_mensuelle %>% arrange(desc(montant_total)) %>% slice(1)
cat("✓ Mois le plus rentable:", mois_top$mois, "\n")
cat("  Montant total:", format(mois_top$montant_total, big.mark = " "), "FCFA\n\n")

cat("\n=== Analyse terminée avec succès! ===\n")
cat("Les graphiques sont générés dans 'scripts/visualisations.R'\n")
