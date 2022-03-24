# insulin-signaling-t2d

_Dynamic notebooks for QSP usage case: Insulin Signaling in Type 2 Diabetes_

[![Heta project](https://img.shields.io/badge/%CD%B1-Heta_project-blue)](https://hetalang.github.io/)
[![GitHub license](https://img.shields.io/github/license/insysbio/insulin-signaling-t2d.svg)](https://github.com/insysbio/insulin-signaling-t2d/blob/master/LICENSE)

## Abstract

__Background__: Currently the mathematical modeling is applied for drug discovery and development. The report preparation and presentation are time-demanding processes. Using the formats of dynamic reports like R Markdown, Jupiter or similar ones is a good decision because of the following: 

1. Reducing time for report writing and update; 
2. Easy results share, review, and reproduction; 
3. Usage of interactivity capabilities, testing of “what-if” scenarios.


__Objectives__: Application and testing several software configurations for the development and analysis of dynamic reports. Testing the integration of the Heta-based platform into the presented environments. Comparison of the capabilities and technical issues for different configurations.


__Methods__: We tested several configurations for dynamic reporting: 

- Julia environment + HetaSimulator.jl + Jupiter notebooks.
- Julia environment + HetaSimulator.jl + Pluto.jl;
- R environment + heta-compiler + mrgsolve + R Markdown;
- R environment + heta-compiler + mrgsolve + Jupiter notebook; 

__Results__: The dynamic report was created for each model and configuration. It included model code loading, single and Monte-Carlo simulations, and visualization plots. All settings and configuration files are shared on GitHub.


__Discussion__: The following features of modeling infrastructure is very important for successful and effective dynamic reports: 

1. representation of QSP model in human-readable format or another unified format,
2. loading of a model from programming environment, 
3. Simulation engine available from programming environments, like R or Julia. If you use a standardized modeling environment like the Heta-based modeling platform and heta-compiler tool the development of a dynamic report requires no more than one hour.

## Project content

- __/julia__ : files to run in plain julia, scenarios tables for all notebooks
- __/julia-jupiter__ : The Jupiter-based notebook, can be run with `using IJulia; notebook(dir=".")` in Julia
- __/julia-pluto__ : The Pluto-based notebook, can be run with `using Pluto; Pluto.run()` in Julia
- __/r-markdown__ : RMarkdown notebook, can be run from RStudio using `knit` mechanism
- __/outputs__ : the result of the notebooks execution, not runnable files
- __/src__ : source files of QSP model, Heta-based format + downloaded SBML
- _platform.json_ : Heta platform's declaration file
- _README.md_ : this file

## Original model

The model and data were reconstructed from the article:

> Brannmark C, Nyman E, Fagerholm S, Bergenholm L, Ekstrand EM, Cedersund G, Stralfors P. Insulin Signaling in Type 2 Diabetes: Experimental and modeling analysis reveal mechanisms of insulin resistance in human adipocytes. Journal of biological chemistry. 2013 288(14):9867–9880. DOI: 10.1074/jbc.M112.432062

The SBML version was downloaded from BioModels <https://www.ebi.ac.uk/biomodels/BIOMD0000000448>

## Contributors

- @metelkin

The model and data in the study were reproduced from the published study. The authors of the original study are: Brannmark C, Nyman E, Fagerholm S, Bergenholm L, Ekstrand EM, Cedersund G, Stralfors P.
