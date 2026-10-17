# ICC-discrimination-overlap
A Probabilistic Interpretation of the Intraclass Correlation Coefficient via
Discrimination and Overlap

Author: Josep L. Carrasco
Target journal: Statistics in Medicine

OVERVIEW
--------
This repository contains R code for reproducing the numerical results of the
two illustrative examples in the manuscript. The article investigates the
relationships between the intraclass correlation coefficient (ICC), expected
pairwise discrimination (AUC), expected overlap (OVL), and switchability.

FILES
-----
example_SIM.R   R script for the two numerical examples.
README.txt      This file.

REQUIREMENTS
------------
- R
- R package 'cccrm', which includes the example dataset 'bpres'

The script uses only base R functions in addition to 'cccrm'. It does not
require 'dplyr' if the data-filtering line uses base R as described below.

RUNNING THE EXAMPLES
--------------------
1. Install the 'cccrm' package if necessary:
     install.packages("cccrm")
2. Open example_SIM.R in R or RStudio.
3. Ensure that the selection of method 1 uses base R:
     newdat <- subset(bpres, METODE == 1)
   (This replaces 'dplyr::filter(bpres, METODE == 1)' in earlier versions.)
4. Run the script from beginning to end.

EXAMPLE 1: RELIABILITY
----------------------
The script selects method 1 from 'bpres', estimates variance components and
the ICC using ccc_vc(), and computes the signal-to-noise ratio (rSNR), expected
AUC, and expected OVL. Confidence limits for these quantities are obtained
by transforming the ICC confidence limits; the order is reversed for OVL
because it decreases as rSNR increases.

EXAMPLE 2: CONCORDANCE
----------------------
The script analyzes the method-comparison data with ccc_vc(), calculates an
ICC threshold using the illustrative squared tolerance D2 = 100 and target
coverage probability p = 0.90, and calls Ztest() with that threshold.

SCOPE AND REPRODUCIBILITY
-------------------------
This script reproduces the numerical examples, not the manuscript figure
(Plot1.pdf) or the mathematical derivations. The derivations are supplied
separately as Supporting Information. To record R and package versions,
uncomment sessionInfo() at the end of the script.

When citing or reusing this code, please refer to the associated article.

