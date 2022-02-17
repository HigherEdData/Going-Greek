*** do 1000cln
 ** v02: Merge data with addvar4
 ** v03: Merge data with Greek_extra
 ** v04: Begin Draft03, 1) reverse code in gap and ratio outcomes for graduation rates, 2) ln of endowments
 ** v05: Supplemenary analysis for [Draft06_160203]
 ** v07: Newe main analysis for [Draft07_160314]
 
global path "FirstGen/07_160314"
global log "1000cln"
global dsold1 "PIF2"
global dsold2 "addvar4"
global dsold3 "Greek_extra"
global dsold4 "Greek_extra2"
global dsold5 "endowment"
global dsnew "1000cln"
global tag "$path" 
global graf ".emf"

capture log close
clear all
version 11
set matsize 800
set mem 400000k
set linesize 140
set more off
log using "$log", t replace

*** Template

    do 1001template

*** Check and merge data

    do 1002merge

*** Note variables
 ** Preparation: 1) Value lables, 2) Variables to save notes, 3) Local for new variables 

    do 1003notevars

*** Document the sample restrictions

    do 1004sample
    qui tab ccbasic, m
    local N = r(N)
    di `N'

*** Dependent Variable: Pell vs. non-Pell graduation rates come from two different sources
 ** Document the construction of the dependent variable from 2 datasources

    do 1010Ys

*** Key Xs

    do 1020KeyXs

/*** Selection issues

    foreach var of varlist median_hh_inc poverty_rate unemp_rate {
        clonevar X`var' = `var'
        sum X`var' if `var'<=0
        recode X`var' -99=.
    }
    sum Xmedian_hh_inc Xpoverty_rate Xunemp_rate 
    codebook Xmedian_hh_inc Xpoverty_rate Xunemp_rate, compact
**/

*** Important Controls

 ** Private vs. public schools

    do 1031private

 ** Average endowment from 07-12

    do 1032endowment
    di "$addvars"

 ** Region & Urbanicity

    do 1033region

 ** Percent of graduating majors in STEM in 12-13 academic year
 
    do 1034STEM
    di "$addvars"

 ** Minority Instiution
 
    do 1035mininst

 ** % Women in 2013
 ** % Black and Hispanic in 2013

    do 1036stucomp

 ** Degree of selectivitiy -- To be revised
 
    do 1037select

 ** Average SAT scores -- To be revised

    do 1039SAT

 ** Acceptance % 13, 07-11, & 07-12 
 
    do 1041accept

 ** Percent first-gen on campus

    do 1043percfirstgen

 ** Institution size 2013, 07-12, & 07-13

    do 1045schsize

 ** % Pell on campus 12-13, 07-12, & 07-13

    do 1047percpell

 ** Cost
  * Out-of-state Tuition & fees, 13-14, in $K
  * In-state Tuition & fees, 13-14, in $K
  * Averaged net price for low income students (0-30K) for 08-13 in K

    do 1049cost

*** Class inequality for selection 

    local oldvar "median_hh_inc"
    local newvar "mhhincK"
    local varlab "Median household income in $K"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/1000 if `oldvar'~=-99
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Median household income of the school in $1000. | `tag'

    sum median_hh_inc mhhincK
    sum median_hh_inc mhhincK if pellgap<.
    
    local oldvar "median_hh_inc"
    local newvar "stdmedincome"
    local varlab "Standardized score for median household income"
    global addvars "$addvars `newvar'"
    clonevar X`oldvar' = `oldvar'
    recode X`oldvar' -99=.
    egen `newvar' = std(X`oldvar'), mean(0) std(1)
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Standardized score for median household income. | `tag'

    sum median_hh_inc Xmedian_hh_inc stdmedincome
    sum median_hh_inc Xmedian_hh_inc stdmedincome if pellgap<.

    // Use md_faminc // 

    local oldvar "md_faminc"
    local newvar "mfincK"
    local varlab "Median family income in $K"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/1000 if `oldvar'~=-99
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Median household income of the school in $1000. | `tag'

    sum md_faminc mfincK
    sum md_faminc mfincK if pellgap<.

    local oldvar "md_faminc"
    local newvar "stdmfincK"
    local varlab "Standardized score for median family income"
    global addvars "$addvars `newvar'"
    clonevar X`oldvar' = `oldvar'
    recode X`oldvar' -99=.
    egen `newvar' = std(X`oldvar'), mean(0) std(1)
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Standardized score for median family income. | `tag'

    sum md_faminc Xmd_faminc stdmfincK
    sum md_faminc Xmd_faminc stdmfincK if pellgap<.

    local oldvar "pellper0713"
    local newvar "stdpellper0713"
    local varlab "Standardized score for % Pell recipients among undergrad 07-12"
    global addvars "$addvars `newvar'"
    egen `newvar' = std(`oldvar'), mean(0) std(1)
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Standardized score for % Pell recipients among undergrad 07-12. | `tag'

    sum `oldvar' `newvar' stdmedincome stdmfincK

    corr `newvar' stdmedincome stdmfincK
    corr `newvar' stdmedincome stdmfincK if pellgap<.

 ** Class inequality index 

  * A: Use household income
  
    local newvar1 "clsineqA"
    local newvar2 "stdclsineqA"
    local varlab1 "Averaged HOUSEHOLD income & % Pell"
    local varlab2 "Std averaged HOUSEHOLD income & % Pell"
    global addvars "$addvars `newvar1' `newvar2'"
    corr stdmedincome stdpellper0713
    
    gen `newvar1' = (stdmedincome + stdpellper0713)/2
    egen `newvar2' = std(`newvar1'), mean(0) std(1)
    lab var `newvar1' "`varlab1'"
    lab var `newvar2' "`varlab2'"
    note `newvar1': Averaged median HOUSEHOLD income standard scores and % Pell /// 
         recipients standard scores. High scores indicate high median HOUSEHOLD /// 
         income and high % Pell recipients. | `tag'
    note `newvar2': Standardized average median HOUSEHOLD income standard scores /// 
         and % Pell recipients standard scores. High scores indicate high median /// 
         HOUSEHOLD income and high % Pell recipients. | `tag'

    sum stdclsineqA if pellgap<., detail
    // sum stdclsineqA if pellgap<.
    local inequA95 = r(p95)
    local inequA90 = r(p90)
    local inequA75 = r(p75)
    gen inequA95 = (stdclsineqA>`inequA95') if pellgap<. & stdclsineqA<.
    gen inequA90 = (stdclsineqA>`inequA90') if pellgap<. & stdclsineqA<.
    gen inequA75 = (stdclsineqA>`inequA75') if pellgap<. & stdclsineqA<.
    lab var inequA95 "Top 5% unequal schools"
    lab var inequA90 "Top 10% unequal schools"
    lab var inequA75 "Top 25% unequal schools"
    note inequA95: [stdclsineqA] Top 5% unequal schools. | `tag'
    note inequA90: [stdclsineqB] Top 10% unequal schools. | `tag'
    note inequA75: [stdclsineqB] Top 25% unequal schools. | `tag'
    sum inequA95 inequA90 inequA75
    global addvars "$addvars inequA95 inequA90 inequA75"
    
  * B: Use family income
  
    local newvar1 "clsineqB"
    local newvar2 "stdclsineqB"
    local varlab1 "Averaged FAMILY income & % Pell"
    local varlab2 "Std averaged FAMILY income & % Pell"
    global addvars "$addvars `newvar1' `newvar2'"
    corr stdmfincK stdpellper0713

    gen `newvar1' = (stdmfincK + stdpellper0713)/2
    egen `newvar2' = std(`newvar1'), mean(0) std(1)
    lab var `newvar1' "`varlab1'"
    lab var `newvar2' "`varlab2'"
    note `newvar1': Averaged median FAMILY income standard scores and % Pell /// 
         recipients standard scores. High scores indicate high median FAMILY /// 
         income and high % Pell recipients. | `tag'
    note `newvar2': Standardized average median FAMILY income standard scores /// 
         and % Pell recipients standard scores. High scores indicate high median /// 
         FAMILY income and high % Pell recipients. | `tag'

    sum stdclsineqB if pellgap<., detail
    // sum stdclsineqB if pellgap<.
    local inequB95 = r(p95)
    local inequB90 = r(p90)
    local inequB75 = r(p75)
    gen inequB95 = (stdclsineqB>`inequB95') if pellgap<. & stdclsineqB<.
    gen inequB90 = (stdclsineqB>`inequB90') if pellgap<. & stdclsineqB<.
    gen inequB75 = (stdclsineqB>`inequB75') if pellgap<. & stdclsineqB<.
    lab var inequB95 "Top 5% unequal schools"
    lab var inequB90 "Top 10% unequal schools"
    lab var inequB75 "Top 25% unequal schools"
    note inequB95: [stdclsineqB] Top 5% unequal schools. | `tag'
    note inequB90: [stdclsineqB] Top 10% unequal schools. | `tag'
    note inequB75: [stdclsineqB] Top 25% unequal schools. | `tag'
    sum inequB95 inequB90 inequB75
    global addvars "$addvars inequB95 inequB90 inequB75"

*** Model specification

    note Anotes: Ys = [pellrates] Pell graduation rates. [nonpellrates] non-Pell ///
         graduation rates. [pellgap] Gap in Pell v Non-Pell grad rates. [pellratio] ///
         Ratio in Pell v Non-Pell grad rates. Also check the dummy variable ///
         recording missing in non-pell rates in USN but not missing in EdTrust /// 
         [nonpellmark]. / $tag/$log

    note Anotes: Key Xs = [perfrat] % undergrad men as fraternity members. ///
         [persoror] % undergrad women as sorority members. [greekyes] Campus /// 
         Includes Greek Housing? / $tag/$log

    note Anotes: Key Xs = Our main analyses will consider continuous percent /// 
         fraternity men [perfrat], but supplemental analyses should consider a ///
         dichotomous measure of campuses includes Greek housing [greekyes], and ///
         percent sorority [persoror]. | `tag'
         
    note Anotes: Controls (2013 measures) -- [Private] [perSTEM] [endow0712K] [urbanicity] [Region] [Nmininst] [Ndegsel]. / $tag/$log

    note Anotes: Controls (2007-2012 average measures)-- percent pell /// 
         [pellper0712], size [schsize0712], average endowment in $ per student /// 
         [endow0712K], and acceptance rate [Accept0712]. In email 151119 /// 
         from Laura, Laura notes that we would like to be consistent and use the ///
         same six years for institution size and percent pell: 2007-2008, /// 
         2008-2009, 2009-2010, 2010-2011, 2011-2012, 2012-2013. So, we should /// 
         use [pellper0712] and [schsize0712], not [pellper0713] and /// 
         [schsize0713]. When [schsize0712] is missing, we use the 2013-2014 /// 
         data to impute if the information is available. In the same email, we ///
         we also confirm that we do NOT use the 2013 acceptance rate, because /// 
         that is technically academic year 13-14. | $tag/$log

    note Anotes: Controls (2007-2013 average measures): SAT average [avgSAT0713]. This /// 
         measure is the average of avgSAT0713 avgSAT0708 avgSAT0809 avgSAT0910 avgSAT1011 /// 
         avgSAT1112 avgSAT1213. | $tag/$log

    note Anotes: Controls (2008-2012 average measures)-- [np_linc0813K]. This /// 
         is the averaged net price for low income students (0-30K) for 08-13 in ///
         K (including 12-13 but not 13-14). There appear to be no 2007 data. | $tag/$log

*** Check

    local tmpvar "perfrat"
    gen X`tmpvar'0 = (`tmpvar'>0) if `tmpvar'<.
    lab var X`tmpvar'0 "Schools frat above 0?"
    gen X`tmpvar'5 = (`tmpvar'>5) if `tmpvar'<.
    lab var X`tmpvar'5 "Schools frat above 5?"
    lab val X`tmpvar'0 yes
    lab val X`tmpvar'5 yes

    tab X`tmpvar'0 Ndegsel if X`tmpvar'0<., m col
    tab X`tmpvar'5 Ndegsel if X`tmpvar'5<., m col

    tab X`tmpvar'0 Nmininst if X`tmpvar'0<., m col
    tab X`tmpvar'5 Nmininst if X`tmpvar'5<., m col

*** Save new data

    numlabel, add
    label data "$tag"
    keep unitid instnm $addvars
    order unitid instnm $addvars
    qui save "$dsnew", replace

    codebook $addvars, compact
    notes list $addvars
    di "$addvars"

log close

