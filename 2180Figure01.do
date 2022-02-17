*** do 2180Figure01
 ** v01: Figure 1 based on the interaction effects in Table 6
 
global log "2180Figure01"
global logN "2180"
global dsold "2000Impute"
global tag "$path" 
global graf ".emf"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 85
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
    nmlab `Y' `Xs' `Select' `Controls', col(21)
    sum `Y' `Xs' `Select' `Controls' if ccvar==1 & _mj==1, sep(0)
    pwcorr perGreek greekyes if ccvar==1 & _mj==1

*** Graph 

    local j = 9
    global X1 "perGreek"
    global X2 "greekyes"
    global X3 "Ndegsel"
    tab Ndegsel if ccvar==1 & _mj==1, m

*** % Greek students

    global title "% Greek students"

  * Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_1
    qui mgen, at($X1=(0(10)80) i1.$X3=0 i2.$X3=1 i3.$X3=0) stub(pltGaps) predlabel(Gaps in graduation rates)
    
 ** Non-Pell rates

    global Y "nonpellrates"
    qui regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_2
    qui mgen, at($X1=(0(10)80) i1.$X3=0 i2.$X3=1 i3.$X3=0) stub(pltnP) predlabel(Non-Pell graduation rates)

 ** Pell rates

    global Y "pellrates"
    qui regress $Y c.$X1#i1.$X3 c.$X1#i2.$X3 c.$X1#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_3
    qui mgen, at($X1=(0(10)80) i1.$X3=0 i2.$X3=1 i3.$X3=0) stub(pltPel) predlabel(Pell graduation rates)

    estimates table Model_1 Model_2 Model_3, b(%9.3f) star(.01 .05 .10) stats(N r2) title($title)

    sum plt*, sep(4)
    nmlab plt*, col(21)
    lab var pltGapsxb "Difference"

 ** Plot

    twoway (scatter pltnPxb pltnPperGreek, c(l) yaxis(1) ylab(50(5)70, grid glcolor(gs14)) ytitle("Graduation rates (%)", margin(medsmall)) msym(Oh) msiz(*1.1) mcol(blue) lcol(blue) ) ///
        (scatter pltPelxb pltPelperGreek, c(l) yaxis(1) msym(Th) msiz(*1.1) mcol(blue) lcol(blue)) ///
        (scatter pltGapsxb pltGapsperGreek, c(l) yaxis(2) ytitle("Differences (%)", margin(medsmall) axis(2)) msym(Dh) msiz(*1.1) mcol(red) lcol(red)), ///
        scheme(s1mono) title("Figure 1. Graduation Rates by Percent of Greek Students", size(medium) pos(7)) ///
        xtitle("Percent of Greek Students", size(medsmall) margin(medsmall)) ///
        legend(cols(1) region(lstyle(none)) ring(0) pos(11))

    graph export figure1.eps, replace
    graph export figure1.wmf, replace
    graph export figure1.emf, replace
    graph export figure1.png, replace

    format %8.2f pltGapsxb pltGapsll pltGapsul pltnPxb pltPelxb
    list pltGapsperGreek pltGapsxb pltnPxb pltPelxb in 1/9, clean nolab noobs

*** On-campus Greek housing

    global title "On-campus Greek housing"
    local j = 10

 ** Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_1
    qui mtable, atmeans estname(Greek) atvars(_none) clear ///
            at($X2=1 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    qui mtable, atmeans estname(NoGreek) atvars(_none) right ///
            at($X2=0 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    mtable, atmeans estname(Dif) atvars(_none) dydx($X2) stats(est p) right title(Greek House on Grauduation Gap) ///
            at(i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=0 i3.$X3=1)

 ** Non-Pell rates

    global Y "nonpellrates"
    qui regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_2
    qui mtable, atmeans estname(Greek) atvars(_none) clear ///
            at($X2=1 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    qui mtable, atmeans estname(NoGreek) atvars(_none) right ///
            at($X2=0 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    mtable, atmeans estname(Dif) atvars(_none) dydx($X2) stats(est p) right title(Greek House on Non-Pell Rate) ///
            at(i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=0 i3.$X3=1)

 ** Pell rates

    global Y "pellrates"
    qui regress $Y i.$X2#i1.$X3 i.$X2#i2.$X3 i.$X2#i3.$X3 i.$X3 $Select $iControls if ccvar==1 & _mj==`j'
    estimates store Model_3
    qui mtable, atmeans estname(Greek) atvars(_none) clear ///
            at($X2=1 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=1 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    qui mtable, atmeans estname(NoGreek) atvars(_none) right ///
            at($X2=0 i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at($X2=0 i1.$X3=0 i2.$X3=0 i3.$X3=1)
    mtable, atmeans estname(Dif) atvars(_none) dydx($X2) stats(est p) right title(Greek House on Pell Rate) ///
            at(i1.$X3=1 i2.$X3=0 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=1 i3.$X3=0) ///
            at(i1.$X3=0 i2.$X3=0 i3.$X3=1)

    estimates table Model_1 Model_2 Model_3, b(%9.3f) star(.01 .05 .10) stats(N r2) title($title)

log close

