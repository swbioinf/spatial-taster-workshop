################################################################################
# Libraries

library(SpatialFeatureExperiment)
library(alabaster.sfe)  # Bioconductor 3.21 and above.
library(tidyverse)
library(Banksy)
library(Voyager) #plotting
library(pals)

# renv::install("pachterlab/alabaster.sfe")
#Error: package ‘SpatialFeatureExperiment’ 1.8.6 was found, but >= 1.9.3 is required by ‘alabaster.sfe’
#Error: package ‘SpatialFeatureExperiment’ 1.8.6 was found, but >= 1.9.3 is required by ‘alabaster.sfe’
# The dev repo is only up to 1.8.6 also,
# try a download of 1.12.1
#wget https://bioconductor.posit.co/packages/release/bioc/src/contrib/SpatialFeatureExperiment_1.12.1.tar.gz
#renv::install('/home/s.williams/program_downloads/SpatialFeatureExperiment')
# installed.
# renv::install("pachterlab/alabaster.sfe")
# success.
#object ‘listw2sparse’ is not exported by 'namespace:SpatialFeatureExperiment'
#renv::install("pachterlab/Voyager")

################################################################################
# Config

spe_01_loaded_file        <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_01_loaded/")
spe_02_banksy_niches_file <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_02_banksy_niches/")


#spe_banksy_res          <- file.path("data/banksy_res.RDS")
spe_banksy_res          <- file.path("data/banksy_res_mini.RDS")

# lambda 	A numeric vector in ∈[0,1]∈[0,1] specifying a spatial weighting parameter. Larger values (e.g. 0.8) incorporate more spatial neighborhood and find spatial domains, while smaller values (e.g. 0.2) perform spatial cell-typing.
# 0.2  suggested for 'celltypeing' (not using)
# 0.8for domain finding.
lamdas <- c( 0.6)

# PCs to use (50 seems like alot?) 
# ElbowPlot(se) => 20 is plenty enough
npcs <- 20

# number of nearest spatial neighbours:
k_geom <- 20 # 30?

# clustering resolutions
#resolutions <- c(0.2, 0.5, 0.8)
resolutions <- c(0.5, 0.3)

################################################################################
# 1) Process

sfe <- readObject(spe_01_loaded_file)

# TEMP subset for testing
#sfe <- sfe[,sfe$group %in% c('HC','CD')]

# try to limit to just hvgs
hvgs <- rownames(rowData(sfe))[rowData(sfe)$hvg]
sfe.hvg <- sfe[hvgs,]
sfe.hvg$tissue_sample<- droplevels(sfe.hvg$tissue_sample)


#split by sample
get_one_sample <- function(the_sample){sfe.hvg[,sfe.hvg$tissue_sample == the_sample]}
sfe.list <- lapply(FUN=get_one_sample, X=levels(sfe.hvg$tissue_sample))

# Get the underlaying banky computation
sfe.list <- lapply(sfe.list, computeBanksy, assay_name = 'logcounts', k_geom = k_geom)
sfe.merged <- do.call(cbind, sfe.list)

rm(sfe.hvg, sfe.list)
#sfe.merged <- Banksy::runBanksyPCA(sfe.merged, lambda = lamdas, npcs = npcs, seed=12)
sfe.merged <- Banksy::runBanksyPCA(sfe.merged, lambda = lamdas, npcs = npcs, group='tissue_sample', seed=12)
#sfe.merged <- Banksy::runBanksyPCA(sfe.merged, lambda = lamdas, npcs = npcs, group='fov_name', seed=12)
sfe.merged <- Banksy::clusterBanksy(sfe.merged, lambda = lamdas, npcs = npcs, resolution = resolutions, seed=12)


# Save interium object, in case the order gets messed up again.
print("save sfemerged")
saveRDS(colData(sfe.merged),  spe_banksy_res )
print("merged saved")


################################################################################
# 2) Store it.
# Cell_ID is not unique
# cell is unique

# sfe <- readObject(spe_01_loaded_file)
niches_table <- readRDS(spe_banksy_res     )

niche_lookup <- setNames(niches_table$clust_M0_lam0.6_k50_res0.5, nm=as.character( niches_table$cell ))
niche_lookup2 <- setNames(niches_table$clust_M0_lam0.6_k50_res0.3, nm=as.character( niches_table$cell ))


sfe$clust_M0_lam0.6_k50_res0.5 <- niche_lookup[as.character(sfe$cell)]
sfe$clust_M0_lam0.6_k50_res0.3 <- niche_lookup2[as.character(sfe$cell)]

sfe$niche <- factor(paste0('n', as.character(sfe$clust_M0_lam0.6_k50_res0.3)),
                     levels=paste0('n',levels(sfe$clust_M0_lam0.6_k50_res0.3)))
 
saveObject(sfe, path = spe_02_banksy_niches_file )
