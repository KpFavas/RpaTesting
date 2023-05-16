# ** Settings **
# Documentation       Template robot main suite.
# Library    RPA.PDF
# Library    RPA.FileSystem
# Library    RPA.Email.ImapSmtp


# ** Variables **
# ${PDF_File}    input/Timesheet.pdf

# # ${New_Txt_File}    output/Timesheet.txt

# ** Tasks **    #functions will call here
# Extract text from PDF files
#     Extract text from PDF   ${PDF_File}

# ** Keywords **    #like functions

# Extract text from PDF
#     [Arguments]    ${PDF_File}
#     ${PDF_text}    Get Text From Pdf    ${PDF_File}
    
#     # Create File    ${New_Txt_File}


#     FOR    ${page}    IN    @{PDF_text.keys()}
    
#         ${matched}    
#         ...    Run Keyword And Return Status    
#         ...    Should Match Regexp    ${PDF_text[${page}]}    (.*)Timesheet(\\s)(.*)
#         Log    ${matched}
#         ${pagno}    Convert To String    ${page}
#         ${destination_file}    Catenate    output/    out_${pagno}.pdf

#         Run Keyword IF    ${matched}
#         ...    Extract Pages From Pdf    ${PDF_File}    ${destination_file}    ${pagno}
#     END



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
    log to console      ${text}
    #    ${Invoice_No}    Get Regexp Matches   ${text}[${1}]    (?<=#INV)\\d+
    ${Invoice_No}    Get Regexp Matches    ${text}[${1}]    (#)INV\\d+
    log to console      ${Invoice_No}
    ${Invoice_Date}    Get Regexp Matches    ${text}[${1}]   (\\d{2}\\/\\d{2}\\/\\d{2})
        #Now the invoice number and date are stored (?<=)
    
    [Return]    ${Invoice_No}    ${Invoice_Date}

    
Save As Excel File
    [Arguments]    ${InvNo}    ${InvDate}

    Open Workbook    ${Excel_File}

    Set Cell Value    2    A    ${InvNo}[${0}]
    Set Cell Value    2    B    ${InvDate}[${0}]

    Save Workbook
    
    
