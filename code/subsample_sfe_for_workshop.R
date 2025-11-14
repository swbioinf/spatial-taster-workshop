library(tidyverse)
library(Voyager)
library(alabaster.sfe)
library(patchwork)
library(DT)


## Paths
spe_01_loaded_file      <- file.path("data/GSE234713_CosMx_IBD_sfe_01_loaded_w2/")
spe_01_mini_file        <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_01_loaded/")

sfe <- readObject(spe_01_loaded_file)

# Replace cell_ID-like names with cell 
# Cell ID is not unique across samples
colnames(sfe) <- sfe$cell

# first 4 fovs of 6 samples.
sfe <- sfe[,sfe$group %in% c('HC','CD')]
sfe <- sfe[,sfe$fov   <= 4]
sfe$group <- droplevels(sfe$group)
sfe$tissue_sample <- droplevels(sfe$tissue_sample)

saveObject(sfe, spe_01_mini_file )
