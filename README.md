# Generative Bayesian modeling to nowcast the effective reproduction number from line list data with missing symptom onset dates

[![DOI](https://zenodo.org/badge/681616817.svg)](https://zenodo.org/doi/10.5281/zenodo.8279675)

:page_facing_up: [Research paper](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1012021)

Adrian Lison (1,2), Sam Abbott (3), Jana Huisman (4), and Tanja Stadler (1,2)

(1) ETH Zurich, Department of Biosystems Science and Engineering, Zurich, Switzerland\
(2) SIB Swiss Institute of Bioinformatics, Lausanne, Switzerland\
(3) Centre for Mathematical Modelling of Infectious Diseases, London School of Hygiene and Tropical
Medicine, London, UK\
(4) Massachusetts Institute of Technology, Department of Physics, Physics of Living Systems,
Cambridge, MA, United States of America\
(*) Corresponding author: adrian.lison@bsse.ethz.ch

## Abstract
The time-varying effective reproduction number R<sub>t</sub> is a widely used indicator of transmission dynamics during infectious disease outbreaks. Timely estimates of R<sub>t</sub> can be obtained from reported cases counted by their date of symptom onset, which is generally closer to the time of infection than the date of report. Case counts by date of symptom onset are typically obtained from line list data, however these data can have missing information and are subject to right truncation. Previous methods have addressed these problems independently by first imputing missing onset dates, then adjusting truncated case counts, and finally estimating the effective reproduction number. This stepwise approach makes it difficult to propagate uncertainty and can introduce subtle biases during real-time estimation due to the continued impact of assumptions made in previous steps. In this work, we integrate imputation, truncation adjustment, and R<sub>t</sub> estimation into a single generative Bayesian model, allowing direct joint inference of case counts and R<sub>t</sub> from line list data with missing symptom onset dates. We then use this framework to compare the performance of nowcasting approaches with different stepwise and generative components on synthetic line list data for multiple outbreak scenarios and across different epidemic phases. We find that under reporting delays realistic for hospitalization data (50% of reports delayed by more than a week), intermediate smoothing, as is common practice in stepwise approaches, can bias nowcasts of case counts and R<sub>t</sub>, which is avoided in a joint generative approach due to shared regularization of all model components. On incomplete line list data, a fully generative approach enables the quantification of uncertainty due to missing onset dates without the need for an initial multiple imputation step. In a real-world comparison using hospitalization line list data from the COVID-19 pandemic in Switzerland, we observe the same qualitative differences between approaches. The generative modeling components developed in this work have been integrated and further extended in the R package [epinowcast](https://package.epinowcast.org/), providing a flexible and interpretable tool for real-time surveillance.

## Contents of this repository
This repository contains the data, code, and results from the evaluation of the different stepwise and generative nowcasting methods.

#### Data

Synthetic data were simulated using the code in [code/simulations](code/simulations) and are stored in [data/simulated](data/simulated).

Real-world data of COVID-19 hospitalizations in Switzerland cannot be publicly shared but are available under terms of data protection upon request from the Swiss Federal Office of Public Health (FOPH).

#### Code

The various nowcasting models used by the different approaches compared in this study are implemented as *stan* models in [code/models](code/models). This includes the [fully generative model](code/models/impute_adjust_renewal.stan) which can be directly fitted to line list data with missing symptom onset dates. Various helper functions for simulation, model specification, model fitting, validation, and plotting are found in [code/utils](code/utils).

#### Fitting of nowcasting models
To rerun the analyses, the nowcasting models can be fitted to the synthetic data by running
[code/nowcast_synthetic.Rmd](code/nowcast_synthetic.Rmd). 
To fit the nowcasting models to the real-world data (requires data provided by FOPH), run the code in [code/nowcast_switzerland_hosp_symp.Rmd](code/nowcast_switzerland_hosp_symp.Rmd).
To run the sensitivity analysis for incubation period misspecification, run
[code/nowcast_sensitivity_incubation.Rmd](code/nowcast_sensitivity_incubation.Rmd). 

Note that rerunning the model fitting involves considerable computation and may require the use of an HPC cluster.

#### Evaluation of results
The nowcasting results from the different approaches are stored in subfolders in [results](results). Results are stored in compressed form as *RDS* files.

Approaches are evaluated on the synthetic data in [code/validation_synthetic.Rmd](code/validation_synthetic.Rmd) and on the real-world data in [code/validation_switzerland_hosp_symp.Rmd](code/validation_switzerland_hosp_symp.Rmd). The sensitivity analysis is evaluated in [code/validation_sensitivity.Rmd](code/validation_sensitivity.Rmd).

Figures from the manuscript are stored in [figures/paper](figures/paper).

## Related projects

The [generative-nowcasting](https://github.com/adrian-lison/generative-nowcasting) repository contains the same models but with further features not related to this study.

The generative modeling components described in this study have also been integrated into the R package [epinowcast](https://package.epinowcast.org/).
