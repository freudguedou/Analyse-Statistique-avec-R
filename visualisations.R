# ============================================================================
# VISUALISATIONS AVANCÉES AVEC GGPLOT2
# Auteur: Freud GUEDOU
# Date: Mars 2025
# Description: Graphiques professionnels pour l'analyse des ventes
# ============================================================================

# ============================================================================
# CHARGEMENT DES PACKAGES ET DONNÉES
# ============================================================================

library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(scales)
library(gridExtra)

# Chargement des données
ventes <- read_csv("data/ventes_2024.csv", show_col_types = FALSE) %>%
  mutate(
    date = as.Date(date),
    mois = month(date, label = TRUE, abbr = FALSE),
    trimestre = quarter(date)
  )

# Créer le dossier outputs si nécessaire
if(!dir.exists("outputs/graphiques")) {
  dir.create("outputs/graphiques", recursive = TRUE)
}

# Thème personnalisé pour tous les graphiques
theme_custom <- theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5),
    axis.title = element_text(size = 11, face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

cat("=== Génération des visualisations ===\n\n")

# ============================================================================
# 1. DISTRIBUTIONS UNIVARIÉES
# ============================================================================

cat("1. Histogramme de distribution des montants...\n")

# Histogramme du montant total
p1 <- ggplot(ventes, aes(x = montant_total)) +
  geom_histogram(bins = 30, fill = "#3498db", color = "white", alpha = 0.8) +
  geom_vline(aes(xintercept = mean(montant_total)), 
             color = "#e74c3c", linetype = "dashed", size = 1) +
  labs(
    title = "Distribution des Montants de Vente",
    subtitle = "Ligne rouge = moyenne",
    x = "Montant Total (FCFA)",
    y = "Fréquence"
  ) +
  scale_x_continuous(labels = comma) +
  theme_custom

ggsave("outputs/graphiques/01_histogramme_montants.png", p1, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 2. COMPARAISONS PAR CATÉGORIES
# ============================================================================

cat("2. Graphique en barres par produit...\n")

# Ventes par produit
stats_produit <- ventes %>%
  group_by(produit) %>%
  summarise(montant_total = sum(montant_total)) %>%
  arrange(desc(montant_total))

p2 <- ggplot(stats_produit, aes(x = reorder(produit, montant_total), 
                                  y = montant_total, fill = produit)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = paste0(round(montant_total/1000000, 1), "M")), 
            hjust = -0.1, size = 4) +
  coord_flip() +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0, 0.15))) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Montant Total des Ventes par Produit",
    x = "",
    y = "Montant Total (FCFA)"
  ) +
  theme_custom

ggsave("outputs/graphiques/02_ventes_par_produit.png", p2, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 3. BOÎTES À MOUSTACHES (BOXPLOTS)
# ============================================================================

cat("3. Boxplots par région...\n")

p3 <- ggplot(ventes, aes(x = region, y = montant_total, fill = region)) +
  geom_boxplot(alpha = 0.7, show.legend = FALSE) +
  geom_jitter(alpha = 0.3, width = 0.2, size = 1) +
  scale_y_continuous(labels = comma) +
  scale_fill_brewer(palette = "Pastel1") +
  labs(
    title = "Distribution des Montants par Région",
    subtitle = "Points = observations individuelles",
    x = "Région",
    y = "Montant Total (FCFA)"
  ) +
  theme_custom

ggsave("outputs/graphiques/03_boxplot_regions.png", p3, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 4. SÉRIES TEMPORELLES
# ============================================================================

cat("4. Évolution temporelle des ventes...\n")

# Agrégation quotidienne
ventes_quotidiennes <- ventes %>%
  group_by(date) %>%
  summarise(montant_total = sum(montant_total))

p4 <- ggplot(ventes_quotidiennes, aes(x = date, y = montant_total)) +
  geom_line(color = "#2c3e50", size = 0.8) +
  geom_smooth(method = "loess", color = "#e74c3c", se = TRUE, alpha = 0.2) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Évolution des Ventes au Fil du Temps",
    subtitle = "Courbe rouge = tendance lissée",
    x = "Date",
    y = "Montant Total Quotidien (FCFA)"
  ) +
  theme_custom +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/graphiques/04_evolution_temporelle.png", p4, 
       width = 12, height = 6, dpi = 300)

# ============================================================================
# 5. NUAGE DE POINTS (SCATTER PLOT)
# ============================================================================

cat("5. Corrélation quantité vs prix...\n")

p5 <- ggplot(ventes, aes(x = quantite, y = prix_unitaire, color = produit)) +
  geom_point(alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", se = TRUE, color = "black", linetype = "dashed") +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Relation entre Quantité et Prix Unitaire",
    subtitle = "Par catégorie de produit",
    x = "Quantité Vendue",
    y = "Prix Unitaire (FCFA)",
    color = "Produit"
  ) +
  theme_custom

ggsave("outputs/graphiques/05_scatter_quantite_prix.png", p5, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 6. GRAPHIQUES MULTIPLES (FACETTES)
# ============================================================================

cat("6. Distributions par produit (facettes)...\n")

p6 <- ggplot(ventes, aes(x = montant_total, fill = produit)) +
  geom_histogram(bins = 20, show.legend = FALSE) +
  facet_wrap(~produit, scales = "free_y", ncol = 2) +
  scale_x_continuous(labels = comma) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Distribution des Montants par Type de Produit",
    x = "Montant Total (FCFA)",
    y = "Fréquence"
  ) +
  theme_custom

