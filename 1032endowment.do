*** do 1032endowment

local do "1032"
local tag "$tag/`do'" 

 ** Average endowment from 07-12

    local oldvar "end13 end12 end11 end10 end09 end08 end07"
    local newvar "endow0712"
    local varlab "Average endowment in $ per student, 07-12"
    global addvars "$addvars `newvar'"
    alpha `oldvar', gen(`newvar')
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Average endowment in $ per (full-time) student ///
         from 07-12. The endowment amount for each year (07, 08, 09, 10, 11, ///
         and 12) was measured at the END of each fiscal year. These six years /// 
         most closely correspond to our focal years (which are academic years, ///
         not fiscal years). | `tag'

    local newvar "endow0712K"
    local varlab "Average endowment in $1000 per student, 07-12"
    global addvars "$addvars `newvar'"
    gen `newvar' = endow0712/1000
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Average endowment in $1000 per (full-time) student ///
         from 07-12. The endowment amount for each year (07, 08, 09, 10, 11, ///
         and 12) was measured at the END of each fiscal year. These six years /// 
         most closely correspond to our focal years (which are academic years, ///
         not fiscal years). | `tag'

    local oldvar "endow0712K"
    local newvar "lnendow0712K"
    local varlab "Logged average endowment in $1000 per student, 07-12"
    global addvars "$addvars `newvar'"
    gen `newvar' = ln(`oldvar'+.01)
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Natural log of average endowment in $1000 per ///
         (full-time) student from 07-12. See notes for [`oldvar']. | `tag'

    codebook endow0712 endow0712K lnendow0712K `oldvar', compact
    sum endow0712 endow0712K lnendow0712K `oldvar' if pellgap<.
