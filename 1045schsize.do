*** do 1045schsize

local do "1045"
local tag "$tag/`do'" 

 ** Institution size 2013

    tab instsize, m
    
    local oldvar "instsize"
    local newvar "schsize"
    local varlab "Institution size 2013"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Institution size, total enrolled in 2013. 1 = /// 
         Under 1,000, 2 = 1,000-4,999, 3 = 5,000-9,999, 4 = 10,000-19,999, 5 = /// 
         20,000 and above. | `tag'

    tab `newvar', m

 ** Institution size, 07-12 & 07-13

    des totenrl totenrl13 totenrl12 totenrl11 totenrl10 totenrl09 totenrl08 totenrl07 
    sum totenrl totenrl13 totenrl12 totenrl11 totenrl10 totenrl09 totenrl08 totenrl07 

    local newvar "schsize0713"
    local varlab "Institution size 07-13"
    global addvars "$addvars `newvar'"
    alpha totenrl totenrl12 totenrl11 totenrl10 totenrl09 totenrl08 totenrl07, gen(`newvar')
    lab var `newvar' "`varlab'"

    note `newvar': Institution size measured as the averaged total enrolled /// 
    	 07-13. The enrollment measure from 2013 is drawn from the PIF dataset, /// 
    	 which updated the 2013 value for enrollment from IPEDS around Sep 15 /// 
    	 thus has more accurate information. | `tag'

    local newvar "schsize0712"
    local varlab "Institution size 07-12"
    global addvars "$addvars `newvar'"
    alpha          totenrl12 totenrl11 totenrl10 totenrl09 totenrl08 totenrl07, gen(`newvar')
    lab var `newvar' "`varlab'"
    replace `newvar' = schsize0713 if `newvar'>=. & schsize0713<.
    
    note `newvar': Institution size measured as the averaged total enrolled 07-12. | `tag'
    note `newvar': When we missing 07-12, we use 2013-2014 data to impute if /// 
         the information is available. | `tag'

    local oldvar "schsize0712"
    local newvar "schsize0712K"
    local varlab "Institution size 07-12 in K"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/1000
    lab var `newvar' "`varlab'"
    
    note `newvar': Institution size in 1000 measured as the averaged total enrolled 07-12. See notes in [schsize0712]. | `tag'

    sum totenrl totenrl12 totenrl11 totenrl10 totenrl09 totenrl08 totenrl07 schsize0712 schsize0712K schsize0713, sep(7)

