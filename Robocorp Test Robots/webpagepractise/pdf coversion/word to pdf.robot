*** Settings ***
Library    RPA.Excel.Files
Library    RPA.PDF
*** Variables ***
${htmltable}    <table><tr><th width="15">ID</th><th width="20">Company Name</th>
...    <th width="20">Contact Person</th><th width="25">Address</th><th width="20">
...    Zipcode</th><th width="15">City</th><th width="20">Country</th><th width="15">
...    Telephone</th><th width="20">Email</th></tr>
${url}    C:\\Users\\sigb\\Desktop\\RPA\\sample projects\\webpagepractise\\MOCK_DATA.xlsx
*** Tasks ***
main
    word to pdf    
*** Keywords ***
word to pdf
    Open Workbook    ${url} 
    ${students}    Read Worksheet As Table    header=${True}
    Close Workbook
    FOR    ${student}    IN    @{students}
    ${htmltable}    Set Variable    ${htmltable}<tr><th width="15">${student}[ID]</th><th width="20">
    ...    ${student}[Company Name]</th><th width="20">${student}[Contact Person]</th>
    ...    <th width="25">${student}[Address]</th><th width="20">${student}[Zipcode]</th>
    ...    <th width="15">${student}[City]</th><th width="15">${student}[Country]</th>
    ...    <th width="20">${student}[Telephone]</th><th width="30">${student}[Email]</th></tr>       
    END
    ${htmltable}    Set Variable    ${htmltable}</table>
    Html To Pdf    ${htmltable}    wordtopd.pdf