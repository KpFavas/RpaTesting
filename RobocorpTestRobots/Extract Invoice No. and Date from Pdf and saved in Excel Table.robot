** Settings **
Documentation       Template robot main suite.
Library    RPA.PDF
Library    String
Library    RPA.Excel.Files


** Variables **

${PDF_File}    input/Invoice3.pdf
${Excel_File}    output/Invoice3.xlsx

** Tasks **    #functions will call here
Exctract Text From pdf

    ${Invoice_No}    ${Invoice_Date}    Extract text from PDF
    Save As Excel File    ${Invoice_No}    ${Invoice_Date}    

** Keywords **    #like functions

Extract text from PDF
    ${text}    Get Text From Pdf    ${PDF_File}    trim=${False}
    #    ${Invoice_No}    Get Regexp Matches   ${text}[${1}]    (?<=#INV)\\d+
    ${Invoice_No}    Get Regexp Matches    ${text}[${1}]    (#)INV\\d+

    ${Invoice_Date}    Get Regexp Matches    ${text}[${1}]   (\\d{2}\\/\\d{2}\\/\\d{2})
        #Now the invoice number and date are stored (?<=)
    
    [Return]    ${Invoice_No}    ${Invoice_Date}

    
Save As Excel File
    [Arguments]    ${InvNo}    ${InvDate}

    Open Workbook    ${Excel_File}

    Set Cell Value    2    A    ${InvNo}[${0}]
    Set Cell Value    2    B    ${InvDate}[${0}]

    Save Workbook
    
    
