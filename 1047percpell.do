*** do 1047percpell

local do "1047"
local tag "$tag/`do'" 

 ** % Pell on campus
    
    tab percpell, m

    local oldvar "percpell"
    local newvar "pellper1213"
    local varlab "% Pell recipients among undergrad 12-13"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/100
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] % Pell Recipients among Undergraduates 12-13, from PIF2. | `tag'

 ** Average % Pell recipients among undergrad & and 07-13

    local newvar "pellper0713"
    local varlab "% Pell recipients among undergrad 07-12"
    global addvars "$addvars `newvar'"
    alpha percpell_1213 percpell_1112 percpell_1011 percpell_0910 percpell_0809 percpell_0708, gen(`newvar')
    note `newvar': Average % Pell Recipients among Undergraduates 07-13, from [addvar2]. | `tag'

    local newvar "pellper0712"
    local varlab "% Pell recipients among undergrad 07-12"
    global addvars "$addvars `newvar'"
    alpha               percpell_1112 percpell_1011 percpell_0910 percpell_0809 percpell_0708, gen(`newvar')
    lab var `newvar' "`varlab'"
    note `newvar': Average % Pell Recipients among Undergraduates 07-12, from [addvar2]. | `tag'

    sum percpell_1213 percpell_1112 percpell_1011 percpell_0910 percpell_0809 percpell_0708 pellper0712 pellper0713, sep(6)

