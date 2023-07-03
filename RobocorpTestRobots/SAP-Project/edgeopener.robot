***Settings***
Documentation       Template robot main suite.
Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library     RPA.Desktop
Library     RPA.Windows
Library     RPA.Desktop.Windows

*** Variables ***
${crm_site}     https://www.google.com
${crm_userfield}     xpath://*[@id="login"]
${crm_passfield}    xpath://*[@id="password"]
${crm_user}     mohammed@sociusus.com
${crm_pass}     Test@123
# ${login_btn}    xpath:/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/textarea
${login_btn}    xpath:/html/body/fluent-design-system-provider/edge-chromium-page//div[5]/cs-header-core//div[1]/div[2]/welcome-greeting//div
${timesheet_head}   xpath://*[@id="sidebar"]/li[5]/a
${create_btn}    xpath://button[@accesskey='c' and contains(text(),'Create')]
${desc_field}   xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[1]/tbody/tr[2]/td[2]/input
${project_field}    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[1]/tbody/tr[3]/td[2]/div/div/input
${dropdown_list}    xpath://*[@id="ui-id-1"]
${time}             xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div/div/div/table[2]/tbody/tr[2]/td[2]/input
${save}     xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/div[2]/button[1]

***Tasks***  
opne crm
    Open CRM

***Keywords***
Open CRM
    Windows Run     microsoft-edge://
    Sleep   2
    # Open Available Browser     ${crm_site}      #-----------worked
    # Maximize Browser Window     #-----------worked
    # sleep   3       #-----------worked
    # Input Text   	 ${crm_userfield}   ${crm_user}
    # Input Text   	 ${crm_passfield}   ${crm_pass}
    # sleep   1
    # Click Element 	 ${login_btn}       #-----------worked
    # sleep   1
    # Click Element 	 ${timesheet_head} 
    # sleep   3
    # Click Element 	 ${create_btn}
    # sleep   3
    # Input Text       ${desc_field}      External Reconciliation Using RPA Success
    # Input Text 	     ${project_field} 	 SAP - RPA Roboccorp Development
    # sleep   2
    # Click Element 	 ${dropdown_list}
    # Input Text 	     ${time} 	 08.00 
    # sleep   2
    # Click Element 	 ${save}
    # sleep   1
    # Click Element 	 ${timesheet_head} 
    # sleep   3
    # Close Browser