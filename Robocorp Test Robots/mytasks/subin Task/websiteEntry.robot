
*** Settings ***
Documentation       Template robot main suite.
Library    RPA.Browser.Selenium    auto_close=${FALSE}

***Variables***

${user}     xpath:/html/body/div[1]/main/div/div/div[2]/div/div/form/input[2]
${pass}     xpath:/html/body/div[1]/main/div/div/div[2]/div/div/form/input[3]
${Submit}   xpath:/html/body/div[1]/main/div/div/div[2]/div/div/form/button
${sidebar}  xpath:/html/body/header/nav/div[1]/li
${hm}       xpath:/html/body/header/div/div/ul/li[19]/a
${patincbtn}   xpath:/html/body/header/nav/div[1]/div/a[4]
${createbtn}    xpath:/html/body/div[1]/div/div[1]/div[2]/div[1]/div/div/button[3]
${patnc_field}  xpath:/html/body/div[1]/div/div[2]/div/div[1]/div[2]/div[3]/table[1]/tbody/tr[1]/td[2]/div/div[1]/div/input
${date_field}  xpath:/html/body/div[1]/div/div[2]/div/div[1]/div[2]/div[3]/table[1]/tbody/tr[2]/td[2]/div/input[1]
${dateselect_field}  xpath:/html/body/div[15]/div[2]/div[1]/table/tbody/tr[5]/td[6]
${dateapply_field}  xpath:/html/body/div[15]/div[4]/button[2]



*** Tasks ***    #functions will call here
Open WebBrowser
    Open a Browser
Login Step
    Fill Login Data

Data Entry
    Fetch and Fill From Excel



*** Keywords ***    #like functions
Open a Browser
    Open Available Browser    http://159.65.152.114:8072/web/login
    Maximize Browser Window

Fill Login Data
    Click Element   ${user}
    Input Text      ${user}    admin
    Click Element   ${pass}
    Input Text      ${pass}    admin@321
    Click Element   ${Submit}
    sleep   2
    Click Element   ${sidebar}
    sleep   2
    Click Element   ${hm}
    sleep   2
    Click Element   ${patincbtn}
    sleep   2
    Click Element   ${createbtn}
    sleep   3
    Input Text   ${patnc_field}     Dobby Kim
    # Click Element   xpath:/html/body/div[2]/div[5]/div/div/div/footer/button[1]
    Input Text   ${date_field}     2017-01-01
    Select From DropDown   ${dateselect_field}
    Click Element   ${dateapply_field}
    sleep   1
    
    
    

