*** do 1003notevars

local do "1003"
local tag "$tag/`do'" 

*** Note variables
 ** Preparation: 1) Value lables, 2) Variables to save notes, 3) Local for new variables 

    lab def yes 1 "yes" 0 "no" .d "don't know" .i "refused" .n "no answer"
    lab def Private 1 "Private" 0 "Public"
    numlabel, add

    gen Findnotes = .
    lab var Findnotes "Findings notes"
    note Findnotes: Variable to store the findings notes. | `tag'

    gen Anotes = .
    lab var Anotes "Analysis notes"
    note Anotes: Variable to store the analysis notes. | `tag'

    gen Qnotes = .
    lab var Qnotes "Question notes"
    note Qnotes: Variable to store the question notes. | `tag'

    gen Samplenotes = .
    lab var Samplenotes "Sample size notes"
    note Samplenotes: Variable to store sample selection notes. | `tag'

    global addvars "unitid instnm Findnotes Anotes Qnotes Samplenotes"

