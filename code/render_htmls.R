print("Rendering workshop files...")

# Pandoc needs HOME set. 
# This doesn't seem to be set when running as workbench job. (But it is as a 'background' job)
# So set upt explicitly to my home directory here (not ~).
Sys.setenv(HOME="/home/s.williams")


rmarkdown::render("01_Explore.Rmd",              output_dir="docs/") #catch failures earlier
rmarkdown::render("index.Rmd",                   output_dir="docs/")
rmarkdown::render("00_Setup.Rmd",                output_dir="docs/")
rmarkdown::render("02_DE_by_celltype.Rmd",       output_dir="docs/")
rmarkdown::render("03_DE_by_niche.Rmd",          output_dir="docs/")
rmarkdown::render("04_DE_by_localisation.Rmd",   output_dir="docs/")
rmarkdown::render("05_celltype_cooccurance.Rmd", output_dir="docs/")

print("Done.")
