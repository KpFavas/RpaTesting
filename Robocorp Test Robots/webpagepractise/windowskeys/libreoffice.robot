*** Settings ***
Library    RPA.Desktop.Windows
Library    RPA.Desktop
*** Variables ***
${data}         This is some example text of the dsfdsf dill

*** Tasks ***
Open Notepad and Write Data
    Open Executable    C:\\Program Files\\LibreOffice\\program\\scalc.exe    LibreOffice Calc 
    Type Keys    ${data}
    Press Keys    Tab
    Type Keys    ${data}
    Press Keys     ctrl    s
    Press Keys    enter
    Sleep    3
    Press Keys    left
     Press Keys    enter
    Press Keys     ctrl    w