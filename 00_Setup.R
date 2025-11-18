## -----------------------------------------------------------------------------
library(tidyverse)
library(patchwork)                 # + / notation for side-by-side ggplots
library(SpatialFeatureExperiment)  # The data object we will work with - inherits from single cell experiment
library(Voyager)                   # Package with alot of useful plotting and spatial methods.
library(alabaster.sfe)             # An efficient way to save SFE objects to disk. "Builds upon the existing ArtifactDB project, expending alabaster.spatial for language agnostic on disk serialization of SpatialFeatureExperiment. "
library(DT)         # For pretty html rendering of big tables.
library(scuttle)    # Usefule SCE functions liek 'aggregateAcrossCells'
library(scater)     # Usfele SCE functions like 'plotExpression'
library(limma)      # for differential expression
library(edgeR)      # for differential expression
library(spicyR)     # For testing celltype coocurance


## -----------------------------------------------------------------------------

spe_02_banksy_niches_file <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_02_banksy_niches")

spe_pseudobulk_by_celltype_file           <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_celltype.RDS")
spe_pseudobulk_by_niche_file              <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_niche.RDS")
spe_pseudobulk_by_celltype_in_niche_file  <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_celltype_in_niche.RDS")



## -----------------------------------------------------------------------------
# Load a spatialFeatureExperiment object (a type of SingleCellExperimet)
sfe <- readObject(spe_02_banksy_niches_file)

# And subset to one sample, for later plotting.
sfe.sample.HC <- sfe[,sfe$tissue_sample == 'HC_b'] 
sfe.sample.CD <- sfe[,sfe$tissue_sample == 'CD_a']

