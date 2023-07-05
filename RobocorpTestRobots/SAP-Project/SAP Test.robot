*** Settings ***
Documentation    Account reconciliation using RPA
Library    OperatingSystem
Library     RequestsLibrary
Library     JSONLibrary
Library     Collections
Library     RPA.Excel.Files
Library     String
Library     DateTime
# Library     RPA.Browser.Selenium
*** Variables ***
${BaseUrl}      ${EMPTY}
${Username}     ${EMPTY}
${Username1}    ${EMPTY}
${Password}     ${EMPTY}
${From_Date}    ${EMPTY}
${To_Date}      ${EMPTY}
${BankAccountCode}      ${EMPTY}
${BankChargeAccountCode}    ${EMPTY}
@{Excel_transaction_details_list}    ${EMPTY}
${sessionname}      ${EMPTY} 

*** Tasks ***
Main Task
    Generate Unique Session Name
    Set Global Variables
    Converting Username
    Login Session Creation
    Json Validation
*** Keywords ***
Generate Unique Session Name
    ${timestamp}=       Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_number}=   Generate Random String    6    0123456789
    ${sessionname}=     Set Variable    sapb1_${timestamp}_${random_number}
    Log To Console      ${sessionname}
Set Global Variables
    ${variables}=    Get File    variables.json
    # Log To Console      \nFileData: ${variables}
    ${variable_dict}=    Evaluate    json.loads('''${variables}''')
    Set Global Variable    ${BaseUrl}    ${variable_dict["BaseUrl"]}
    Set Global Variable    ${Username1}    ${variable_dict["Username"]}
    Set Global Variable    ${Password}    ${variable_dict["Password"]}
    Set Global Variable    ${From_Date}    ${variable_dict["From_Date"]}
    Set Global Variable    ${To_Date}    ${variable_dict["To_Date"]}
    Set Global Variable    ${BankAccountCode}    ${variable_dict["BankAccountCode"]}
    Set Global Variable    ${BankChargeAccountCode}    ${variable_dict["BankChargeAccountCode"]}
    Set Global Variable    ${Excel_transaction_details_list}    ${variable_dict["ExcelData"]}
Converting Username
    ${Username1}    Evaluate    "${Username1}".replace("'", '"')
    Set Global Variable    ${Username}      ${Username1}
Login Session Creation
    ${auth_data}=    Create List    ${Username}    ${Password}
    Create Session    ${sessionname}    ${base_url}/Login    auth=${auth_data}
    Log To Console      \nLogin Success
