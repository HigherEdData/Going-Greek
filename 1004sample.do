*** do 1004sample

local do "1004"
local tag "$tag/`do'" 

/*** How many schools do we have Ed Trust Pell grad rate data for that do not have parallel USN grad rate data?

 ** Source 1: US News and World Report

    tab sixgradpell, m
    tab sixgradnonps, m

    gen PellUSN = (sixgradpell<.)
    lab var PellUSN "Pell rates available in USN"
    lab val PellUSN yes
    tab PellUSN, m
    note PellUSN: Cases with available Pell grad rates from USN. | `tag'

 ** Source 2: Ed Trust data

    note pellgrad: This is from Ed Trust data. | `tag'
    note nonpellgrad: This is from Ed Trust data. | `tag'

    recode pellgrad -9999=.
    recode pellgrad -99=.

    recode nonpellgrad -9999=.
    recode nonpellgrad -99=.

    tab pellgrad, m
    tab nonpellgrad, m

    gen PellTrust = (pellgrad<.)
    lab var PellTrust "Pell rates available in Ed Trust"
    lab val PellTrust yes
    tab PellTrust, m
    note PellTrust: Cases with available Pell grad rates from Ed Trust. | `tag'

    tab PellTrust PellUSN, m
***/

*** Document the sample restrictions
    
    tab ccbasic, m
    local N = r(N)
    note Samplenotes: N = 1935 to begin with. | `tag'

 ** By type of schools

  * Remove predominately associates
 
    local reason "predominately associates"
    count if ccbasic==1
    local n = r(N)

    drop if ccbasic==1
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove theological seminaries

    local reason "theological seminaries"
    count if ccbasic==24 
    local n = r(N)

    drop if ccbasic==24 
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove medical schools and centers

    local reason "medical schools & centers"
    count if ccbasic==25 
    local n = r(N)

    drop if ccbasic==25 
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove other health professions schools

    local reason "other health professions schools"
    count if ccbasic==26 
    local n = r(N)

    drop if ccbasic==26 
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove schools of engineering

    local reason "schools of engineering"
    count if ccbasic==27 
    local n = r(N)

    drop if ccbasic==27 
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove other technology-related schools

    local reason "other technology-related schools"
    count if ccbasic==28
    local n = r(N)

    drop if ccbasic==28
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove schools of business and management*

    local reason "schools of business and management"
    count if ccbasic==29
    local n = r(N)

    drop if ccbasic==29
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove schools of art, music, and design*

    local reason "schools of art, music, and design"
    count if ccbasic==30
    local n = r(N)

    drop if ccbasic==30
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove schools of law

    local reason "schools of law"
    count if ccbasic==31
    local n = r(N)

    drop if ccbasic==31
    local N = `N' - `n'
    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

  * Remove other special focus institutions

    local reason "other special focus institutions"
    count if ccbasic==32
    local n = r(N)

    drop if ccbasic==32
    local N = `N' - `n'

 ** Remove schools with less than 500 students enrolled in 2013

    local reason "schools with less than 500 students enrolled in 2013"
    count if totenrl<500
    local n = r(N)

    drop if totenrl<500
    local N = `N' - `n'

    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

 ** Remove schools with no on-campus housing

    local reason "schools with no on campus housing"
    count if room==0
    local n = r(N)
    drop if room==0
    local N = `N' - `n'

    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

 ** Remove US service schools

    local reason "US service schools"
    count if region==0
    local n = r(N)

    drop if region==0
    local N = `N' - `n'

    note Samplenotes: N = `N', after drop `n' cases for: `reason'. | `tag'

 ** Remove the University of Texas-Pan American (unitid=227368) as a problematic case 

    local reason "a problematic case"
    count if unitid==227368
    local n = r(N)

    drop if unitid==227368
    local N = `N' - `n'

    note Samplenotes: N = `N', after drop `n' cases for: `reason'. Laura’s email on /// 
         01/25/16 notes that this school no longer exists. It was merged into /// 
         the new University of Texas Rio Grande Valley. This merge means it is /// 
         really hard to pull newer info, and the numbers about % Greek ranging ///
         up to 99 for men, and 100 for women were most certainly wrong. | `tag'

    note list Samplenotes
    tab ccbasic, m


