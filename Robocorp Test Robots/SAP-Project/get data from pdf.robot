*** Settings ***
Documentation       Template robot main suite.
Library    RPA.PDF
Library    RPA.Excel.Files
Library    DateTime


*** Variables ***

${HtmlTable}    <table border="1" cellspacing="10"><tr><th width="150">DueDate</th></tr>


*** Tasks ***
Read Excel and save as pdf
    Open Workbook    input/OBNK-Bankstatement.xlsx
    ${Datas}    Read Worksheet As Table    header=${True}
    Close Workbook

    FOR    ${Data}    IN    @{Datas}
        Convert Date    ${Data}[DueDate]    result_format=%Y/%m/%d
        ${HtmlTable}    Set Variable    ${HtmlTable}<tr><td width="150">${valid_date}</td></tr>
    END
    
    ${HtmlTable}    Set Variable    ${HtmlTable}</table>
    Html To Pdf    ${HtmlTable}    output/Statement details.pdf
