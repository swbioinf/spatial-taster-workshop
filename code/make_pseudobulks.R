library(tidyverse)
library(Voyager)
library(alabaster.sfe)
library(patchwork)
library(DT)
library(scuttle)
library(BiocParallel)



spe_02_banksy_niches_file <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_02_banksy_niches/")


spe_pseudobulk_by_celltype_file           <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_celltype.RDS")
spe_pseudobulk_by_niche_file              <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_niche.RDS")
spe_pseudobulk_by_celltype_in_niche_file  <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_pseudobulk_by_celltype_in_niche.RDS")


################################################################################
# Load it
sfe <- readObject(spe_02_banksy_niches_file)
sfe <- sfe[,sfe$group %in% c('HC','CD')]

################################################################################
# Save celltype level pseudobulk

sfe$pdb_sample <- paste0(sfe$tissue_sample, '_', sfe$celltype_subset)
# Use 8 cores, requires BiocParallel, 
se.pdb <- aggregateAcrossCells(sfe, ids=sfe$pdb_sample,
                               BPPARAM = MulticoreParam(workers=4)  )

# To save it
saveRDS(se.pdb, spe_pseudobulk_by_celltype_file)


################################################################################
# save niche level pseudobulk


sfe$pdb_sample <- paste0(sfe$tissue_sample, '_', sfe$niche)

se.pdb <- aggregateAcrossCells(sfe, ids=sfe$pdb_sample,
                               BPPARAM = MulticoreParam(workers=4)  )

# To save it
saveRDS(se.pdb, spe_pseudobulk_by_niche_file)


################################################################################
# save niche level pseudobulk

sfe$pdb_sample <- paste0(sfe$tissue_sample, '_', sfe$niche,"_", sfe$celltype_subset)

se.pdb <- aggregateAcrossCells(sfe, ids=sfe$pdb_sample,
                               BPPARAM = MulticoreParam(workers=4)  )

# To save it
saveRDS(se.pdb, spe_pseudobulk_by_celltype_in_niche_file)






