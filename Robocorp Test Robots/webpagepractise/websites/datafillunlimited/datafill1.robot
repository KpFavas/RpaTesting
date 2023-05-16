*** Settings ***

Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Excel.Files
Library    RPA.PDF
Library    RPA.Desktop

*** Tasks ***
datafill
    open website
    fetch datafill
    get pdf
*** Keywords ***
open website
    Open Available Browser    https://www.rpa-unlimited.com/youtube/robocorp-tutorial/index.php

filldata
    [Arguments]    ${company}
    Input Text    id:company-name    ${company}[Company Name]
    Input Text    id:company-contact    ${company}[Contact Person]
    Input Text    id:address    ${company}[Address]
    Input Text    id:zipcode    ${company}[Zipcode]
    Input Text    id:city    ${company}[City]
    Input Text    id:country    ${company}[Country]
    Input Text    id:telephone    ${company}[Telephone]
    Input Text    id:email    ${company}[Email]
    Submit Form
    Sleep    1
fetch datafill    
    # Open Workbook    MOCK_DATA.xlsx
    # ${companies}    Read Worksheet As Table    header=${True}
    # Close Workbook
    # FOR    ${company}    IN    @{companies}
    #  filldata    ${company}
    # END
     Open Workbook    input.xlsx
    ${companies}    Read Worksheet As Table    header=${True}
    Close Workbook
    FOR    ${company}    IN    @{companies}
     filldata    ${company}
    END
get pdf
    # Wait Until Element Is Visible    xpath://*[@id="about"]/div/table    
    # ${get details}=    Get Element Attribute    xpath://*[@id="about"]/div/table    outerHTML  
    # Html To Pdf    ${get details}    ${OUTPUT_DIR}${/}MOCK_DATA.pdf  
    Sleep    5 
     Wait Until Element Is Visible    xpath://*[@id="about"]/div/table
     Screenshot    xpath://*[@id="about"]/div/table    ${CURDIR}\\dilli1.png    
     Capture Page Screenshot    ${CURDIR}\\page1.png    
     Capture Element Screenshot    xpath://*[@id="about"]/div/table    ${CURDIR}\\element1.png
    # ${sales_results_html}=    Get Element Attribute    xpath://*[@id="about"]/div/table/thead    outerHTML
    # Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}MOCK_DATA.pdf 