Json Validation
    Log To Console      \nExcel Data: ${Excel_transaction_details_list}
    Log To Console      Account Code: ${BankAccountCode}
    #Excel Length-------------------------------------
    ${Excel_Length}     Evaluate    len(${Excel_transaction_details_list})
    Log To Console      \nExcel Row Lenth : ${Excel_Length}
    #-------------------------------------------------
    
    # getting banktransaction details
    ${customer_response}    Get Request    ${sessionname}    ${base_url}/JournalEntries?$filter=DueDate ge '${From_Date}' and DueDate le '${To_Date}'
    IF    ${customer_response.status_code} == 200
        ${Journal_filter_data}    Set Variable    ${customer_response.json()}
        ${JE_LineIDsList}    Create List
        ${account_codes}    Create List
        ${JE_CreditsList}  Create List
        ${JE_DebitsList}   Create List
        ${amounts}  Create List
        ${Trans_Ids}        Create List
        ${JE_DueDatesList}        Create List
        ${sorted_dict}      Create Dictionary
        ${filtered_data}    Create Dictionary
        FOR    ${entry}    IN    @{Journal_filter_data['value']}
            FOR    ${journal_line}    IN    @{entry['JournalEntryLines']}
                FOR    ${key}    ${value}    IN    &{journal_line}
                    Set To Dictionary    ${sorted_dict}    ${key}    ${value}
                END
                ${account_code}    Get From Dictionary    ${sorted_dict}    AccountCode
                IF    '${account_code}' == '${BankAccountCode}'
                    ${Trans_Id}     Set Variable    ${entry['JdtNum']}
                    ${JLine_Date}   Set Variable    ${journal_line['DueDate']}
                    FOR    ${key}    ${value}    IN    &{journal_line}
                        Set To Dictionary    ${filtered_data}    ${key}    ${value}
                    END
                    # Log To Console          \nFiltered journal Lines::::${filtered_data}
                    ${line_id}  Get From Dictionary    ${filtered_data}    Line_ID
                    ${credit}    Get From Dictionary    ${filtered_data}    Debit
                    ${credit}=    Convert To Number    ${credit}
                    ${credit}    Evaluate    "{:.2f}".format(${credit})
                    ${debit}   Get From Dictionary    ${filtered_data}    Credit
                    ${debit}=    Convert To Number    ${debit}
                    ${debit}    Evaluate    "{:.2f}".format(${debit})
                        Append To List    ${Trans_Ids}    ${Trans_Id}
                        Append To List    ${JE_DueDatesList}    ${JLine_Date}
                        Append To List    ${JE_LineIDsList}    ${line_id}
                        Append To List    ${JE_DebitsList}    ${debit}
                        Append To List    ${JE_CreditsList}    ${credit}
                END
            END
        END
        ${Dic_length}   Evaluate    len(@{JE_LineIDsList})
        Log To Console      \nTransIds : ${Trans_Ids}
        Log To Console      \nJL Date : ${JE_DueDatesList}
        Log To Console      \nLineIdsIds : ${JE_LineIDsList}
        Log To Console      \nJE_DebitsList : ${JE_DebitsList}
        Log To Console      \nJE_CreditsList : ${JE_CreditsList}
        Log To Console      \nGet Journal Entry - Succes...
    ELSE
        Log To Console      \nGet Journal Entry - Failed...
    END
    Log To Console      \n LengthFinal: ${Dic_length}
    ${journal_transaction_details_list}    Create List
    FOR    ${index}    IN RANGE    ${Dic_length}
        ${trans_id_tr}    Set Variable    ${Trans_Ids[${index}]}
        ${jlinesdate_tr}    Set Variable    ${JE_DueDatesList[${index}]}
        ${line_id_tr}    Set Variable    ${JE_LineIDsList[${index}]}
        ${credit_tr}    Set Variable    ${JE_CreditsList[${index}]}
        ${debit_tr}    Set Variable    ${JE_DebitsList[${index}]}
        ${transaction_details}    Create Dictionary
        Set To Dictionary    ${transaction_details}    TransID    ${trans_id_tr}
        Set To Dictionary    ${transaction_details}    jrLineDates    ${jlinesdate_tr}
        Set To Dictionary    ${transaction_details}    LineID    ${line_id_tr}
        Set To Dictionary    ${transaction_details}    Credit    ${credit_tr}
        Set To Dictionary    ${transaction_details}    Debit    ${debit_tr}
        Append To List    ${journal_transaction_details_list}    ${transaction_details}
    END
    Log To Console      \nFinal JE list: ${journal_transaction_details_list}
    ${JE_Length}    Evaluate    len(${journal_transaction_details_list})
    Log To Console       \nJE Length: ${JE_Length}    
    ${unmatched_records}    Create List
    ${matching_records}    Create List
    FOR    ${excel_record}    IN    @{Excel_transaction_details_list}
        ${excel_credit}     Set Variable    ${excel_record}[CreditAmount]
        IF    '${excel_credit}' != '' and '${excel_credit}'.isdecimal()
            ${excel_credit}     Convert To Number    ${excel_credit}
            ${excel_credit}     Evaluate    "{:.2f}".format(${excel_credit})
        ELSE
            ${excel_credit}      Set Variable    '0.00'
            Log To Console      \nError ${excel_credit}
        END
        ${excel_debit}      Set Variable    ${excel_record}[DebitAmount]
        IF    '${excel_debit}' != '' and '${excel_debit}'.isdecimal()
            ${excel_debit}     Convert To Number    ${excel_debit}
            ${excel_debit}     Evaluate    "{:.2f}".format(${excel_debit})
        ELSE
            ${excel_debit}      Set Variable    0.00
            Log To Console      \nError ${excel_debit}
        END
        ${excel_debi}       Convert To Number    ${excel_debit}
        ${excel_debit}      Evaluate    "{:.2f}".format(${excel_debit})
        ${excel_date1}      Set Variable    ${excel_record}[DueDate]
        ${excel_date}       Convert Date    ${excel_date1}    date_format=%Y%m%d    result_format=%Y-%m-%dT%H:%M:%SZ
        Log To Console      Date: ${excel_date}
        ${excel_details}    Set Variable    ${excel_record}[Memo]
        ${excel_reference}      Set Variable    ${excel_record}[Reference]
        ${is_matched}    Set Variable    ${False}
        FOR    ${journal_record}    IN    @{journal_transaction_details_list}
            ${journal_credit}    Set Variable    ${journal_record}[Credit]
            ${journal_credit}=    Convert To Number    ${journal_credit}
            ${journal_credit}    Evaluate    "{:.2f}".format(${journal_credit})
            ${journal_debit}    Set Variable    ${journal_record}[Debit]
            ${journal_debit}=    Convert To Number    ${journal_debit}
            ${journal_debit}    Evaluate    "{:.2f}".format(${journal_debit})
            ${journal_LineId}    Set Variable    ${journal_record}[LineID]
            ${journal_date}    Set Variable    ${journal_record}[jrLineDates]
            Log To Console      \nCheck:'${excel_credit}' == '${journal_credit}' and '${excel_credit}' != '0.00' and '${excel_date}' == '${journal_date}' 
            IF    '${excel_credit}' == '${journal_credit}' and '${excel_credit}' != '0.00' and '${excel_date}' == '${journal_date}'
                ${is_matched}    Set Variable    ${True}
                ${matching_record}    Set Variable    ${journal_record}
                ${trans_id}    Set Variable    ${matching_record}[TransID]
                ${matching_dict}    Create Dictionary    TransID=${trans_id}    Debit=${excel_debit}    Credit=${excel_credit}    Details=${excel_details}    Date=${excel_date}    Reference=${excel_reference}    Line_ID=${journal_LineId}
                Append To List    ${matching_records}    ${matching_dict}
                Exit For Loop       #To Exit the loop
            END
        END
        IF    not ${is_matched}
            Append To List    ${unmatched_records}    ${excel_record}
        END
    END
    Log To Console      \nUnMatched::::::: ${unmatched_records}
    Log To Console      \nMatched::::::: ${matching_records}