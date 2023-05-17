***Settings***
Documentation       Template robot main suite.
Library    RPA.Browser.Selenium    auto_close=${FALSE}

*** Variables ***
${crm_site}     https://crm.sociusus.com/web#view_type=kanban&model=account.analytic.line&action=208
${crm_userfield}     xpath://*[@id="login"]
${crm_passfield}    xpath://*[@id="password"]
${crm_user}     sooraj@sociusus.com
${crm_pass}     Sooraj@2227
${login_btn}    xpath:/html/body/div/div/form/div[3]/button
${timesheet_head}   xpath://*[@id="sidebar"]/li[5]/a
${create_btn}    xpath://button[@accesskey='c' and contains(text(),'Create')]
${desc_field}   xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[1]/tbody/tr[2]/td[2]/input
${project_field}    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[1]/tbody/tr[3]/td[2]/div/div/input
${dropdown_list}    xpath://*[@id="ui-id-1"]
${time}             xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[2]/tbody/tr[2]/td[2]/input
${save}     xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/div[2]/button[1]

${ed_last_entry}    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div[1]
${ed_action}    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[3]/button
${ed_delete_btn}    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[3]/ul/li[1]/a
${ed_delete_cnfrm}      xpath:/html/body/div[8]/div/div/div[3]/button[1]

***Tasks***  
opne crm
    Open CRM

***Keywords***
Open CRM
    Open Available Browser     ${crm_site}
    Maximize Browser Window
    sleep   1
    Input Text   	 ${crm_userfield}   ${crm_user}
    Input Text   	 ${crm_passfield}   ${crm_pass}
    sleep   1
    Click Element 	 ${login_btn}
    sleep   1
    Click Element 	 ${timesheet_head} 
    sleep   3
    Click Element 	 ${ed_last_entry}
    Sleep   1
    Click Element 	 ${ed_action}
    Sleep   1
    Click Element 	 ${ed_delete_btn}
    Sleep   2
    Click Element 	 ${ed_delete_cnfrm}
    Sleep   3
    Click Element 	 ${timesheet_head}
    sleep   3
    Close Browser