***Settings***
Library     RPA.Desktop
Library     RPA.Windows
Library     RPA.Desktop.Windows



***Variables***
${skype_exe}    Skype.exe
${title}        Skype
${search_bar}   People
${firstrow}     id:rx-vlv-8

***Tasks***

Open Skype Application
    
    Open Executable     ${skype_exe}    ${title}
    Sleep    4
    Press Keys    ctrl    n
    Sleep    3
    Type Keys    Subin
    
    Sleep    3
    Press Keys  tab
    Press Keys  tab
    Press Keys  enter
    Sleep   3
    Type Keys    HI, How are you?
    Sleep   2
    Press Keys    ENTER 
    Sleep    4
    RPA.Windows.Click       ${firstrow}
    Sleep   2
    Press Keys    ctrl    n
    Sleep    3
    Type Keys    Ancy
    Sleep    3
    Press Keys  tab
    Press Keys  tab
    Press Keys  enter
    Sleep   3
    Type Keys    HI, How are you?
    Sleep   2
    Press Keys    ENTER 
    
    