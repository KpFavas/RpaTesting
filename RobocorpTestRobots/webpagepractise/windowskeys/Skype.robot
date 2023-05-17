*** Settings ***
Library    RPA.Desktop.Windows
Library    RPA.Desktop
Resource    skypenames.robot

*** Tasks ***
Open Skype and send Data
    Open Executable    skype.exe    Skype [1]
    Sleep    5
    Press Keys    ctrl    n
    Sleep    2
    Type Keys    ${sivaji}
    Sleep    3
    Type Keys    ${data}
    Press Keys    ENTER 
    Press Keys    down
    Sleep    2
     Press Keys     ctrl    q


    
