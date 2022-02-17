*** do 1031private

local do "1031"
local tag "$tag/`do'" 

 ** Private vs. public schools

    tab sector control, m
    local oldvar "control"
    local newvar "Private"
    local varlab "1.Private/0.Public"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'==2
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Private university = 1, Public = 0. | `tag'
    lab val `newvar' Private
    tab `oldvar' `newvar', m

