*** do 1049cost

local do "1049"
local tag "$tag/`do'" 

*** Cost

    codebook outuitfee13 intuitfee13 lowincnetpric, compact 

 ** Tuition & fees

  * Out-of-state, 13-14, in $K

    local oldvar "outuitfee13"
    local newvar "outfee13K"
    local varlab "Out-of-state tuition+fees 13-14 in K"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/1000
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] `varlab'. / `tag'
   
  * In-state, 13-14, in $K
    
    local oldvar "intuitfee13"
    local newvar "infee13K"
    local varlab "In-state tuition+fees 13-14 in K"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/1000
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] `varlab'. / `tag'

    sum outfee13K infee13K
    
 ** Averaged net price for low income students (0-30K) for 08-13 in K
 
    sum np_lowinc_1213 np_lowinc_1112 np_lowinc_1011 np_lowinc_0910 np_lowinc_0809 if Private==0
    sum np_lowinc_1011 if Private==0 & np_lowinc_1011<0

    foreach var of varlist np_lowinc_1213 np_lowinc_1112 np_lowinc_1011 np_lowinc_0910 np_lowinc_0809 {
        di
        di "===> `var' for private schools"
        sum `var' if Private==1
        sum `var' if Private==1 & `var'>=0
        sum `var' if Private==1 & `var'<0
    }        

    sum np_lowinc_1213 np_lowinc_1112 np_lowinc_1011 np_lowinc_0910 np_lowinc_0809 if Private==1
    sum np_lowinc_1011 if Private==1 & np_lowinc_1011<0
    sum np_lowinc_0910 if Private==1 & np_lowinc_0910<0
    sum np_lowinc_0809 if Private==1 & np_lowinc_0809<0

    list unitid instnm Private np_lowinc_1213 np_lowinc_1112 np_lowinc_1011 np_lowinc_0910 np_lowinc_0809 /// 
        if np_lowinc_1011<0 | np_lowinc_0910<0 | np_lowinc_0809<0, clean noob

    foreach var of varlist np_lowinc_1213 np_lowinc_1112 np_lowinc_1011 np_lowinc_0910 np_lowinc_0809 {
        gen N`var' = `var'/1000
    }

    local newvar "np_linc0813K"
    local varlab "08-13 net price in K for low income"
    global addvars "$addvars `newvar'"
    alpha Nnp_lowinc_1213 Nnp_lowinc_1112 Nnp_lowinc_1011 Nnp_lowinc_0910 Nnp_lowinc_0809, gen(`newvar')
    lab var `newvar' "`varlab'"

    note `newvar': [`oldvar'] Averaged net price for low income students (0-30K) /// 
         for 08-13 in K (including 12-13 but not 13-14). | `tag'

    note `newvar': In the addvar4.dta file, we have a total price measure that /// 
         corresponds to the low income net price major, for all relevant years. /// 
         This measure is the *full* cost of college (tuition, living, books, /// 
         etc.). According to Laura, the net price for low income students is /// 
         this, minus the scholarships and grants offered to students in the /// 
         0-30K range that reduce the price. | `tag'

    note `newvar': [np_lowinc_1011] 3 public schools & 2 private schools have /// 
         negative values. [np_lowinc_0910] 2 private schools have negative /// 
         values. [np_lowinc_0809] 1 private schools have negative values. /// 
         In email 151119, Laura notes that it is possible to have a negative /// 
         net price, as sometimes scholarships and grants are more than the /// 
         total cost. Schools do that in some cases to offer students a bit /// 
         of spending money beyond the basic costs of living (e.g., money to go /// 
         home over break). And some of those schools are NOT surprising me /// 
         (Berea especially). So, these are in all likelihood legitimate values. | `tag' 
         
    sum Nnp_lowinc_1213 Nnp_lowinc_1112 Nnp_lowinc_1011 Nnp_lowinc_0910 Nnp_lowinc_0809 `newvar'

    note Anotes: For cost, sticker price could be useful as a control for the /// 
         prestige of the university. Typically speaking, as the price goes up, /// 
         so does prestige. Either outiotfee13 or intuitfee13 (out-of-state and /// 
         in-state tuition, respectively) capture this. We agree that in-state /// 
         price makes more sense, since low-income students are less likely to /// 
         go after out-of-state schools because of higher out-of-state price. | `tag' 
    
    note Anotes: However, we also agree that low income net price is a better ///
         cost control. So, we will use low income net price [np_linc0813K], /// 
         and keep sticker price [outfee13K infee13K] available just in case. | `tag' 
