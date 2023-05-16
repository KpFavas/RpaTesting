***Settings***
Documentation       Template robot main suite.
Library    RPA.Windows
Library    RPA.Desktop.Windows
Library    RPA.Desktop
***Variables***
${rdp}           mstsc.exe
${rdp_title}     Remote Desktop Connection
${ip_address}    Socius.sapserver.in:24242
${input_ip}      5012
${connect_btn}   1
${app_name}      SAP Business One.exe

*** Keywords ***
running sap application
     RPA.Desktop.windows.Send keys     Favas
     RPA.Desktop.Press Keys    tab
     RPA.Desktop.windows.Send keys     Test@123
     Press Keys    enter   
     Sleep    2
     Press Keys    enter

***Tasks***
Open Remote Desktop 
    Windows Run     ${rdp}  
mstsc.exe
    Control Window     ${rdp_title}
    RPA.windows.Send Keys    id:${input_ip}     ${ip_address}
    RPA.Windows.Click       id:${connect_btn}
    sleep   10
    
Open Application In RDP
    sleep   5
    ${status}=    Run Keyword And Return Status    Windows Run    ${app_name}
    Run Keyword If    ${status}==True    Log    Application ${app_name} opened successfully
    ...    ELSE    Log    Failed to open application ${app_name}
    sleep   3
    running sap application
    #closing sap b1
    sleep    2
    Press keys    ctrl  q
    sleep    2
    Press keys    enter
    



