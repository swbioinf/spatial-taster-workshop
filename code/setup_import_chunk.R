
# for building htmls to share, take out of final version

```{r results='hide', echo=FALSE}
#Ignore this chunk, it is only to run the setup Rmarkdown when knitting 
building_htmls <- ! interactive()
if (building_htmls ) {
  source(knitr::purl("00_Setup.Rmd", quiet=TRUE))
}
```
