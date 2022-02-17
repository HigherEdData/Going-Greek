*** do 2000Impute
 ** v01: Imputations
 
global path "FirstGen/07_160314"
global log "2000Impute"
global logN "2000"
global dsold "1000cln"
global dsnew "2000Impute"
global tag "$path" 
global graf ".emf"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 140
set more off
log using "$log", t replace
use "$dsold", clear

*** Keep and order variables

    keep unitid instnm Findnotes Anotes Qnotes Samplenotes /// identification and notes
         pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp nonpellmark /// Ys
         perfrat persoror perGreek greekyes /// Key Xs
         pellper0712 pellper0713 pellper1213 np_linc0813K outfee13K infee13K  /// Controls
         Nmininst perWomen perBlkHis perSTEM endow0712 endow0712K lnendow0712K Private ///
         schsize0712K schsize0713 schsize urbanicity4 urbanicity Region ///
         Ndegsel avgSAT0713 Nsat_avg Accept0712 Naccept13 /// Selectivity controls
         percG1 /// not used
         mhhincK stdmedincome stdpellper0713 clsineqA stdclsineqA inequA95 inequA90 inequA75 /// class inequality
         mfincK stdmfincK clsineqB stdclsineqB inequB95 inequB90 inequB75
         
    order unitid instnm Findnotes Anotes Qnotes Samplenotes /// identification and notes
         pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp nonpellmark /// Ys
         perfrat persoror perGreek greekyes /// Key Xs
         pellper0712 pellper0713 pellper1213 np_linc0813K outfee13K infee13K  /// Controls
         Nmininst perWomen perBlkHis perSTEM endow0712 endow0712K lnendow0712K Private ///
         schsize0712K schsize0713 schsize urbanicity4 urbanicity Region ///
         Ndegsel avgSAT0713 Nsat_avg Accept0712 Naccept13 /// Selectivity controls
         percG1 /// not used
         mhhincK stdmedincome stdpellper0713 clsineqA stdclsineqA inequA95 inequA90 inequA75 /// class inequality
         mfincK stdmfincK clsineqB stdclsineqB inequB95 inequB90 inequB75

*** Note model specification

    notes Anotes: Ys = pellrates nonpellrates pellgap pellratio. | $tag/$logN
    notes Anotes: Xs = perfrat persoror perGreek greekyes. | $tag/$logN
    notes Anotes: Controls = pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM endow0712K Private schsize0712K urbanicity4 Region mhhincK. | $tag/$logN
    notes Anotes: Selectivity = Ndegsel avgSAT0713 Accept0712. | $tag/$logN
    notes Anotes: Not used = pellcomp nonpellcomp nonpellmark pellper0713 pellper1213 outfee13K infee13K Nsat_avg Naccept13 schsize schsize0713 endow0712 endow0712K. | $tag/$logN 

*** Check variables

    local Ys "pellrates nonpellrates pellgap pellratio"
    local mYs "pellgap pellratio"
    local Xs "perfrat persoror perGreek greekyes"
    local Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K Private schsize0712K   urbanicity4   Region mhhincK"
    local iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K Private schsize0712K i.urbanicity4 i.Region mhhincK"
    local  Select "  Ndegsel avgSAT0713 Accept0712"
    local iSelect "i.Ndegsel avgSAT0713 Accept0712"
    local mSelect "m.Ndegsel avgSAT0713 Accept0712"

    codebook `Ys' `Xs' `Controls' `Select', compact
    sum `Ys' `Xs' `iControls' `iSelect' if pellgap<., sep(0)
    note list `Ys' `Xs' `Controls' `Select'

 ** Ys

    notes list `Ys'

    // histogram pellrates, width(5) percent
    // histogram nonpellrates, width(5) percent
    // histogram pellgap, width(5) percent
    // histogram pellratio, width(.2) percent

*** Xs

    misschk `Xs' `Controls' `Select' if pellgap<.

/*** Check

    local tmpvar "perfrat"
    gen X`tmpvar'0 = (`tmpvar'>0) if `tmpvar'<.
    lab var X`tmpvar'0 "Schools frat above 0?"
    gen X`tmpvar'5 = (`tmpvar'>5) if `tmpvar'<.
    lab var X`tmpvar'5 "Schools frat above 5?"
    lab def Yes 1 "Yes" 0 "No"
    lab val X`tmpvar'0 Yes
    lab val X`tmpvar'5 Yes

    tab X`tmpvar'0 Ndegsel if X`tmpvar'0<. & pellgap<., m col
    tab X`tmpvar'5 Ndegsel if X`tmpvar'5<. & pellgap<., m col

    tab X`tmpvar'0 Nmininst if X`tmpvar'0<. & pellgap<., m col
    tab X`tmpvar'5 Nmininst if X`tmpvar'5<. & pellgap<., m col
    tab Nmininst if pellgap<., m
*/
*** Impute missing in controls

    gen ccvar = .
    lab var ccvar "complete cases"
    replace ccvar = 1 if pellgap<.
    note list Samplenotes
    tab ccvar, m
    // keep if ccvar==1
    // keep unitid instnm 
    // sum
    // export excel idname, firstrow(variables) replace
    tab urbanicity ccvar, m
    tab urbanicity4 ccvar, m

    ice `mYs' `Xs' `iControls' `mSelect', m(20) cc(ccvar) /// 
        cmd(Ndegsel:ologit) persist substitute(Ndegsel:i.Ndegsel) seed(1010) saving($dsnew, replace)

log close

