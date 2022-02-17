*** do 0000master
*** Analsysis for Greek Life
 ** 1/7/2016
 ** 1/26/2016 -- Delete 1 case (unitid=227368; The University of Texas-Pan American)
 ** 2/03/2016 -- Delete SAT from the selectivity controls. For results with SAT scores in the control, see 160126.
 ** 3/14/2016 -- Using separate measures for town and urban schools, see 160314.
 ** 20 MI runs

do 1000cln.do
    // do 1002merge
    ** unitid instnm

do 2000Impute

do 2100Table01 
    *** Table 1 presents descriptive analyses
    *** Appendix A: Descriptive Statistics Used Un-imputed data

do 2120Table02 
    *** Table 2 presents correlations and mean comparisons by Greek life measures

do 2140Table0345 // using perfrat as the key X
    *** Table 03: non-Pell graduation rates
    *** Table 04: Pell graduation rates
    *** Table 05: Gap = (Non-Pell rates - Pell rates)

// do 3140S1Table0345
// do 3150S2Table0345

do 2150Table06

do 2180Figure01
    *** Figure 1

exit


