*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Archive
Library    RPA.FileSystem
Library    RPA.Desktop.Windows
Library    RPA.JSON
Library    OperatingSystem
Library    String
Library    RPA.Excel.Files
Library    RPA.Tables
*** Variables ***
${user}    mohammed@sociusus.com
${password}    Test@123
${file_path}    ${CURDIR}${/}crm.json
${value}    04-03-2023
*** Tasks ***
crm running
    mainpage
    navbar list
    crm filling
    #  delete record
    print document
    # delete all data
    #project all details

    #close Browser
*** Keywords ***
mainpage
    Open Available Browser    https://crm.sociusus.com/web/login    maximized=${True} 
     Input Text    id:login    ${user} 
     Input Password    id:password    ${password}
     Click Button    xpath:/html/body/div/div/form/div[3]/button
     Sleep    2
navbar list
     ${c}    Get Element Count    xpath://*[@id="sidebar"]/li/a/span
     FOR    ${counter}    IN RANGE    1    ${c}+1    
         ${d}    RPA.Browser.Selenium.Get Text    xpath://*[@id="sidebar"]/li[${counter}]/a/span
     Log To Console    ${d}
     END
crm filling
    ${data}    Get File  ${file_path}
    &{people}=    Convert string to JSON   ${data}
    ${json_data}  Evaluate  json.loads($data)
    ${fruits}  Set Variable  ${json_data["Task"]}
    ${count}  Evaluate  len($fruits)
    Click Element    xpath://*[@id="sidebar"]/li[5]/a/span
    Sleep    2
    Click Element    xpath:/html/body/div[1]/div[2]/div[1]/div[3]/div[3]/button[2]
    FOR    ${counter}    IN RANGE    0    ${count}   
        Sleep    2
        Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/button[1]
        Sleep    2
        ${description}=     Get value from JSON      ${people}   $.Task[${counter}].Description
        ${projectname}=     Get value from JSON      ${people}   $.Task[${counter}].projectname
        ${time}=     Get value from JSON      ${people}   $.Task[${counter}].time
        Input Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[3]/input    ${description}
        Sleep    1
        Input Text   xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input    ${projectname}
        Sleep    1
        Click Element At Coordinates    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input    xoffset=0    yoffset=30
        Sleep    1 
        Input Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[6]/input    ${time}
        Sleep    3
        Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/button[3]
    END
    Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[1]/div/div/div[2]
    
#  delete record
#     Sleep    1
#      ${table_bodies}  Get WebElements  xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr
#     ${count}  Get Length  ${table_bodies}
#     FOR    ${counter}    IN RANGE    1    ${count}+1    
#       ${d}    RPA.Browser.Selenium.Get Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[${counter}]/td[2]
#       ${d}    Replace String Using Regexp    ${d}    /    -
#      Run Keyword If    '${d}' == '${value}'    Select Checkbox    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[${counter}]/td[1]/div/input  
#     END
#        Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[2]/button 
#     Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[2]/ul/li[2]/a 
#     Sleep    1
#      Click Element If Visible    xpath:/html/body/div[6]/div/div/div[3]/button[1]/span
print document
    Sleep    1
    Select Checkbox    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/thead/tr/th[1]/div/input
    Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[1]/button
    Sleep    1
    Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[1]/ul/li/a
# delete all data
#     Sleep    1
#     Select Checkbox    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/thead/tr/th[1]/div/input
#      Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[2]/button 
#     Click Element If Visible    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[2]/div/div[2]/ul/li[2]/a 
#     Sleep    1
#      Click Element If Visible    xpath:/html/body/div[6]/div/div/div[3]/button[1]/span
# project all details
#     Sleep    2
#     Click Element If Visible    xpath://*[@id="sidebar"]/li[4]/a/span
#     Sleep    3
#     ${c}    Get Element Count    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div[@class='oe_kanban_color_0 oe_kanban_global_click o_has_icon o_kanban_record']
#     # create xlsx file set the project names
#     Create Workbook     ${CURDIR}//projectdetails.xlsx    
#     Save Workbook
#     Open Workbook     ${CURDIR}//projectdetails.xlsx
#      FOR    ${counter}    IN RANGE    1    ${c}+1    
#        ${d}    RPA.Browser.Selenium.Get Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div[${counter}]/div[1]/div/div/div/span 
#       Set Cell Value    ${counter}    1    ${d} 
#     END
#     Save Workbook
#     # creating table set projectnames
#     @{Table_Data_name}=    Create List    projectdetails 
#     ${projectdetails}    Create Table    ${Table_Data_name}        
#     FOR    ${counter}    IN RANGE    1    ${c}+1    
#        ${d}    RPA.Browser.Selenium.Get Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div[${counter}]/div[1]/div/div/div/span 
#        Add Table Row    ${projectdetails}    ${d}
#     END
#      FOR    ${counter}    IN RANGE    1    ${c}+1    
#       ${CC}    Get Table Row    ${projectdetails}    ${counter}
#       Log To Console    ${CC}
#     END


    # FOR    ${counter}    IN RANGE    1    ${c}+1    
    #    ${d}    RPA.Browser.Selenium.Get Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/div[${counter}]/div[1]/div/div/div/span 
    #    Log To Console    ${d}
    # END

