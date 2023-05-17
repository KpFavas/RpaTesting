*** Settings ***
Library    RPA.Excel.Application

*** Variables ***
${file_path}    ${CURDIR}\\SalesData.xlsx

*** Tasks ***
Open Excel Workbook
    Open Workbook    ${file_path}
    Sleep    20