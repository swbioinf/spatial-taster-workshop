print("Rendering workshop files...")
rmarkdown::render("01_Explore.Rmd",              output_dir="public/") #catch failures earlier
rmarkdown::render("index.Rmd",                   output_dir="public/")
rmarkdown::render("00_Setup.Rmd",                output_dir="public/")
rmarkdown::render("02_DE_by_celltype.Rmd",       output_dir="public/")
rmarkdown::render("03_DE_by_niche.Rmd",          output_dir="public/")
rmarkdown::render("04_DE_by_localisation.Rmd",   output_dir="public/")
rmarkdown::render("05_celltype_cooccurance.Rmd", output_dir="public/")
print("Done.")