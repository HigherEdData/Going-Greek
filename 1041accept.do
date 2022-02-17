*** do 1041accept

local do "1041"
local tag "$tag/`do'" 

 ** Acceptance % 2013
 
    local oldvar "accept"
    local newvar "Naccept13"
    local varlab "Acceptance % in 2013"
    global addvars "$addvars `newvar'"

    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Acceptance % 13 (admitted students/applicants Fall /// 
         2013). 72 schools have missing values. | `tag'

 ** Averaged acceptance % 07-12

    local newvar "Accept0712"
    local varlab "Avg acceptance % 07-11"
    global addvars "$addvars `newvar'"

    alpha accept12 accept11 accept10 accept09 accept08 accept07, gen(`newvar')
    lab var `newvar' "`varlab'"
    note `newvar': Averaged acceptance % 07-12. | `tag'
    note `newvar': We do NOT use the 2013 acceptance rate, because that is /// 
         technically academic year 13-14. This is confirmed from Laura's email ///
         on 11/19/2015. | `tag'
    
