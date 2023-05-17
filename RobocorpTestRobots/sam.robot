*** Settings ***
Documentation       Template robot main suite.
Library    RPA.PDF
Library    RPA.Excel.Files


*** Variables ***

${HtmlTable}    <table border="1" cellspacing="10" style="font-family: Arial, sans-serif; border-collapse: collapse; width: 100%; text-align: center;"><tr><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="30%">Emp ID</th><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="35%">Name</th><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="35%">Place</th></tr>


*** Tasks ***    #functions will call here

Read Excel and save as pdf

    Open Workbook    input/Employees.xlsx
    ${Employees}    Read Worksheet As Table    header=${True}
    Close Workbook

    FOR    ${Employee}    IN    @{Employees}
        ${HtmlTable}    Set Variable    ${HtmlTable}<tr><td align="center">${Employee}[Emp Id]</td><td align="center">${Employee}[Name]</td><td align="center">${Employee}[Place]</td></tr>
    END

    ${HtmlTable}    Set Variable    ${HtmlTable}</Table>
    Html To Pdf    ${HtmlTable}    output/Employees.pdf

*** Keywords ***    #like functions
