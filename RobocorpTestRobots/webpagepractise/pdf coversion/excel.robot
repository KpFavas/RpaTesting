*** Settings ***
Library    RPA.Excel.Files
Library    RPA.Crypto
*** Variables ***
${path}    data.xlsx

*** Tasks ***
mainp
   example
   
*** Keywords ***
example
    Open Workbook    MOCK_DATA.xlsx
    Set Active Worksheet    dilli
    ${sheet}    List Worksheets
    Log To Console    ${sheet}
    ${sheet1}    Get Active Worksheet
    Log To Console    ${sheet1}
    ${read}    Read Worksheet As Table    dilli    ${False}    ${None}    ${None}
    Log To Console    ${read}
    ${read1}    Get Cell Value    1    1
    Log To Console    ${read1}
    ${read2}    Read Worksheet
    Log To Console    ${read2}
    # Insert Image To Worksheet    3    3    page.png
    Delete Rows    3    30
    Encrypt File    MOCK_DATA.xlsx    
    Set Active Worksheet    data

    Save Workbook    MOCK_DATA.xlsx

