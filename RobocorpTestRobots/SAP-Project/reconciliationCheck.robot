*** Settings ***
Documentation    account reconciliation using RPA 
Library     RequestsLibrary
Library     Collections
Library     RPA.Excel.Files
Library     String
Library     DateTime
Library     RPA.Browser.Selenium
Library     JSONLibrary
*** Variables ***
${base_url}    http://151.80.190.234:50001/b1s/v1
${username}    {"CompanyDB": "SBODemoGB","UserName": "favas"}
${password}    Test@123
${sessionname}    sapb
${url}          ${OUTPUT_DIR}${/}/OBNK-Sheet.xlsx
${datatype}    rat_BusinessPartner
${bank}    100000
${bank1}    450005
${success_msg}      Reconciliation Success
${fail_msg}      Reconciliation Failure
${fail_msg2}       Record Not Found
${rev_bank}      161012
${line_ID}      0
*** Tasks ***    
main task 
    main page
    ${excelinfo}    ${exceld}   ${From_Date}    ${To_Date}    first page
    second page    ${excelinfo}    ${exceld}    ${From_Date}    ${To_Date}
*** Keywords ***
main page
    
    ${auth_data}=    Create List    ${username}    ${password}
    Create Session    ${sessionname}    ${base_url}/Login    auth=${auth_data}

first page
        Open Workbook    ${url}
        Set Active Worksheet    Sheet1
        ${code}     Get Cell Value    1    2
        ${From_Date}     Get Cell Value    2    3
        ${From_Date}    Convert Date    ${From_Date}    result_format=%Y-%m-%dT%H:%M:%SZ
        ${To_Date}     Get Cell Value    3    3
        ${To_Date}    Convert Date    ${To_Date}    result_format=%Y-%m-%dT%H:%M:%SZ
        ${exceldata}=    Read Worksheet As Table    header=True    start=5    trim=${True}
       
        Save Workbook   
        [Return]    ${exceldata}    ${code}     ${From_Date}    ${To_Date}  
