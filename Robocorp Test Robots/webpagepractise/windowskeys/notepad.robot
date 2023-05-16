*** Settings ***
Library    RPA.Desktop.Windows
Library    RPA.Desktop
Library    RPA.SAP
*** Variables ***
${data}         task sddsada assdas aasdsad

*** Tasks ***
Open Notepad and Write Data
    Open Executable    notepad.exe    Notepad
    Type Keys    ${data}
    Press Keys     ctrl    
    ...    s
    Press Keys    enter
    Sleep    3
    Press Keys    left
     Press Keys    enter
    Press Keys     ctrl    w