ggsave("outputs/graphiques/06_facettes_produits.png", p6, 
       width = 12, height = 8, dpi = 300)

# ============================================================================
# 7. HEATMAP (CARTE DE CHALEUR)
# ============================================================================

cat("7. Heatmap produit vs région...\n")

# Préparation des données pour heatmap
heatmap_data <- ventes %>%
  group_by(produit, region) %>%
  summarise(montant_total = sum(montant_total), .groups = "drop")

p7 <- ggplot(heatmap_data, aes(x = region, y = produit, fill = montant_total)) +
  geom_tile(color = "white", size = 1) +
  geom_text(aes(label = paste0(round(montant_total/1000), "K")), 
            color = "white", fontface = "bold") +
  scale_fill_gradient(low = "#3498db", high = "#e74c3c", labels = comma) +
  labs(
    title = "Carte de Chaleur: Ventes par Produit et Région",
    x = "Région",
    y = "Produit",
    fill = "Montant Total\n(FCFA)"
  ) +
  theme_custom +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 0)
  )

ggsave("outputs/graphiques/07_heatmap_produit_region.png", p7, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 8. GRAPHIQUE EN CAMEMBERT (PIE CHART)
# ============================================================================

cat("8. Répartition par mode de paiement...\n")

# Calcul des pourcentages
paiement_stats <- ventes %>%
  group_by(mode_paiement) %>%
  summarise(
    count = n(),
    pourcentage = n() / nrow(ventes) * 100
  ) %>%
  arrange(desc(count)) %>%
  mutate(
    pos = cumsum(pourcentage) - pourcentage/2,
    label = paste0(mode_paiement, "\n", round(pourcentage, 1), "%")
  )

p8 <- ggplot(paiement_stats, aes(x = "", y = pourcentage, fill = mode_paiement)) +
  geom_col(width = 1, color = "white", size = 2) +
  geom_text(aes(y = pos, label = label), size = 5, fontface = "bold") +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Pastel1") +
  labs(
    title = "Répartition des Modes de Paiement",
    fill = "Mode de Paiement"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

ggsave("outputs/graphiques/08_pie_paiement.png", p8, 
       width = 8, height = 8, dpi = 300)

# ============================================================================
# 9. GRAPHIQUE DE DENSITÉ
# ============================================================================

cat("9. Courbes de densité par région...\n")

p9 <- ggplot(ventes, aes(x = montant_total, fill = region)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(labels = comma, limits = c(0, 300000)) +
  scale_fill_brewer(palette = "Set1") +
  labs(
    title = "Distribution des Montants par Région (Courbes de Densité)",
    x = "Montant Total (FCFA)",
    y = "Densité",
    fill = "Région"
  ) +
  theme_custom

ggsave("outputs/graphiques/09_densite_regions.png", p9, 
       width = 10, height = 6, dpi = 300)

# ============================================================================
# 10. GRAPHIQUE COMBINÉ (DASHBOARD)
# ============================================================================

cat("10. Dashboard récapitulatif...\n")

# Graphique 1: Ventes mensuelles
g1 <- ventes %>%
  group_by(mois) %>%
  summarise(total = sum(montant_total)) %>%
  ggplot(aes(x = mois, y = total)) +
  geom_col(fill = "#3498db") +
  scale_y_continuous(labels = comma) +
  labs(title = "Ventes Mensuelles", x = "", y = "Montant (FCFA)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))

# Graphique 2: Top produits
g2 <- stats_produit %>%
  ggplot(aes(x = reorder(produit, montant_total), y = montant_total)) +
  geom_col(fill = "#e74c3c") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top Produits", x = "", y = "Montant (FCFA)") +
  theme_minimal()

# Graphique 3: Régions
g3 <- ventes %>%
  group_by(region) %>%
  summarise(total = sum(montant_total)) %>%
  ggplot(aes(x = reorder(region, total), y = total)) +
  geom_col(fill = "#2ecc71") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Ventes par Région", x = "", y = "Montant (FCFA)") +
  theme_minimal()

# Graphique 4: Modes de paiement
g4 <- ventes %>%
  count(mode_paiement) %>%
  ggplot(aes(x = reorder(mode_paiement, n), y = n)) +
  geom_col(fill = "#f39c12") +
  coord_flip() +
  labs(title = "Modes de Paiement", x = "", y = "Nombre") +
  theme_minimal()

# Combiner les graphiques
dashboard <- grid.arrange(g1, g2, g3, g4, ncol = 2, 
                          top = "DASHBOARD DES VENTES 2024")

ggsave("outputs/graphiques/10_dashboard.png", dashboard, 
       width = 14, height = 10, dpi = 300)

cat("\n=== Toutes les visualisations ont été générées avec succès! ===\n")
cat("Les fichiers PNG sont disponibles dans: outputs/graphiques/\n\n")

# Afficher la liste des graphiques générés
cat("Graphiques générés:\n")
cat("  1. Histogramme de distribution\n")
cat("  2. Ventes par produit\n")
cat("  3. Boxplots par région\n")
cat("  4. Évolution temporelle\n")
cat("  5. Corrélation quantité-prix\n")
cat("  6. Facettes par produit\n")
cat("  7. Heatmap produit-région\n")
cat("  8. Camembert des paiements\n")
cat("  9. Courbes de densité\n")
cat(" 10. Dashboard récapitulatif\n")
