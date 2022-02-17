*** do 2120Table02
 ** v01: Table 2 presents correlations and mean comparisons by Greek life measures
 
global path "FirstGen/07_160314"
global log "2120Table02"
global logN "2120"
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

    local Ys "pellgap nonpellrates pellrates pellratio"
    local mYs "pellgap pellratio"
    local Xs "perGreek greekyes perfrat persoror"
    local  Select "  Ndegsel Accept0712 Private"
    local iSelect "i.Ndegsel Accept0712 Private"
    local mSelect "m.Ndegsel Accept0712 Private"
    local  Controls "np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K   urbanicity4   Region pellper0712 perWomen perBlkHis"
    local iControls "np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region pellper0712 perWomen perBlkHis"

*** MI Setup

    use "$dsold", clear

    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    // sum `Ys' `Xs' `iSelect' `iControls' if ccvar==1 & _mi_m==1

    mi describe 
    mi convert wide, clear
    mi unset, asis

*** Correlations

    global X1 "perGreek"
    global X2 "greekyes"

 ** % Greek students

    qui sum perGreek if ccvar==1
    local N = r(N)

    local i = 1
    while `i' <= 20 {
        qui sum _`i'_perGreek if ccvar==1
        local mA`i' = r(mean)

        qui sum _`i'_perGreek if ccvar==1 & _`i'_greekyes==1
        local m1`i' = r(mean)
        local obs1`i' = r(N) 
        local sd1`i' = r(sd)

        qui sum _`i'_perGreek if ccvar==1 & _`i'_greekyes==0
        local m0`i' = r(mean)
        local obs0`i' = r(N) 
        local sd0`i' = r(sd)

        qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
        local p4`i' = r(p)

        local i = `i' + 1
    }
    local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
    local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
    local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20

    local ast4 "" // based on m=1
    if `p41' <=0.10 {
        local ast4 "+"
    }
    if `p41' <=0.05 {
        local ast4 "*"
    }
    if `p41' <=0.01 {
        local ast4 "**"
    }
    di %12s "perGreek" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                    _col(42) %8.3f `mean0' _col(51) "`ast4'"

 ** Continuous variables

    foreach var of varlist `Select' `Controls' {
        qui sum `var' if ccvar==1
        local N = r(N)
        if `N' == 1082 {
            local i = 1
            while `i' <= 20 {
                local X1 "_`i'_$X1"
                local X2 "_`i'_$X2"

                qui pwcorr `var' `X1' if ccvar==1
                local r1`i' = r(rho)

                qui pwcorr `var' `X1' if ccvar==1 & `X2'==1 
                local r2`i' = r(rho)

                qui pwcorr `var' `X1' if ccvar==1 & `X2'==0
                local r3`i' = r(rho)

                qui sum `var' if ccvar==1
                local mA`i' = r(mean)
                local obsA`i' = r(N) 
                local sdA`i' = r(sd)

                qui sum `var' if ccvar==1 & `X2'==1
                local m1`i' = r(mean)
                local obs1`i' = r(N) 
                local sd1`i' = r(sd)

                qui sum `var' if ccvar==1 & `X2'==0
                local m0`i' = r(mean)
                local obs0`i' = r(N) 
                local sd0`i' = r(sd)

                qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
                local p4`i' = r(p)

                local i = `i' + 1
            }
            local rho1 = (`r11'+`r12'+`r13'+`r14'+`r15'+`r16'+`r17'+`r18'+`r19'+`r110'+`r111'+`r112'+`r113'+`r114'+`r115'+`r116'+`r117'+`r118'+`r119'+`r120')/20
            local p1 = min(2*ttail(1082-2,abs(`rho1')*sqrt(1082-2)/ sqrt(1-`rho1'^2)),1)
            local rho2 = (`r21'+`r22'+`r23'+`r24'+`r25'+`r26'+`r27'+`r28'+`r29'+`r210'+`r211'+`r212'+`r213'+`r214'+`r215'+`r216'+`r217'+`r218'+`r219'+`r220')/20
            local p2 = min(2*ttail(1082-2,abs(`rho2')*sqrt(1082-2)/ sqrt(1-`rho2'^2)),1)
            local rho3 = (`r31'+`r32'+`r33'+`r34'+`r35'+`r36'+`r37'+`r38'+`r39'+`r310'+`r311'+`r312'+`r313'+`r314'+`r315'+`r316'+`r317'+`r318'+`r319'+`r320')/20
            local p3 = min(2*ttail(1082-2,abs(`rho3')*sqrt(1082-2)/ sqrt(1-`rho3'^2)),1)

            local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
            local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
            local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20

            local ast1 ""
            if `p1' <=0.10 {
                local ast1 "+"
            }
            if `p1' <=0.05 {
                local ast1 "*"
            }
            if `p1' <=0.01 {
                local ast1 "**"
            }
            local ast2 ""
            if `p2' <=0.10 {
                local ast2 "+"
            }
            if `p2' <=0.05 {
                local ast2 "*"
            }
            if `p2' <=0.01 {
                local ast2 "**"
            }
            local ast3 ""
            if `p3' <=0.10 {
                local ast3 "+"
            }
            if `p3' <=0.05 {
                local ast3 "*"
            }
            if `p3' <=0.01 {
                local ast3 "**"
            }
            local ast4 "" // based on m=1
            if `p41' <=0.10 {
                local ast4 "+"
            }
            if `p41' <=0.05 {
                local ast4 "*"
            }
            if `p41' <=0.01 {
                local ast4 "**"
            }
            di %12s "`var'" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                            _col(42) %8.3f `mean0' _col(51) "`ast4'" _col(56) %7.4f `rho1' _col(64) "`ast1'" ///
                            _col(69) %7.4f `rho2' _col(77) "`ast2'" _col(82) %7.4f `rho3' _col(90) "`ast3'"
        } 
        else if `N' < 1082 {
            local i = 1
            while `i' <= 20 {
                local Y "_`i'_`var'"
                local X1 "_`i'_$X1"
                local X2 "_`i'_$X2"

                qui pwcorr `Y' `X1' if ccvar==1
                local r1`i' = r(rho)

                qui pwcorr `Y' `X1' if ccvar==1 & `X2'==1
                local r2`i' = r(rho)

                qui pwcorr `Y' `X1' if ccvar==1 & `X2'==0
                local r3`i' = r(rho)

                qui sum `Y' if ccvar==1
                local mA`i' = r(mean)
                local obsA`i' = r(N) 
                local sdA`i' = r(sd)

                qui sum `Y' if ccvar==1 & `X2'==1
                local m1`i' = r(mean)
                local obs1`i' = r(N) 
                local sd1`i' = r(sd)

                qui sum `Y' if ccvar==1 & `X2'==0
                local m0`i' = r(mean)
                local obs0`i' = r(N) 
                local sd0`i' = r(sd)

                qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
                local p4`i' = r(p)

                local i = `i' + 1
            }
            local rho1 = (`r11'+`r12'+`r13'+`r14'+`r15'+`r16'+`r17'+`r18'+`r19'+`r110'+`r111'+`r112'+`r113'+`r114'+`r115'+`r116'+`r117'+`r118'+`r119'+`r120')/20
            local p1 = min(2*ttail(1082-2,abs(`rho1')*sqrt(1082-2)/ sqrt(1-`rho1'^2)),1)
            local rho2 = (`r21'+`r22'+`r23'+`r24'+`r25'+`r26'+`r27'+`r28'+`r29'+`r210'+`r211'+`r212'+`r213'+`r214'+`r215'+`r216'+`r217'+`r218'+`r219'+`r220')/20
            local p2 = min(2*ttail(1082-2,abs(`rho2')*sqrt(1082-2)/ sqrt(1-`rho2'^2)),1)
            local rho3 = (`r31'+`r32'+`r33'+`r34'+`r35'+`r36'+`r37'+`r38'+`r39'+`r310'+`r311'+`r312'+`r313'+`r314'+`r315'+`r316'+`r317'+`r318'+`r319'+`r320')/20
            local p3 = min(2*ttail(1082-2,abs(`rho3')*sqrt(1082-2)/ sqrt(1-`rho3'^2)),1)
            local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
            local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
            local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20

            local ast1 ""
            if `p1' <=0.10 {
                local ast1 "+"
            }
            if `p1' <=0.05 {
                local ast1 "*"
            }
            if `p1' <=0.01 {
                local ast1 "**"
            }
            local ast2 ""
            if `p2' <=0.10 {
                local ast2 "+"
            }
            if `p2' <=0.05 {
                local ast2 "*"
            }
            if `p2' <=0.01 {
                local ast2 "**"
            }
            local ast3 ""
            if `p3' <=0.10 {
                local ast3 "+"
            }
            if `p3' <=0.05 {
                local ast3 "*"
            }
            if `p3' <=0.01 {
                local ast3 "**"
            }
            local ast4 "" // based on m=1
            if `p41' <=0.10 {
                local ast4 "+"
            }
            if `p41' <=0.05 {
                local ast4 "*"
            }
            if `p41' <=0.01 {
                local ast4 "**"
            }
            di %12s "`var'" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                            _col(42) %8.3f `mean0' _col(51) "`ast4'" _col(56) %7.4f `rho1' _col(64) "`ast1'" ///
                            _col(69) %7.4f `rho2' _col(77) "`ast2'" _col(82) %7.4f `rho3' _col(90) "`ast3'"
        } 
    }

 ** Categorical variables

    foreach num of numlist 1 2 3 {
        local i = 1
        while `i' <= 20 {
            local X2 "_`i'_$X2"

            qui sum i`num'._`i'_Ndegsel if ccvar==1
            local mA`i' = r(mean)

            qui sum i`num'._`i'_Ndegsel if ccvar==1 & `X2'==1
            local m1`i' = r(mean)
            local obs1`i' = r(N) 
            local sd1`i' = r(sd)

            qui sum i`num'._`i'_Ndegsel if ccvar==1 & `X2'==0
            local m0`i' = r(mean)
            local obs0`i' = r(N) 
            local sd0`i' = r(sd)

            qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
            local p2`i' = r(p)

            local i = `i' + 1
        }
        local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
        local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
        local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20
        local ast4 "" // based on m=1
        if `p41' <=0.10 {
            local ast4 "+"
        }
        if `p41' <=0.05 {
            local ast4 "*"
        }
        if `p41' <=0.01 {
            local ast4 "**"
        }
        di %12s "i`num'.Ndegsel" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                            _col(42) %8.3f `mean0' _col(51) "`ast4'"
    }

    foreach num of numlist 1 2 3 4 {
        local i = 1
        while `i' <= 20 {
            local X2 "_`i'_$X2"

            qui sum i`num'.urbanicity4 if ccvar==1
            local mA`i' = r(mean)

            qui sum i`num'.urbanicity4 if ccvar==1 & `X2'==1
            local m1`i' = r(mean)
            local obs1`i' = r(N) 
            local sd1`i' = r(sd)

            qui sum i`num'.urbanicity4 if ccvar==1 & `X2'==0
            local m0`i' = r(mean)
            local obs0`i' = r(N) 
            local sd0`i' = r(sd)

            qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
            local p2`i' = r(p)

            local i = `i' + 1
        }
        local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
        local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
        local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20
        local ast4 "" // based on m=1
        if `p41' <=0.10 {
            local ast4 "+"
        }
        if `p41' <=0.05 {
            local ast4 "*"
        }
        if `p41' <=0.01 {
            local ast4 "**"
        }
        di %12s "i`num'.urbanicity4" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                            _col(42) %8.3f `mean0' _col(51) "`ast4'"
    }
    foreach num of numlist 1 2 3 4 5 {
        local i = 1
        while `i' <= 20 {
            local X2 "_`i'_$X2"

            qui sum i`num'.Region if ccvar==1
            local mA`i' = r(mean)

            qui sum i`num'.Region if ccvar==1 & `X2'==1
            local m1`i' = r(mean)
            local obs1`i' = r(N) 
            local sd1`i' = r(sd)

            qui sum i`num'.Region if ccvar==1 & `X2'==0
            local m0`i' = r(mean)
            local obs0`i' = r(N) 
            local sd0`i' = r(sd)

            qui ttesti `obs1`i'' `m1`i'' `sd1`i'' `obs0`i'' `m0`i'' `sd0`i'', unequal
            local p2`i' = r(p)

            local i = `i' + 1
        }
        local meanA = (`mA1'+`mA2'+`mA3'+`mA4'+`mA5'+`mA6'+`mA7'+`mA8'+`mA9'+`mA10'+`mA11'+`mA12'+`mA13'+`mA14'+`mA15'+`mA16'+`mA17'+`mA18'+`mA19'+`mA20')/20
        local mean1 = (`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m110'+`m111'+`m112'+`m113'+`m114'+`m115'+`m116'+`m117'+`m118'+`m119'+`m120')/20
        local mean0 = (`m01'+`m02'+`m03'+`m04'+`m05'+`m06'+`m07'+`m08'+`m09'+`m010'+`m011'+`m012'+`m013'+`m014'+`m015'+`m016'+`m017'+`m018'+`m019'+`m020')/20
        local ast2 "" // based on m=1
        if `p41' <=0.10 {
            local ast4 "+"
        }
        if `p41' <=0.05 {
            local ast4 "*"
        }
        if `p41' <=0.01 {
            local ast4 "**"
        }
        di %12s "i`num'.Region" _col(14) "|" _col(16) %7.0f `N' _col(24) %8.3f `meanA' _col(33) %8.3f `mean1' /// 
                            _col(42) %8.3f `mean0' _col(51) "`ast4'"
    }

log close
