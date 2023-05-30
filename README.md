# AnalyticRangeShift_Public
 Code to support Terry et al 2022 *Schrödinger’s range-shifting cat: How skewed temperature
dependence impacts persistence with climate change*
 
The key documents are `.rmd` files. 

1. `ModelSpecification.rmd`
 - Generates Appendix 3 in the supplementary material. It details the model structure and descibes the role of the subsidary functions. 
2. `SimulationRun.rmd` 
 - The top-level code that runs the simulation and key analyses.
3. `Plots.rmd` 
 - Generates the plots and does the statistics used in the main file. 
4. `QuantitativeMatchTest.rmd`
 - Includes smaller-scale simulations and calculations to conduct a brief quantitative analysis of the model and generate Appendix 4. 
 
The low-level functions are in the folder `FunctionScripts/`. These are not specifically documented, but have been simplified as much as possible.  
 
`Assemblies/` is empty, as it would otherwise be too large for github. It can be populated by running the appropriate section in `SimulationRun.rmd`. 

`AssemblyExample/` contains an example assembled community for the purposes of generating the figure. 
 
 For completeness, the Mathematica file that conducts the analytic results is also included. `Mathematica.nb`
 
 
 Please feel free to reuse as you see fit, but do cite the paper / preprint as appropriate.
 
 Any questions, contact Chris Terry (currrently christopher.terry [at] biology.ox.ac.uk) or Axel Rossberg (a.rossberg[at]qmul.ac.uk)
 
# Software Version Information
 
## R

Code was originally written and run under earlier versions, but was able to run under:

R version 4.2.2 (2022-10-31 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19045)
Matrix products: default

attached base packages:
stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
forcats_0.5.2   stringr_1.5.0   dplyr_1.0.10    purrr_0.3.5    
readr_2.1.3     tidyr_1.2.1     tibble_3.1.8    ggplot2_3.4.0  
tidyverse_1.3.2

loaded via a namespace
lubridate_1.9.0     assertthat_0.2.1    digest_0.6.30      
utf8_1.2.2          R6_2.5.1            cellranger_1.1.0   
backports_1.4.1     reprex_2.0.2        evaluate_0.18      
httr_1.4.4          pillar_1.8.1        rlang_1.0.6        
googlesheets4_1.0.1 readxl_1.4.1        rstudioapi_0.14    
jquerylib_0.1.4     rmarkdown_2.18      googledrive_2.0.0  
bit_4.0.5           munsell_0.5.0       broom_1.0.1        
compiler_4.2.2      modelr_0.1.10       xfun_0.35          
pkgconfig_2.0.3     htmltools_0.5.3     tidyselect_1.2.0   
fansi_1.0.3         crayon_1.5.2        tzdb_0.3.0         
dbplyr_2.2.1        withr_2.5.0         grid_4.2.2         
jsonlite_1.8.3      gtable_0.3.1        lifecycle_1.0.3    
DBI_1.1.3           magrittr_2.0.3      scales_1.2.1       
cli_3.4.1           stringi_1.7.8       vroom_1.6.0        
cachem_1.0.6        fs_1.5.2            xml2_1.3.3         
bslib_0.4.1         ellipsis_0.3.2      generics_0.1.3     
vctrs_0.5.1         tools_4.2.2         bit64_4.0.5        
glue_1.6.2          hms_1.1.2           parallel_4.2.2     
fastmap_1.1.0       yaml_2.3.6          timechange_0.1.1   
colorspace_2.0-3    gargle_1.2.1        rvest_1.0.3        
knitr_1.41          haven_2.5.1         sass_0.4.4

 
