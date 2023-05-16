***Settings***
Library    RPA.Windows
Library     RPA.Desktop.Windows
Library     RPA.Desktop

***Variables***
${rdp}           mstsc.exe
${rdp_title}     Remote Desktop Connection
${ip_address}    Socius.sapserver.in:24242
${input_ip}      5012
${connect_btn}   1
${app_name}      SAP Business One.exe

***Tasks***
Open Remote Desktop 
    Windows Run     ${rdp}  
    Control Window     ${rdp_title}
    RPA.Windows.Send Keys    id:${input_ip}     ${ip_address}
    RPA.Windows.Click       id:${connect_btn}
    sleep   10
Open Application In RDP
    sleep   5
    ${status}=    Run Keyword And Return Status    Windows Run    ${app_name}

    Run Keyword If    ${status}==True    Log    Application ${app_name} opened successfully
    ...    ELSE    Log    Failed to open application ${app_name}
    sleep   3
    RPA.Desktop.Windows.Send Keys   Favas
    Press Keys    tab   
    RPA.Desktop.Windows.Send Keys   Test@123
    sleep   2
    Press keys  enter
    sleep   5
    Press Keys  ESC
    sleep   4
    # ${statuss}=    Run Keyword And Return Status    Click    Sales
    
    # Press keys  ctrl    q
    # Press Keys  enter