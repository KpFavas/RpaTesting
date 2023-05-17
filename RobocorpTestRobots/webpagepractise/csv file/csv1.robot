*** Settings ***

Library    RPA.Tables
Library    OperatingSystem

*** Variables ***


*** Tasks ***
main class
    ${v}    Read table from CSV    MOCK_DATA.CSV    header=${True}    
    Log To Console    ${v}
    Write table to CSV    ${v}    data.csv 
    Log To Console    ${CURDIR}
    ${v3}    Get File Size    C:\\Users\\sigb\\Desktop\\RPA\\sample projects\\webpagepractise\\MOCK_DATA.xlsx
    Log To Console    ${v3}
   ${vv}    Get File    C:\\Users\\sigb\\Desktop\\RPA\\sample projects\\webpagepractise\\MOCK_DATA.xlsx    encoding=UTF-8
   Log To Console    ${vv}
*** Keywords ***
