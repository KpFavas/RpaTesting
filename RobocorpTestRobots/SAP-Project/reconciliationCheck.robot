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
${datatype}    rat_GLAccount
${bank}    100000
${bank1}    450005
${success_msg}      Reconciliation Success
${fail_msg}      Reconciliation Failure
${fail_msg2}       Record Not Found
${rev_bank}      161012
${bank_charge_acc}      161012
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
    ${Excel_Debitlist}=    Create List
    ${Excel_Creditlist}=    Create List
    ${sequencelist}=    Create List
    ${TransIDlist}=    Create List
    ${Transdatelist}=    Create List
    ${Detailslist}=    Create List
    ${RecNumberlist}=    Create List
    ${get_reconciled_data}    Create Dictionary 
    ${headers}=  Create Dictionary  Content-Type=application/json
    ########---getting Excel data through loop---########
    FOR    ${data}    IN    @{exceld}
        ${Excel_TransID}    Set Variable    ${data}[Transaction ID]
        ${Excel_Debit}    Set Variable    ${data}[Debit]
        ${Excel_Credit}    Set Variable    ${data}[Credit]
        ${Excel_Details}    Set Variable    ${data}[Details]
        ${exTransID}    Set Variable    ${data}[Transaction ID]
        ${exTransID}    Run Keyword If    '${exTransID}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exTransID}
        ${exTransdate}    Set Variable    ${data}[Transaction date]
        ${exTransdate}       Convert Date    ${exTransdate}    result_format=%Y-%m-%dT%H:%M:%SZ
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
        Append To List    ${Excel_Debitlist}    ${exDebit}
        Append To List    ${Excel_Creditlist}    ${exCredit}
        Append To List    ${Detailslist}    ${exDetails}
    END
    Log To Console      \nTransID list From Excel : ${TransIDlist}
    Log To Console      Transdatelist Excel : ${Transdatelist}
    Log To Console      Excel_Debitlist : ${Excel_Debitlist}\n
    Log To Console      Excel_Creditlist : ${Excel_Creditlist}\n
    ${debitlist_without_zeros}    Create List
    FOR    ${debit}    IN    @{Excel_Debitlist}
        ${debit}  Convert To Number   ${debit}
        Run Keyword If    '${debit}' != '0.0'    Append To List    ${debitlist_without_zeros}    ${debit}
    END
    ${creditlist_without_zeros}    Create List
    FOR    ${credit}    IN    @{Excel_Creditlist}
        ${credit}  Convert To Number   ${credit}
        Run Keyword If    '${credit}' != '0.0'    Append To List    ${creditlist_without_zeros}    ${credit}
    END

    ${len_of_excel_credits}     Evaluate    len(${creditlist_without_zeros})
    ${len_of_excel_debits}     Evaluate    len(${debitlist_without_zeros})
    
    Log To Console    Excel_Debitlist without zeros: ${debitlist_without_zeros}
    Log To Console    Excel_Creditlist without zeros: ${creditlist_without_zeros}

    ${len_of_excel_debits}      Evaluate    len(${TransIDlist})
    Log To Console    Excel_TransIdsLength: ${len_of_excel_debits}

    ${Excel_transaction_details_list}   Create List
    FOR     ${idx}    IN RANGE    ${len_of_excel_debits}
        ${trans_exId}    Set Variable    ${TransIDlist[${idx}]}
        ${trans_exDate}    Set Variable    ${Transdatelist[${idx}]}
        ${trans_exRefNo}    Set Variable    ${Refnolist[${idx}]}
        ${trans_exDetails}    Set Variable    ${Detailslist[${idx}]}
        ${trans_exDr}    Set Variable    ${Excel_Debitlist[${idx}]}
        ${trans_exDr}  Convert To Number   ${trans_exDr}
        ${trans_exCr}    Set Variable    ${Excel_Creditlist[${idx}]}
        ${trans_exCr}  Convert To Number   ${trans_exCr}
        ${ExcelTransactionDetails}    Create Dictionary
        Set To Dictionary    ${ExcelTransactionDetails}    TransID    ${trans_exId}
        Set To Dictionary    ${ExcelTransactionDetails}    Date    ${trans_exDate}
        Set To Dictionary    ${ExcelTransactionDetails}    RefNo    ${trans_exRefNo}
        Set To Dictionary    ${ExcelTransactionDetails}    Details    ${trans_exDetails}
        Set To Dictionary    ${ExcelTransactionDetails}    Credit    ${trans_exCr}
        Set To Dictionary    ${ExcelTransactionDetails}    Debit    ${trans_exDr}
        Append To List    ${Excel_transaction_details_list}    ${ExcelTransactionDetails}
    END
    # Log To Console      \nAll Excel data List: ${Excel_transaction_details_list}













