print("Rendering workshop files...")
rmarkdown::render("01_Explore.Rmd",              output_dir="docs/") #catch failures earlier
rmarkdown::render("index.Rmd",                   output_dir="docs/")
rmarkdown::render("00_Setup.Rmd",                output_dir="docs/")
rmarkdown::render("02_DE_by_celltype.Rmd",       output_dir="docs/")
rmarkdown::render("03_DE_by_niche.Rmd",          output_dir="docs/")
rmarkdown::render("04_DE_by_localisation.Rmd",   output_dir="docs/")
rmarkdown::render("05_celltype_cooccurance.Rmd", output_dir="docs/")
print("Done.")