library(HDF5Array)
library(SpatialFeatureExperiment)
library(alabaster.sfe)
library(alabaster.bumpy)
library(tidyverse)
library(scater)
library(patchwork)
library(CatsCradle)

options(future.globals.maxSize= 16*1024^3)

## Paths
spe_01_loaded_file        <- file.path("data/GSE234713_CosMx_IBD_sfe_mini_01_loaded_w2/")
niche_membership_file     <- file.path("data/CatsCradleNicheMembership.RDS")
neighbour_matrix_file     <- file.path("data/CatsCradleNeighbourMatrix.RDS")

# Load.
sfe <- readObject(spe_01_loaded_file )


#Following : https://www.bioconductor.org/packages/release/bioc/vignettes/CatsCradle/inst/doc/CatsCradleSpatial.html
neighbour_radius = 3 # how many neighbour jumps to consider

# Clusters and positions.
clusters <- colData(sfe)$cluster_code
#clusters <- sfe$celltype_subset # perhaps too celltypes for clustering steps to work?
names(clusters) <- colData(sfe)$cell_ID
centroids = spatialCoords(sfe)
stopifnot(all(rownames(centroids) == names(clusters)))
rm(sfe)


# get neibhbours
delaunayNeighbours = computeNeighboursDelaunay(centroids)
print("Got neighbours")

# Jump a to neighbours of neighbours, and pool the lists together as 'neighbour'
extendedNeighboursList = getExtendedNBHDs(delaunayNeighbours, neighbour_radius)
print("Extended neighbours")
extendedNeighbours     = collapseExtendedNBHDs(extendedNeighboursList, neighbour_radius)
print("Collapsed extended neighbours")


# Count the celltypes of those neighbours.
NBHDByCTMatrixExtended = computeNBHDByCTMatrix(extendedNeighbours, clusters)
print("Made cell type neighbour matrix")
saveRDS(NBHDByCTMatrixExtended, neighbour_matrix_file)
rm(extendedNeighboursList)
rm(extendedNeighbours)

# At this point, this vigenett builds a seurat object to use that clustering

#NBHDByCTSeurat = computeNBHDVsCTObject(NBHDByCTMatrixExtended, resolution= 0.05 , verbose=FALSE) # tried lower res
# This step didn't like having only 5 celltypes
NBHDByCTSeurat = computeNBHDVsCTObject(NBHDByCTMatrixExtended, verbose=F)
print("Clustered neighbour matrix")




# Pull out niches, and prefix with n for prettiness.
niche_membership <- NBHDByCTSeurat$neighbourhood_clusters
niche_membership_code <- factor(paste0("n", as.character(niche_membership)), 
                                levels=paste0("n",levels(niche_membership)))
names(niche_membership_code)<- names(niche_membership)

print('saving ')
saveRDS(niche_membership_code, niche_membership_file )