# ////////////////////////////////////////////////
    

    # getting banktransaction details
    ${customer_response}    Get Request    ${sessionname}    ${base_url}/JournalEntries?$filter=DueDate ge '${From_Date}' and DueDate le '${To_Date}'
    IF    ${customer_response.status_code} == 200
        ${Journal_filter_data}    Set Variable    ${customer_response.json()}
                # Log To Console    \n\nData :::::${Journal_filter_data}

        ${line_ids}    Create List
        ${account_codes}    Create List
        ${credits}  Create List
        ${debits}   Create List
        ${amounts}  Create List
        ${Trans_Ids}        Create List
        ${JLine_DatesList}        Create List
        ${sorted_dict}      Create Dictionary 
        ${filtered_data}    Create Dictionary 
        
        # Log To Console      \nList : @{Journal_filter_data['value']['JournalEntryLines']}
        FOR    ${entry}    IN    @{Journal_filter_data['value']}
            
            # Log To Console      \nTransIds: ${Trans_Id}
            FOR    ${journal_line}    IN    @{entry['JournalEntryLines']}
                FOR    ${key}    ${value}    IN    &{journal_line}
                    Set To Dictionary    ${sorted_dict}    ${key}    ${value}
                END
                
                # ${sortedData}   	Get Dictionary Items	${sorted_dict}	
                
                ${account_code}    Get From Dictionary    ${sorted_dict}    AccountCode
                IF    '${account_code}' == '${rev_bank}'
                    ${Trans_Id}     Set Variable    ${entry['JdtNum']}
                    ${JLine_Date}   Set Variable    ${journal_line['DueDate']}
                    FOR    ${key}    ${value}    IN    &{journal_line}
                        Set To Dictionary    ${filtered_data}    ${key}    ${value}
                    END
                    ${line_id}  Get From Dictionary    ${filtered_data}    Line_ID
                    ${credit}    Get From Dictionary    ${filtered_data}    Debit
                    ${debit}   Get From Dictionary    ${filtered_data}    Credit
                    
                        Append To List    ${Trans_Ids}    ${Trans_Id}
                        Append To List    ${JLine_DatesList}    ${JLine_Date}
                        Append To List    ${line_ids}    ${line_id}
                        Append To List    ${debits}    ${debit}   
                        Append To List    ${credits}    ${credit}  
                END 
            END
        END
        # Log To Console      \nJournal Entry Get Details:
        # Log To Console      Trans IDs: ${Trans_Ids}
        # Log To Console      Due Dates: ${JLine_DatesList}
        # Log To Console      Line IDs: ${line_ids}
        # Log To Console      Credits: ${credits}
        # Log To Console      Debits: ${debits}
        ${Dic_length}   Evaluate    len(@{line_ids})
        # Log To Console      \n Length: ${Dic_length}
        # Log To Console       Debits: 
        Log To Console      \nGet Journal Entry - Succes...
    ELSE
        Log To Console      \nGet Journal Entry - Failed...
        # Log To Console      \nJournalEntryResponse : \n${Journal_filter_data}
    END
    Log To Console      \n LengthFinal: ${Dic_length}
    
