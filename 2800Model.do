*** do 2800Model

 ** Model 1
 
    mi estimate, ni(20) dots post: regress $Y c.$X1
    estimates store Model_1

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y c.$X1
        local R`i' = e(r2)
    }
    local R_m1 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

 ** Model 2
 
    mi estimate, ni(20) dots post: regress $Y i.$X2
    estimates store Model_2

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y i.$X2
        local R`i' = e(r2)
    }
    local R_m2 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

 ** Model 3

    mi estimate, ni(20) dots post: regress $Y c.$X1 $iSelect
    estimates store Model_3

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y c.$X1 $iSelect
        local R`i' = e(r2)
    }
    local R_m3 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

 ** Model 4

    mi estimate, ni(20) dots post: regress $Y i.$X2 $iSelect
    estimates store Model_4

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y i.$X2 $iSelect
        
        local R`i' = e(r2)
    }
    local R_m4 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

 ** Model 5

    mi estimate, ni(20) dots post: regress $Y c.$X1 $iSelect $iControls
    estimates store Model_5

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y c.$X1 $iSelect $iControls
        local R`i' = e(r2)
    }
    local R_m5 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

 ** Model 6

    mi estimate, ni(20) dots post: regress $Y i.$X2 $iSelect $iControls
    estimates store Model_6

    forvalues i = 1(1)20 {
        qui mi xeq `i': regress $Y i.$X2 $iSelect $iControls
        
        local R`i' = e(r2)
    }
    local R_m6 = (`R1'+`R2'+`R3'+`R4'+`R5'+`R6'+`R7'+`R8'+`R9'+`R10'+`R11'+`R12'+`R13'+`R14'+`R15'+`R16'+`R17'+`R18'+`R19'+`R20')/20

    // estimates table Model_1 Model_2 Model_3, b(%9.3f) star(.01 .05 .10) stats(N F_mi p_mi) title($title)
    estimates table Model_1 Model_2 Model_3 Model_4 Model_5 Model_6, b(%9.3f) star(.01 .05 .10) stats(N F_mi p_mi) title($title)
    di _col(6) %7s "R2" _col(14) "|" _col(20) %4.3f `R_m1' _col(35) %4.3f `R_m2' _col(50) %4.3f `R_m3' ///
                                     _col(65) %4.3f `R_m4' _col(80) %4.3f `R_m5' _col(95) %4.3f `R_m6'
    
