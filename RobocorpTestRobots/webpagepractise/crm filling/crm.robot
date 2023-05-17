*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Archive
Library    RPA.FileSystem
Library    RPA.Desktop.Windows
*** Variables ***
# ${user}    dillibabu@sociusus.com
# ${password}    Test@123
# ${value1}    verifying additional requirements points and fixing bugs
# ${value2}    SAP - Department wise stock management AB Innovation
# ${value3}    04:00
# ${value4}    SAP - RPA Roboccorp Development 
# ${password1}    PAVIthra@123

${create_btn}   xpath:/html/body/div[1]/div[2]/div[1]/div[2]/div[1]/div/button[1]



*** Tasks ***

# crm running
#     crm filling
crm open 
    open Available Browser      



*** Keywords ***

