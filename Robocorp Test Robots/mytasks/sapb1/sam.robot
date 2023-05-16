*** Settings ***
Library    RPA.PDF
Library    RPA.Excel.Files
*** Variables ***
# ${htmltable}    <table><tr><th width="15">BookName</th><th width="20">Author</th><th width="20">Subject</th><th width="25">Price</th></tr>
${HtmlTable}=    <table border="1" cellspacing="10" style="font-family: Arial, sans-serif; border-collapse: collapse; width: 100%; text-align: center;"><tr><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="30%">BookName
...               </th><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="35%">Author
...    </th><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="15%">Subject
...    </th><th style="background-color: #dddddd; text-align: center; padding: 8px;" width="10%">Price</th></tr>

*** Tasks ***    #functions will call here
Read Excel and save as pdf
    Open Workbook    ${CURDIR}//tables.xlsx
    Set Active Worksheet    sheet2
    ${Employees}    Read Worksheet As Table    header=${True}
    Log To Console    ${Employees}
    Close Workbook

    FOR    ${Employee}    IN    @{Employees}
    #  ${htmltable}    Set Variable    ${htmltable}<tr><th width="15">${Employee}[BookName]</th><th width="20">${Employee}[Author]</th><th width="20">${Employee}[Subject]</th><th width="25">${Employee}[Price]</th></tr>      
         ${HtmlTable}    Set Variable    ${HtmlTable}<tr><td align="center">${Employee}[BookName]</td><td align="center">${Employee}[Author]</td><td align="center">${Employee}[Subject]</td><td align="center">${Employee}[Price]</td></tr>
    END
    ${HtmlTable}    Set Variable    ${HtmlTable}</table>
    Html To Pdf    ${HtmlTable}    ${CURDIR}//exceltopdf.pdf