######################### ^^^^Journal Entry Filtered^^^^ ########################


    ${journal_transaction_details_list}    Create List
    FOR    ${index}    IN RANGE    ${Dic_length}
        ${trans_id_tr}    Set Variable    ${Trans_Ids[${index}]}
        ${jlinesdate_tr}    Set Variable    ${JLine_DatesList[${index}]}
        ${line_id_tr}    Set Variable    ${line_ids[${index}]}
        ${credit_tr}    Set Variable    ${credits[${index}]}
        ${debit_tr}    Set Variable    ${debits[${index}]}
        
        ${transaction_details}    Create Dictionary
        Set To Dictionary    ${transaction_details}    TransID    ${trans_id_tr}
        Set To Dictionary    ${transaction_details}    jrLineDates    ${jlinesdate_tr}
        Set To Dictionary    ${transaction_details}    LineID    ${line_id_tr}
        Set To Dictionary    ${transaction_details}    Credit    ${credit_tr}
        Set To Dictionary    ${transaction_details}    Debit    ${debit_tr}
        
        # Log To Console    \nActual Transaction Details From Journal Entry Get:
        # Log To Console    Trans ID: ${trans_id_tr}
        # Log To Console    jrLine Dates: ${jlinesdate_tr}
        # Log To Console    Line ID: ${line_id_tr}
        # Log To Console    Credit: ${credit_tr}
        # Log To Console    Debit: ${debit_tr}
        
        Append To List    ${journal_transaction_details_list}    ${transaction_details}
    END

    ###################### Transactions Are Matched/Not Mached########################

    Log To Console    \nJLinesTransaction Details List: ${journal_transaction_details_list}
    Log To Console    \nExcelTransaction Details List: ${Excel_transaction_details_list}

    ${matching_records}    Create List
    FOR    ${excel_record}    IN    @{Excel_transaction_details_list}
        ${excel_credit}    Set Variable    ${excel_record}[Credit]
        ${excel_debit}    Set Variable    ${excel_record}[Debit]
        ${excel_date}    Set Variable    ${excel_record}[Date]
        # Log To Console      \nExcdr:${excel_credit}
        # Log To Console      Exdbr:${excel_debit}
        # Log To Console      Exdate:${excel_date}
        ${matching_record}    Set Variable    ${None}

        FOR    ${journal_record}    IN    @{journal_transaction_details_list}
            ${journal_credit}    Set Variable    ${journal_record}[Credit]
            ${journal_debit}    Set Variable    ${journal_record}[Debit]
            ${journal_date}    Set Variable    ${journal_record}[jrLineDates]
            # Log To Console      \nJcdr:${journal_credit}
            # Log To Console      Jdr:${journal_debit}
            # Log To Console      Jdate:${journal_date}
            Log To Console      \nChecking '${excel_credit}' == '${journal_credit}' and '${excel_debit}' == '${journal_debit}' and '${excel_date}' == '${journal_date}'
                Run Keyword If    '${excel_credit}' == '${journal_debit}' and '${excel_debit}' == '${journal_credit}' and '${excel_date}' == '${journal_date}' 
                ...    Set Variable    ${matching_record}    ${journal_record}
            Log To Console      matching recored:${matching_record}
            IF    '${matching_record}' != '${None}'
                ${trans_id}    Set Variable    ${matching_record}[TransID]
                ${matching_dict}    Create Dictionary    TransID=${trans_id}    Debit=${excel_debit}    Credit=${excel_credit}
                Append To List    ${matching_records}    ${matching_dict}
            END
        END
    END

    # Log To Console    Matching Records: ${matching_records}

















    
    #####--- POST to Get The Reconciliation List --- #####
    ${recon_post}    Set Variable         {"ExternalReconciliationFilterParams": {"AccountCodeFrom": "${rev_bank}","AccountCodeTo": "${rev_bank}","ReconciliationAccountType": "rat_GLAccount"}}
    ${reconcile_get_response}    Post Request   ${sessionname}    ${base_url}/ExternalReconciliationsService_GetReconciliationList  data=${recon_post}  headers=${headers}
    IF    ${reconcile_get_response.status_code} == 200
        ${reconListdata}    Set Variable    ${reconcile_get_response.json()}
        ${recListValueSet}  Set Variable    ${reconListdata['value']}
        FOR    ${rec}    IN    @{reconListdata['value']}
            FOR    ${key}    ${value}    IN    &{rec}
                Set To Dictionary    ${get_reconciled_data}    ${key}    ${value}
            END
            ${get_rec_data}     Get Dictionary Items        ${get_reconciled_data}
            ${recno}  Get From Dictionary    ${get_reconciled_data}    ReconciliationNo
            Append To List    ${RecNumberlist}    ${recno} 
        END
        Log To Console      \nGet Reconciled Data-Success...
        Log To Console      RecNumberlist:${RecNumberlist}
    ELSE
        Log To Console      \nGet Reconciled Data- Failed...
        Log To Console      \n JSON: ${reconcile_get_response.json()}
    END
    ${TransIdlenth}    Evaluate    len(${Trans_Ids})
    Log To Console      Final TransId List: ${TransIdlenth}
    IF    ${TransIdlenth} > 0
        ${list_length}=    Evaluate    len(${TransIDlist})
        Log To Console      \nTrans_Id List Length(From Excel) : ${list_length}
        FOR    ${counter}    IN RANGE    0    ${list_length} 
            IF    ${Excel_Debitlist}[${counter}] == 0
                ${Ref_No}    Set Variable    ${Refnolist}[${counter}]
                IF      '${Ref_No}' == '0'
                    ${Ref_No}   Set Variable    null
                ELSE
                    ${Ref_No}   Set Variable    ${Ref_No}
                END
                ${payload1}    Set Variable         {"AccountCode": "${rev_bank}", "CreditAmount": "${Excel_Creditlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "Reference": "${Ref_No}","Memo":"${Detailslist}[${counter}]","DueDate":"${Transdatelist}[${counter}]"}
                Log To Console      \nBank Page Post Body1:${payload1}
            END   
            IF    ${Excel_Debitlist}[${counter}] != 0
                ${Ref_No}    Set Variable    ${Refnolist}[${counter}]
                IF      '${Ref_No}' == '0'
                    ${Ref_No}   Set Variable    null
                ELSE
                    ${Ref_No}   Set Variable    ${Ref_No}
                END
                ${payload1}     Set variable        {"AccountCode": "${rev_bank}", "DebitAmount": "${Excel_Debitlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "Reference": ${Ref_No},"Memo":"${Detailslist}[${counter}]","DueDate":"${Transdatelist}[${counter}]"} 
                Log To Console      Bank Page Post Body2:${payload1}
            END
            # ${response}=  Post Request  ${sessionname}    ${base_url}/BankPages  data=${payload1}  headers=${headers}
            # IF    ${response.status_code} == 201
            #     ${bankpage_response}    Set Variable    ${response.json()}
            #     ${seqno}    Set Variable    ${bankpage_response['Sequence']}
            #     Append To List    ${sequencelist}    ${seqno}
            #     Log To Console    \nPOST BankPages:::::::::: - Success...
            # ELSE
            #     Log To Console    \nPOST BankPages:::::::::: - Failed...
            # END
        END
        Log To Console      \nSequenceList (From BankPages POST) :: ${sequencelist}
        # ${response}=  Post Request  ${sessionname}    ${base_url}/ExternalReconciliationsService_Reconcile  data=${final_payload_string}  headers=${headers}
        # IF    ${response.status_code} == 204
        #     Log To Console  \nReconciliation Done Successfully..........
        # ELSE            
        #     Log To Console  \nReconciliation Failed..........
        # END
    ELSE
        Log To Console    \nNo Records 
    END
    






    









# /////////////////////////////////////////////////
        # # getting banktransaction details
        # ${DebitAmount1list}=    Create List
        # ${CreditAmount1list}=    Create List
        # ${DueDate1list}=    Create List
        # ${Memo1list}=    Create List
        # Log To Console      List Length: ${list_length}  -1
        # FOR    ${counter}    IN RANGE    0    ${list_length}-1
        #     ${customer_response1}    Get Request    ${sessionname}    ${base_url}/BankPages?$select=AccountCode,PaymentReference,DueDate,CreditAmount,DebitAmount,Sequence,AccountName&$filter=AccountCode eq '${coded}' and CreditAmount eq ${Excel_Creditlist}[${counter}] and DebitAmount eq ${Excel_Debitlist}[${counter}] and DueDate eq '${Transdatelist}[${counter}]'&$orderby=Sequence desc 
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
    #                     IF    ${Excel_Creditlist}[${counter}] == 0
    #                         ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank1}","Credit": ${Excel_Debitlist}[${counter}],"Debit": ${Excel_Creditlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank}","Credit": ${Excel_Creditlist}[${counter}],"Debit": ${Excel_Debitlist}[${counter}],"BPLID": 1}]}
    #                     ELSE
    #                         ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank}","Credit": ${Excel_Creditlist}[${counter}],"Debit": ${Excel_Debitlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank1}","Credit": ${Excel_Debitlist}[${counter}],"Debit": ${Excel_Creditlist}[${counter}],"BPLID": 1}]}
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