*** Settings ***

Library    RPA.Desktop.Windows
Library    RPA.Desktop

*** Variables ***
${url}    mstsc.exe
${title}    Remote Desktop Connection
${url1}    SAP Business One.exe
${url2}    C:\\Program Files\\SAP\\SAP Business One\\SAP Business One.exe
${url3}    C:\Program Files\SAP\SAP Business One\SAP Business One.exe
${title1}    SAP Business One Client (64-bit)
*** Tasks ***
maincase
    open remotedesktop

*** Keywords ***
open remotedesktop    
    Open Executable    ${url}    ${title}    
    Mouse Click    id:1
    Sleep    15