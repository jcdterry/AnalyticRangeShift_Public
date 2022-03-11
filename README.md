# AnalyticRangeShift_Public
 Code to support Terry et al 2022 Range shift paper (title TBC)


There  key documents are `.rmd` files. 

1. `ModelSpecification.rmd`
 - Generates Appendix 3 in the supplementary material. It details the model structure. 
2. `SimulationRun.rmd` 
 - The top-level code that runs the simulation and key analyses.
3. `Plots.rmd` 
 - Generates the plots and does the statistics used in the main file. 
4. `QuantitativeMatchTest.rmd`
 - Includes smalle-scale simulations and calculations to conduct a brief quantitative analysis of the model and generate Appendix 4. 
 
The low-level functions are in the folder `FunctionScripts/`. These are not specifically documented, but have been simplified as much as possible.  
 
`Assemblies/` is empty, as it would otherwise be too large for github. It can be populated by running the appropriate section in `SimulationRun.rmd`. 

`AssemblyExample/` contains an example assembled community for the purposes of generating the figure. 
 
 For completeness, the Mathematica file that conducts the analytic results is also included. `Mathematica.nb`
 
 
 Please feel free to reuse as you see fit, but do cite the paper / preprint as appropriate.
 
 Any questions, contact Chris Terry (currrently c.terry [at] qmul.ac.uk)
 
 
