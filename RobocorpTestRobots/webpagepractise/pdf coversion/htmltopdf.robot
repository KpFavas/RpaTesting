*** Settings ***
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.HTTP
Library           RPA.PDF
*** Variables ***


*** Tasks ***
pdf html convertor
    Open Available Browser    https://testautomationpractice.blogspot.com/    maximized=${True}
    Sleep    3
    first

*** Keywords ***
first
    Wait Until Element Is Visible    xpath://*[@id="HTML1"]/div[1]/table/tbody
    ${sales_results_html}=    Get Element Attribute    xpath://*[@id="HTML1"]/div[1]/table/tbody    outerHTML
    Capture Element Screenshot    xpath://*[@id="HTML1"]/div[1]/table/tbody    ${CURDIR}\\table.png  
     ${sales_results_html}=    Get Element Attribute    xpath://*[@id="HTML1"]/div[1]/table/tbody/tr[1]    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf