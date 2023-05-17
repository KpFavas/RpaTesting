*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Archive
Library    RPA.FileSystem
Library    RPA.Desktop.Windows
*** Variables ***
${user}    dillibabu@sociusus.com
${password}    Test@123
${value1}    verifying additional requirements points and fixing bugs
${value2}    SAP - Department wise stock management AB Innovation
${value3}    04:00
${value4}    SAP - RPA Roboccorp Development 
${password1}    PAVIthra@123
${EXCEL_FILE_URL}    https://docs.google.com/spreadsheets/d/1RumbcuBueMlpA22kWq07_ilHdGBsglmh88yTv0mzphY/edit#gid=0
*** Tasks ***
main class
#    Drag and drop1
#    Text comparison
    #Switch Frames
    #Selectable
    #archieves
    #cms Register
    Excel filling online
    #Excel online
*** Keywords ***
Drag and drop1
    #  Open Available Browser    http://dhtmlgoodies.com/scripts/drag-drop-custom/demo-drag-drop-3.html
    # Drag And Drop    id:box6    id:box106
    # Drag And Drop    id:box7    id:box107
    # Sleep    3
Text comparison
    Go To    https://text-compare.com/
    Execute Javascript    window.scrollTo(0,400)
    Input Text    id:inputText1    dillibabu
    #Press Keys    None    Tab
    Input Text    id:inputText2    dillibabu
    Click Button    id:compareButton
    Sleep    3
Switch Frames
      Open Available Browser    https://demo.automationtesting.in/Frames.html    maximized=${True}
      #Select Frame    /html/body/section/div/div/div/input
      Input Text    xpath://input[@type='text']    dillibabu  
Selectable
    Open Available Browser    https://demo.automationtesting.in/Selectable.html    maximized=${True}
     Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[1]
     Sleep    2
      Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[2]
      Sleep    2
       Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[3]
        Sleep    2
       Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[4]
        Sleep    2
       Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[5]
        Sleep    2
       Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[6]
        Sleep    2
       Click Element    xpath:/html/body/div[1]/div/div/div/div[2]/div[1]/ul/li[7]
archieves
    # Archive Folder With Zip    C:\\Users\\sigb\\Desktop\\sap-sql    dillibabu1431.Zip    ${True}
    # Extract Archive    dillibabu1431.Zip    ${CURDIR}\\dj    
    #Add To Archive    ${CURDIR}//dj//objtype.txt   dillibabu1431.zip
    #Extract Archive    dillibabu1431.zip    ${CURDIR}//dilli143
    #Remove File    ${CURDIR}//dilli143
cms Register
     Open Available Browser    https://crm.sociusus.com/web/login    maximized=${True} 
     Input Text    id:login    ${user} 
     Input Password    id:password    ${password}
     Click Button    xpath:/html/body/div/div/form/div[3]/button
     Click Element    xpath://*[@id="sidebar"]/li[5]/a/span
     Sleep    2
     Click Element    xpath:/html/body/div[1]/div[2]/div[1]/div[3]/div[3]/button[2]
     Sleep    2
     Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/button[1]
     Sleep    2
     Input Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[3]/input    ${value1}
     Sleep    1
     Input Text   xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input    ${value4}
      Mouse Down    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input
      Click Element    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div   
     #Press Keys    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input    ${value2} 
      #Press Keys    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input     ${value4}
      #Select From List By Value    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]    ${value2}
    #   Click Element    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input
    # Wait Until Element Is Visible    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]/div/div/input
    # Sleep    1
    # Click Element    xpath://a[contains(text(),'Search More...')]
    # Sleep    2
    # Input Text    xpath://*[@id="modal_209"]/div/div/div[2]/div[1]/div[1]/input    ${value2}
    #Select From List By Label   xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[4]    ${value2}
     Sleep    1 
     Input Text    xpath:/html/body/div[1]/div[2]/div[2]/div/div/div/table/tbody/tr[1]/td[6]/input    ${value3}
     Sleep    3
     Click Button    xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/button[3]
     
Excel filling online
    Open Available Browser    https://docs.google.com/spreadsheets/d/1RumbcuBueMlpA22kWq07_ilHdGBsglmh88yTv0mzphY/edit#gid=0    maximized=${True}
    Input Text    xpath://*[@id="identifierId"]    ${user}
    Sleep    1
    Click Element   xpath://*[@id="identifierNext"]/div/button/span
    Sleep    3
    Input Password    xpath://*[@id="password"]/div[1]/div/div[1]/input    ${password1}
    Click Element    xpath://*[@id="passwordNext"]/div/button/span
    Sleep    3
    Go To    https://docs.google.com/spreadsheets/d/1RumbcuBueMlpA22kWq07_ilHdGBsglmh88yTv0mzphY/edit#gid=100380776
    Sleep    1
    Go To    https://docs.google.com/spreadsheets/d/1RumbcuBueMlpA22kWq07_ilHdGBsglmh88yTv0mzphY/edit#gid=100380776&range=E5 
