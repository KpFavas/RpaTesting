*** Settings ***
Documentation       Template robot main suite.

Library    RPA.Browser.Selenium    auto_close=${False}   

*** Tasks ***
Main Task Running
    browser in Chrome
    Entering data Test


*** Keywords ***
 browser in Chrome
    Open Available Browser    https://testautomationpractice.blogspot.com/    maximized=${True}
Entering data Test
    #Input Text    id:RESULT_TextField-1   dillibabu
    Click Button    xpath://button[contains(text(),'Click Me')]
    Handle Alert    ACCEPT
    Click Button    xpath://button[contains(text(),'Click Me')]
    Handle Alert    DISMISS
    Input Text    id:datepicker    03/15/2023
    Select From List By Index    id:speed    3
    #Select Checkbox    id:CheckBox-0
    Double Click Element    xpath://button[contains(text(),'Copy Text')]
    Drag And Drop    id:draggable    id:droppable
     Sleep    3
    Go To    https://demo.automationtesting.in/Register.html
    Input Text    xpath://*[@id="basicBootstrapForm"]/div[1]/div[1]/input    dilli
    Input Text    xpath://*[@id="basicBootstrapForm"]/div[1]/div[2]/input    babu
    Input Text    xpath://*[@id="eid"]/input    dillibabuinfo@gmail.com
    Select Radio Button    radiooptions    Male
    Select Checkbox    id:checkbox1
    Select Checkbox    id:checkbox3
    Select From List By Value    id:Skills    Android
    Select From List By Value    id:yearbox    2001
    Select From List By Value    xpath://*[@id="basicBootstrapForm"]/div[11]/div[2]/select    April
    Select From List By Value    id:daybox    4
    Input Password    id:firstpassword    password
    Input Password    id:secondpassword    password
    Screenshot    xpath://*[@id="header"]/div/div/div/div[2]/h1    t.png
    Capture Element Screenshot    xpath://*[@id="header"]/div/div/div/div[2]/h1    t1.png
    Capture Page Screenshot    page.png    
    Choose File    id:imagesrc    ${CURDIR}/page.png
    Submit Form
   