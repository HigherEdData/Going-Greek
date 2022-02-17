*** do 2150Table06
 ** v01: Table 6: Interaction effects
 
global path "FirstGen/07_160314"
global log "2150Table06"
global logN "2150"
global dsold "2000Impute"
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

*** Models

    local Y "pellgap nonpellrates pellrates"
    local Xs "perGreek greekyes Ndegsel"
    local  Select "Accept0712 Private"
    global Select "Accept0712 Private"
    local mSelect "m.Ndegsel Accept0712 Private"
    local   Controls "np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K   urbanicity4   Region pellper0712 perWomen perBlkHis"
    global iControls "np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region pellper0712 perWomen perBlkHis"

*** MI Setup

    use "$dsold", clear
    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 
    // mi unset, asis
    mi convert wide, clear

    nmlab `Y' `Xs' `Select' `Controls', col(21)

    global X1 "perGreek"
    global X2 "greekyes"
    global X3 "Ndegsel"

*** % Greek students

    global title "% Greek students"

 ** Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    mi estimate, ni(20) dots post saving(Model_1, replace): regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_1
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i2.$X3]) using Model_1, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i3.$X3]) using Model_1, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i2.$X3]-_b[c.$X1#i3.$X3]) using Model_1, nocoef
    mi testtransform diff

 ** Non-Pell rates

    global Y "nonpellrates"
    mi estimate, ni(20) dots post saving(Model_2, replace): regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_2
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i2.$X3]) using Model_2, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i3.$X3]) using Model_2, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i2.$X3]-_b[c.$X1#i3.$X3]) using Model_2, nocoef
    mi testtransform diff

 ** Pell rates

    global Y "pellrates"
    mi estimate, ni(20) dots post saving(Model_3, replace): regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_3
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i2.$X3]) using Model_3, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i1.$X3]-_b[c.$X1#i3.$X3]) using Model_3, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[c.$X1#i2.$X3]-_b[c.$X1#i3.$X3]) using Model_3, nocoef
    mi testtransform diff

    estimates table Model_1 Model_2 Model_3, b(%9.3f) star(.01 .05 .10) stats(N F_mi p_mi) title($title)

*** On-campus Greek housing

    global title "On-campus Greek housing"

 ** Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    mi estimate, ni(20) dots post saving(Model_1, replace): regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_1
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i2.$X3]) using Model_1, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i3.$X3]) using Model_1, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i2.$X3]-_b[i1.$X2#i3.$X3]) using Model_1, nocoef
    mi testtransform diff

 ** Non-Pell rates

    global Y "nonpellrates"
    mi estimate, ni(20) dots post saving(Model_2, replace): regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_2
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i2.$X3]) using Model_2, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i3.$X3]) using Model_2, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i2.$X3]-_b[i1.$X2#i3.$X3]) using Model_2, nocoef
    mi testtransform diff

 ** Pell rates

    global Y "pellrates"
    mi estimate, ni(20) dots post saving(Model_3, replace): regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls
    estimates store Model_3
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i2.$X3]) using Model_3, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i1.$X3]-_b[i1.$X2#i3.$X3]) using Model_3, nocoef
    mi testtransform diff
    qui mi estimate (diff: _b[i1.$X2#i2.$X3]-_b[i1.$X2#i3.$X3]) using Model_3, nocoef
    mi testtransform diff

    estimates table Model_1 Model_2 Model_3, b(%9.3f) star(.01 .05 .10) stats(N F_mi p_mi) title($title)

log close

