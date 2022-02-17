*** do 3000PLoop
 ** v01: Loop for testing interaction effects
 
global path "FirstGen/07_160314"
global log "3000PLoop"
global logN "3000"
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

*** MI Setup and Extract Dataset 1

    use "$dsold", clear
    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 
    mi convert wide, clear

    mi extract 1
    nmlab `Y' `Xs' `Select' `Controls', col(21)

    global X1 "perGreek"
    global X2 "greekyes"
    global X3 "Ndegsel"

*** Create type of schools

    capture drop type
    gen type = .
    replace type = 1 if ccvar==1 & greekyes==1 & Ndegsel==1
    replace type = 2 if ccvar==1 & greekyes==1 & Ndegsel==2
    replace type = 3 if ccvar==1 & greekyes==1 & Ndegsel==3
    replace type = 4 if ccvar==1 & greekyes==0 & Ndegsel==1
    replace type = 5 if ccvar==1 & greekyes==0 & Ndegsel==2
    replace type = 6 if ccvar==1 & greekyes==0 & Ndegsel==3
    lab def typev 1 "1_Greek & Inclusive" 2 "2_Greek & Selective" 3 "3_Greek & More Selective" ///
        4 "4_NonGreek & Inclusive" 5 "5_NonGreek & Selective" 6 "6_NonGreek & More Selective"
    lab val type typev
    tab type

*** Run regression and use mtable

 ** Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"

    regress $Y $X2#i1.$X3 $X2#i2.$X3 $X2#i3.$X3 i.$X3 $Select $iControls

    qui mtable if type==1, rowname(1 Greek & Inclusive) atmeans clear
        local set1 "`r(atspec)'"

    qui mtable if type==2, rowname(2 Greek & Selective) atmeans below
        local set2 "`r(atspec)'"

    qui mtable if type==3, rowname(3 Greek & More selective) atmeans below
        local set3 "`r(atspec)'"

    mtable if type==4, rowname(4 Non-Greek & Inclusive) atmeans below
        local set4 "`r(atspec)'"

    qui mtable if type==5, rowname(5 Non-Greek & Selective) atmeans below
        local set5 "`r(atspec)'"

    mtable if type==6, rowname(6 Non-Greek & More selective) atmeans below
        local set6 "`r(atspec)'"

    mtable, at(`set1') at(`set2') at(`set3') at(`set4') at(`set5') at(`set6') post noatvars

  * test predictions
    
    matrix pval = J(6,5,.z) // .z defines empty cells. .y will show .y. . will show .
    matrix rownames pval = "1 Gr & Inclu" "2 Gr & Selec" "3 Gr & MoreS" "4 NG & Inclu" "5 NG & Selec" "6 NG & MoreS"
    matrix colnames pval = (1) (2) (3) (4) (5)
    
    foreach irow in 1 2 3 4 5 6 {
        foreach icol in 1 2 3 4 5 6 {
            if `icol' < `irow' {
                di "*** `irow' vs `icol'"
                mlincom `irow' - `icol'
                scalar p = r(p)
                matrix pval[`irow',`icol'] = p
            }
        }
    }

    matlist pval, format(%7.2f) title(Pvalue for equal predictions) nodotz

 ** Non-Pell rates

    global Y "nonpellrates"
   regress $Y $X2#i1.$X3 $X2#i2.$X3 $X2#i3.$X3 i.$X3 $Select $iControls

    qui mtable if type==1, rowname(1 Greek & Inclusive) atmeans clear
        local set1 "`r(atspec)'"

    qui mtable if type==2, rowname(2 Greek & Selective) atmeans below
        local set2 "`r(atspec)'"

    qui mtable if type==3, rowname(3 Greek & More selective) atmeans below
        local set3 "`r(atspec)'"

    mtable if type==4, rowname(4 Non-Greek & Inclusive) atmeans below
        local set4 "`r(atspec)'"

    qui mtable if type==5, rowname(5 Non-Greek & Selective) atmeans below
        local set5 "`r(atspec)'"

    mtable if type==6, rowname(6 Non-Greek & More selective) atmeans below
        local set6 "`r(atspec)'"

    mtable, at(`set1') at(`set2') at(`set3') at(`set4') at(`set5') at(`set6') post noatvars

  * test predictions
    
    matrix pval = J(6,5,.z) // .z defines empty cells. .y will show .y. . will show .
    matrix rownames pval = "1 Gr & Inclu" "2 Gr & Selec" "3 Gr & MoreS" "4 NG & Inclu" "5 NG & Selec" "6 NG & MoreS"
    matrix colnames pval = (1) (2) (3) (4) (5)
    
    foreach irow in 1 2 3 4 5 6 {
        foreach icol in 1 2 3 4 5 6 {
            if `icol' < `irow' {
                di "*** `irow' vs `icol'"
                mlincom `irow' - `icol'
                scalar p = r(p)
                matrix pval[`irow',`icol'] = p
            }
        }
    }

    matlist pval, format(%7.2f) title(Pvalue for equal predictions) nodotz

 ** Pell rates

    global Y "pellrates"
   regress $Y $X2#i1.$X3 $X2#i2.$X3 $X2#i3.$X3 i.$X3 $Select $iControls

    qui mtable if type==1, rowname(1 Greek & Inclusive) atmeans clear
        local set1 "`r(atspec)'"

    qui mtable if type==2, rowname(2 Greek & Selective) atmeans below
        local set2 "`r(atspec)'"

    qui mtable if type==3, rowname(3 Greek & More selective) atmeans below
        local set3 "`r(atspec)'"

    mtable if type==4, rowname(4 Non-Greek & Inclusive) atmeans below
        local set4 "`r(atspec)'"

    qui mtable if type==5, rowname(5 Non-Greek & Selective) atmeans below
        local set5 "`r(atspec)'"

    mtable if type==6, rowname(6 Non-Greek & More selective) atmeans below
        local set6 "`r(atspec)'"

    mtable, at(`set1') at(`set2') at(`set3') at(`set4') at(`set5') at(`set6') post noatvars

  * test predictions
    
    matrix pval = J(6,5,.z) // .z defines empty cells. .y will show .y. . will show .
    matrix rownames pval = "1 Gr & Inclu" "2 Gr & Selec" "3 Gr & MoreS" "4 NG & Inclu" "5 NG & Selec" "6 NG & MoreS"
    matrix colnames pval = (1) (2) (3) (4) (5)
    
    foreach irow in 1 2 3 4 5 6 {
        foreach icol in 1 2 3 4 5 6 {
            if `icol' < `irow' {
                di "*** `irow' vs `icol'"
                mlincom `irow' - `icol'
                scalar p = r(p)
                matrix pval[`irow',`icol'] = p
            }
        }
    }

    matlist pval, format(%7.2f) title(Pvalue for equal predictions) nodotz

log close

