*===============================================================================
* Title: extension.do
* Author: Suhana Alam
* Extension: testing for heterogeneity by sub-industry
* Paper: Compulsory Licensing: Evidence from the Trading with the Enemy Act (2012)
*===============================================================================

cap log close _all
clear
set more off

*************** EDIT ONLY THIS LINE :) ********************
global ROOT "/Users/suhanaalam/Documents/ECO726/Project" 
***********************************************************

cd "$ROOT"

log using "extension.log", name (SA) replace

import delimited "extension_dataset.csv", clear // using new extension csv

* getting an overview of the data
summarize
describe

* creating the post-policy indicator/dummy variable
gen post1919 = (grntyr>=1919) // checks if year is 1919 (pre treatment) or later
label var post1919 "Post-1919 indicator"

tab post1919

* creating DiD interaction variable
gen did = treat * post1919 // equals 1 only for treated subclasses after 1919
label var did "Treated x Post-1919 interaction" // measures policy's causal effect

tab treat post1919, summarize(did) // check to verify pattern

* setting up the panel to match table 2
xtset class_id grntyr // each subclass over yrs

*=========================== BEGINNING REGRESSIONS ============================*

* checking how many sub-industries there are
tab main

* running the DiD separately for each sub-industry (main)
statsby _b _se, by(main) clear: ///   // statsby runs DiD for each main class
    xtreg count_usa did count_for i.grntyr, fe vce(cluster class_id)

* cleaning statsby output - only keeping relevant variables
keep main _b_did _se_did

* renaming variables
rename _b_did did_effect
rename _se_did did_se

* adding labels to variables
label var main "Sub-industry (main chemical class)"
label var did_effect "DiD effect"
label var did_se "Standard Error"

* sorting observations by sub-industry
sort main

* displaying clean heterogeneity effects
list

* exporting clean table results/data
export delimited using "extension_results.csv", replace

*============================= WRITING THE TABLES =============================*

* storing table in estpost to add to log file
estpost tabstat did_effect did_se, by(main) nototal

* writing table to log file
esttab ., ///
unstack ///
cell((did_effect(fmt(%9.4f)) did_se(fmt(%9.4f)))) ///
nodepvars nobaselevels alignment(r) ///
title("Heterogeneous DiD Effects by Sub-Industry") ///
collabels("DiD Effect" "Std. Error") ///
varlabels(main "Sub-industry") ///
nonotes addnotes("Notes: Each row represents a separate DiD regression estimated within a chemical sub-industry (main class). The dependent variable is U.S. patents per subclass-year. All specifications include subclass and grant-year fixed effects, with standard errors clustered at the subclass level.")

* writing table to LaTex
esttab using "Extension_Table.tex", ///
replace ///
booktabs ///
cell((did_effect(fmt(%9.4f)) did_se(fmt(%9.4f)))) ///
collabels("DiD Effect" "Std. Error") ///
varlabels(main "Sub-industry (Main Class)") ///
nonotes ///
alignment(D{.}{.}{-1}) ///
varwidth(60) ///
title("Heterogeneous DiD Effects by Sub-Industry") ///
addnotes("Notes: Each row represents a separate DiD regression estimated within a chemical sub-industry (main class). The dependent variable is U.S. patents per subclass-year. All specifications include subclass and grant-year fixed effects, with standard errors clustered at the subclass level.")
