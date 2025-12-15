# Replication and Extension of Moser & Voena (2012)

This repository contains a minimal dataset and Stata do-file to replicate key results from "Compulsory Licensing: Evidence from the Trading with the Enemy Act" (Moser & Voena 2012). 
Specifically, this replication reproduces Columns (1)–(4) of Table 2 (DiD specifications) and the entirety of Table 3 (ITT specifications). In addition, the repository includes an extension that examines heterogeneity in the effects of compulsory licensing across USPTO chemical sub-industries.

## Contents
### Replication
- `replication.do` — Runs the replication.
- `moservoena_replication.csv` — Minimal dataset containing only the variables required to estimate Tables 2 and 3.
- `replication.log` — Example output log (optional reference).
- 'Tables.pdf' - LaTeX version of all tables (replication and extension)

### Extension
- `extension.do` - Runs the extension analysis.
- `extension_dataset.csv` - Minimal dataset containing only the variables required for the extension analysis.
- `extension_results.csv` - Output from the extension regressions.
- `extension.log` - Example output log (optional reference)

## How to Run
1. Download or clone this repository to your computer.
2. Open `replication.do` in Stata.
3. **Edit only the global ROOT line** at the top of the file: global ROOT "path/to/this/folder"
4. Run the entire do-file.

No other edits or cleaning steps are required.
The script loads the minimal dataset, reconstructs the treated × post indicator (`did`), and estimates the regressions for Tables 2 and 3 exactly as in the original paper.

## Notes
- The dataset is already restricted to the variables used in the replication.
- The minimal dataset (`moservoena_replication.csv`) is derived from the original `chem_patents_maindataset.dta` provided for the assignment.
- All replication regressions include subclass and grant-year fixed effects, with standard errors clustered at the subclass level, following Moser & Voena (2012).
- The extension analysis uses a separate minimal dataset (`extension_dataset.csv`), also derived from the original `chem_patents_maindataset.dta`, and estimates heterogeneous treatment effects across USPTO chemical sub-industries using difference-in-differences specifications.