second page
    [Arguments]    ${exceld}    ${coded}     ${From_Date}    ${To_Date}

    ${linidlist}=    Create List
    ${Refnolist}=    Create List
    ${Debitlist}=    Create List
    ${Creditlist}=    Create List
    ${sequencelist}=    Create List
    ${TransIDlist}=    Create List
    ${Transdatelist}=    Create List
    ${Detailslist}=    Create List
    ${headers}=  Create Dictionary  Content-Type=application/json
    # getting Excel data through loop
    FOR    ${data}    IN    @{exceld}
        ${Excel_TransID}    Set Variable    ${data}[Transaction ID]
        ${Excel_Debit}    Set Variable    ${data}[Debit]
        ${Excel_Credit}    Set Variable    ${data}[Credit]
        ${Excel_Details}    Set Variable    ${data}[Details]
        # Log To Console    \nTransID: ${Excel_TransID}\n
        # Log To Console    From: ${From_Date}\n
        # Log To Console    To: ${To_Date}\n
        # Log To Console    Debit: ${Excel_Debit}\n
        # Log To Console    Credit: ${Excel_Credit}\n
        # Log To Console    Details: ${Excel_Details}\n
        ${exTransID}    Set Variable    ${data}[Transaction ID]
        ${exTransID}    Run Keyword If    '${exTransID}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exTransID}
        ${exTransdate}    Set Variable    ${data}[Transaction date]
        ${exTransdate}       Convert Date    ${exTransdate}    result_format=%Y-%m-%dT%H:%M:%SZ
        # Log To Console      ${exTransdate}
        # ${exTransdate}    Convert Date    ${sales_rep}[Transaction date]    result_format=%d%m%Y 
        # ${exTransdate}    Convert To Number    ${exTransdate}
        ${exRefno}    Set Variable    ${data}[Reference No.]
        ${exRefno}    Run Keyword If    '${exRefno}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exRefno}
        ${exDetails}    Set Variable    ${data}[Details]
        ${exDetails}    Run Keyword If    '${exDetails}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exDetails}
        ${exDebit}    Set Variable    ${data}[Debit]
        ${exDebit}    Run Keyword If    '${exDebit}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exDebit}
        ${exCredit}    Set Variable    ${data}[Credit]
        ${exCredit}    Run Keyword If    '${exCredit}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exCredit}
        Append To List    ${TransIDlist}    ${exTransID}
        Append To List    ${Transdatelist}    ${exTransdate}
        Append To List    ${Refnolist}    ${exRefno}
        Append To List    ${Debitlist}    ${exDebit}
        Append To List    ${Creditlist}    ${exCredit}
        Append To List    ${Detailslist}    ${exDetails}
    END
    # Log To Console      \nTrans Id List : ${TransIDlist}\n
    # Log To Console      Transdatelist : ${Transdatelist}\n
    # Log To Console      Refnolist : ${Refnolist}\n
    # Log To Console      Debitlist : ${Debitlist}\n
    # Log To Console      Creditlist : ${Creditlist}\n
    # Log To Console      Detailslist : ${Detailslist}\n
    #    posting bankpages details
    ${list_length}=    Evaluate    len(${TransIDlist})
    # Log To Console      List Length : ${list_length}\n

    FOR    ${counter}    IN RANGE    0    ${list_length} 
        # Log To Console       DebitCounter : ${Debitlist}[${counter}]\n

        IF    ${Debitlist}[${counter}] == 0
            # Log To Console      CeeeeCreditlistCounter : ${Creditlist}[${counter}]\n
            # Log To Console      CeeeReferencelistCounter : ${Refnolist}[${counter}]\n
            ${Ref_No}    Set Variable    ${Refnolist}[${counter}]
            ${Ref_No}    Run Keyword If    '${Ref_No}' == '0'    Set Variable    null    Else    Set Variable    "${Ref_No}"
            ${payload1}    Set Variable         {"AccountCode": "${rev_bank}", "CreditAmount": "${Creditlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "Reference": ${Ref_No},"Memo":"${Detailslist}[${counter}]"}
            Log To Console  PayLoad1: ${payload1}
        END   
        IF    ${Debitlist}[${counter}] != 0
            # Log To Console      DeeeeDebitlistCounter : ${Debitlist}[${counter}]\n
            #  Log To Console      DeeeeReferencelistCounter : ${Refnolist}[${counter}]\n
            ${Ref_No}    Set Variable    ${Refnolist}[${counter}]
            ${Ref_No}    Run Keyword If    '${Ref_No}' == '0'    Set Variable    null    Else    Set Variable    "${Ref_No}"
            ${payload1}    Set Variable         {"AccountCode": "${rev_bank}", "DebitAmount": "${Debitlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "Reference": ${Ref_No},"Memo":"${Detailslist}[${counter}]"} 
            Log To Console  PayLoad1: ${payload1} 
        END
        # ${response}=  Post Request  ${sessionname}    ${base_url}/BankPages  data=${payload1}  headers=${headers}
        # IF    ${response.status_code} == 201
        #     Log To Console    successbankpages
        #     Log To Console    successJSOn : ${response.json()}\n
        # ELSE
        #     Log To Console    failbankpages
        #     Log To Console    Fail JSOn : ${response.json()}\n
        # END
    END
# ////////////////////////////////////////////////
    # getting banktransaction details
    ${customer_response}    Get Request    ${sessionname}    ${base_url}/JournalEntries?$filter=DueDate ge '${From_Date}' and DueDate le '${To_Date}'
    IF    ${customer_response.status_code} == 200
        ${Journal_filter_data}    Set Variable    ${customer_response.json()}
                # Log To Console    \n\nData :::::${Journal_filter_data}

        ${line_ids}    Create List
        ${account_codes}    Create List
        ${credits}    Create List
        ${debits}    Create List
        ${amounts}    Create List
        ${sorted_dict}    Create Dictionary 
        ${filtered_data}    Create Dictionary 
        # Log To Console      \nList : @{Journal_filter_data['value']['JournalEntryLines']}
        FOR    ${entry}    IN    @{Journal_filter_data['value']}
            FOR    ${journal_line}    IN    @{entry['JournalEntryLines']}
                FOR    ${key}    ${value}    IN    &{journal_line}
                    Set To Dictionary    ${sorted_dict}    ${key}    ${value}
                END
                
                # ${sortedData}   	Get Dictionary Items	${sorted_dict}	
                
                ${account_code}    Get From Dictionary    ${sorted_dict}    AccountCode
                # Log To Console    \n\nAccountCode :::::${account_code}
                # Log To Console      \n\nDataSet :::::${sortedData}
                IF    '${account_code}' == '${rev_bank}'
                    FOR    ${key}    ${value}    IN    &{journal_line}
                        Set To Dictionary    ${filtered_data}    ${key}    ${value}
                    END
                    # ${filtered_data}    Get From Dictionary
                    # Log To Console      \n\nDataSet :::::${sortedData}
                    Log To Console       \n AccountCode: ${account_code}
                    # ${filtered_data}  Get Dictionary Items    ${sorted_dict}
                    Log To Console       \n Filtered Data: ${filtered_data}


                    ${line_id}  Get From Dictionary    ${sorted_dict}    Line_ID
                    # Log To Console     \nLineID: ${line_id}
                    ${debit}    Get From Dictionary    ${sorted_dict}    Debit
                    ${credit}   Get From Dictionary    ${sorted_dict}    Credit
                    
                    Append To List    ${line_ids}    ${line_id}
                    Append To List    ${debits}    ${debit}   
                    Append To List    ${credits}    ${credit}    
                END
        END
    END
        # Log To Console        Line IDs: ${line_ids}
        # Log To Console       Credits: ${credits}
        # Log To Console       Debits: ${debits}

        # Log To Console       Debits: 
    ELSE
        Log To Console      \nJournal Entry Get Failed...
        Log To Console      \nJournalEntryResponse : \n${Journal_filter_data}
    END
    # ${Dic_length}    Evaluate    len(${sorted_dict})
    # Log To Console      \n Length: ${Dic_length}
    # Log To Console      \n Line: ${sorted_dict['Line_ID']}
    # FOR     ${Data}     IN     ${sorted_dict['Line_ID']}
    #     Log To Console      \n Line: ${Data}
    # END 
    # FOR     ${s}    IN       @{sorted_dict}
    #         Log To Console      ${s['Line_ID']}
    # END
    
















# /////////////////////////////////////////////////
        # # getting banktransaction details
        # ${DebitAmount1list}=    Create List
        # ${CreditAmount1list}=    Create List
        # ${DueDate1list}=    Create List
        # ${Memo1list}=    Create List
        # Log To Console      List Length: ${list_length}  -1
        # FOR    ${counter}    IN RANGE    0    ${list_length}-1
        #     ${customer_response1}    Get Request    ${sessionname}    ${base_url}/BankPages?$select=AccountCode,PaymentReference,DueDate,CreditAmount,DebitAmount,Sequence,AccountName&$filter=AccountCode eq '${coded}' and CreditAmount eq ${Creditlist}[${counter}] and DebitAmount eq ${Debitlist}[${counter}] and DueDate eq '${Transdatelist}[${counter}]'&$orderby=Sequence desc 
        #         IF  ${customer_response1.status_code} == 200
        #             Log To Console    Response Val json: ${customer_response1.json()}
                    # Log To Console    Response Val json: ${customer_response1.json()['value'][0]}
    #                 ${customer_data1}    Set Variable    ${customer_response1.json()['value'][0]}
    #                 ${AccountCode}    Set Variable    ${customer_data1['AccountCode']}
    #                 ${Sequence}    Set Variable    ${customer_data1['Sequence']}
    #                 Log to Console      Sequencseeeeeeee: ${Sequence}
    #                 ${AccountName}    Set Variable    ${customer_data1['AccountName']}   
    #                 ${DueDate1}    Set Variable    ${customer_data1['DueDate']}   
    #                 ${DueDate1}    Convert Date    ${customer_data1['DueDate']}    result_format=%d%m%Y 
    #                 ${DueDate1}    Convert To Number    ${DueDate1}
    #                 ${Memo1}    Set Variable    ${customer_data1['PaymentReference']}
    #                 ${DebitAmount1}    Set Variable    ${customer_data1['DebitAmount']}
    #                 ${DebitAmount1}    Convert To Integer    ${DebitAmount1}
    #                 ${CreditAmount1}    Set Variable    ${customer_data1['CreditAmount']}
    #                 ${CreditAmount1}    Convert To Integer    ${CreditAmount1}  
    #                 Append To List    ${sequencelist}    ${Sequence}
    #                 Append To List    ${DebitAmount1list}    ${DebitAmount1}
    #                 Append To List    ${CreditAmount1list}    ${CreditAmount1}
    #                 Append To List    ${DueDate1list}    ${DueDate1}
    #                 Append To List    ${Memo1list}    ${Memo1}   
        #         # ELSE
        #             Log To Console      Failed get bankpages\n
        #             Log To Console    Response Val json: ${customer_response1.json()}\n  
        #         END
        # END

    #     # getting journal entries
    #     FOR    ${counter}    IN RANGE    0    ${list_length}
    #                 IF    ${TransIDlist}[${counter}] == 0   
    #                     IF    ${Creditlist}[${counter}] == 0
    #                         ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank1}","Credit": ${Debitlist}[${counter}],"Debit": ${Creditlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank}","Credit": ${Creditlist}[${counter}],"Debit": ${Debitlist}[${counter}],"BPLID": 1}]}
    #                     ELSE
    #                         ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank}","Credit": ${Creditlist}[${counter}],"Debit": ${Debitlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank1}","Credit": ${Debitlist}[${counter}],"Debit": ${Creditlist}[${counter}],"BPLID": 1}]}
    #                     END
    #                     ${response}=  Post Request  ${sessionname}    ${base_url}/JournalEntries  data=${PAYLOAD2}  headers=${headers}
    #                     IF    ${response.status_code} == 201
    #                         Log To Console    successjournalentry
    #                     ELSE
    #                         Log To Console    failjournalentry
    #                     END
                    
    #                 ELSE
    #                     ${customer_response}    Get Request    ${sessionname}    ${base_url}/JournalEntries(${TransIDlist}[${counter}])/JournalEntryLines
    #                         IF    ${customer_response.status_code} == 200
    #                             ${customer_datad}    Set Variable    ${customer_response.json()['JournalEntryLines']}
    #                             ${count}=    Set Variable    0
    #                             #getting count of journal entries lines storing count variable
    #                                 FOR    ${dict}    IN    @{customer_datad}
    #                                     ${line_id}=    Get From Dictionary    ${dict}    Line_ID
    #                                     ${count}=    Evaluate    ${count}+1    
    #                                 END
    #                                 log to console   Count: ${count}
    #                         #iterate the journal entries lines to get the match details
    #                             FOR    ${counter}    IN RANGE    0    ${count}    
    #                                         ${customer_data}    Set Variable    ${customer_response.json()['JournalEntryLines'][${counter}]}
    #                                         ${DebitAmount}    Set Variable    ${customer_data['Debit']}
    #                                         ${DebitAmount}    Convert To Integer    ${DebitAmount}
    #                                         ${CreditAmount}    Set Variable    ${customer_data['Credit']}
    #                                         ${CreditAmount}    Convert To Integer    ${CreditAmount}
    #                                         ${Line_ID}    Set Variable    ${customer_data['Line_ID']}  
    #                                         ${Referencid}    Set Variable    ${customer_data['Reference1']} 
    #                                         ${DueDatejo}    Set Variable    ${customer_data['DueDate']}
    #                                         ${DueDatejo}       Convert Date    ${DueDatejo}    result_format=%Y-%m-%dT%H:%M:%SZ
    #                                         ${Memo}    Set Variable    ${customer_data['LineMemo']}
    #                                         FOR    ${counter1}    IN RANGE    0    ${list_length}-1    
    #                                             ${memo1}    Run Keyword And Ignore Error    Should Be Equal As Strings    ${Memo}    ${Detailslist}[${counter1}]
    #                                         ${memo1}    Set Variable    ${memo1}[0]
    #                                         ${pass}    Set Variable    PASS
    #                                         # Log To Console      \n${CreditAmount1list}[${counter1}] == ${CreditAmount} \nand "${customer_data['LineMemo']}" == "${Detailslist}[${counter1}]" \nand ${DebitAmount1list}[${counter1}] == ${DebitAmount} \nand ${Referencid} == ${Refnolist}[${counter1}]
    #                                         ${condition}=    Evaluate    "${customer_data['LineMemo']}" == "${Detailslist}[${counter1}]" and ${Referencid} == ${Refnolist}[${counter1}]
    #                                         Run Keyword If    ${condition}    Append To List    ${linidlist}    ${Line_ID}    
    #                                         #   Run Keyword And Ignore Error    ${CreditAmount1list}[${counter1}] == ${CreditAmount} and ${memo1} == ${pass} and ${DebitAmount1list}[${counter1}] == ${DebitAmount} 
    #                                         #    Append To List    ${linidlist}    ${Line_ID}  
    #                                         END
    #                                     END
    #                             ELSE
    #                                 Log To Console     fail
    #                             END
    #                 END
    #     END
    #     Log To Console      \nLineIdLists: ${linidlist}\n
    #     log to console      \nSequenceLists: ${sequencelist}\n
    #     ${sequencelist}    Remove Duplicates    ${sequencelist}
    #     #  ${linidlist}    Remove Duplicates    ${linidlist}
    #     ${TransIDlist}    Remove Duplicates    ${TransIDlist}
    #     ${linidlist_length}=    Get Length    ${linidlist}
    #     IF    ${linidlist_length} == 0
    #         Log To Console      "There are no transaction with these details Or Already Reconciled..."
    #     ELSE
    #         Log To Console      \nLineIdList: ${linidlist}\nTransId: ${TransIDlist}\nAccountCode: ${coded}\nSequenceList:${sequencelist}\n
    #     # posting external reconciliation
    #     posting ExternalReconciliation    ${linidlist}    ${TransIDlist}    ${coded}    ${sequencelist}  ${headers}     
        
    # END


# posting ExternalReconciliation 
#     [Arguments]    ${linidlist}    ${TransIDlist}    ${coded}    ${sequencelist}    ${headers}  
#     Log To Console      Line Id1: ${linidlist}[0],Line Id2:${linidlist}[1]
#     IF      ${linidlist}
#         ${payload3}    Set Variable  {"ExternalReconciliation": {"ReconciliationAccountType": "${datatype}","ReconciliationBankStatementLines":[ {"BankStatementAccountCode": "${coded}","Sequence": ${sequencelist}[0]},{"BankStatementAccountCode": "${coded}","Sequence": ${sequencelist}[1]}],"ReconciliationJournalEntryLines":[{"LineNumber": ${linidlist}[0],"TransactionNumber": ${TransIDlist}[0]},{"LineNumber": ${linidlist}[1],"TransactionNumber": ${TransIDlist}[1]}]}}          
#         ${response}=  Post Request  ${sessionname}    ${base_url}/ExternalReconciliationsService_Reconcile  data=${payload3}  headers=${headers}
#         IF    ${response.status_code} == 204
#             Open Workbook    ${url}
#             Set Active Worksheet    Sheet1
#             Set Styles    G3:G5
#             ...  color=ffffff
#             ...  align_horizontal=center
#             ...  align_vertical=center
#             ...  bold=True
#             ...  cell_fill=198754
#             Set Cell Value  4   7     ${success_msg}
#             Save Workbook
#             Log To Console    Reconciliation Success 
#         ELSE
#             ${ErrorMsg}     Set Variable    ${response.json()['error']['message']['value']}
#             # Log To Console      \nMsg: ${ErrorMsg}\n
#             Open Workbook    ${url}
#             Set Active Worksheet    Sheet1
#             Set Styles    G3:G5
#             ...  color=ffffff
#             ...  align_horizontal=center
#             ...  align_vertical=center
#             ...  bold=True
#             ...  cell_fill=DC143C
#             # ...  wrap_text=True
#             Set Cell Value  4   7     ${fail_msg}
#             Set Cell Value  5   7     Value: ${ErrorMsg}
#             Set Cell Format    5   7
#             ...   wrap_text=True
            
#             Save Workbook
#             Log To Console      Reconciliation Failed
#         END
#     END