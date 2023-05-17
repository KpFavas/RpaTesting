** Settings **
Documentation    account reconciliation using RPA 
Library    RequestsLibrary
Library    Collections
Library    RPA.Excel.Files
Library    String
Library    DateTime
Library    RPA.Browser.Selenium
** Variables **
${base_url}    http://socius.sapserver.in:50001/b1s/v1
${username}    {"CompanyDB": "SBODemoGB","UserName": "favas"}
${password}    Test@123
${sessionname}    sapb
${url}         input/OBNK-sheet.xlsx

${datatype}    rat_BusinessPartner
${bank}    100000
${bank1}    450005
** Tasks **
main task 
    main page
    ${excelinfo}    ${exceld}    first page
     second page    ${excelinfo}    ${exceld}
** Keywords **
main page
    ${auth_data}=    Create List    ${username}    ${password}
    Create Session    ${sessionname}    ${base_url}/Login    auth=${auth_data}

first page
        Open Workbook    ${url}
        Set Active Worksheet    Sheet1
        ${code}     Get Cell Value    1    2
        ${exceldata}=    Read Worksheet As Table    header=True    start=2    trim=${True}
        Save Workbook
        [Return]    ${exceldata}    ${code}
 second page
    [Arguments]    ${exceld}    ${coded}
        ${linidlist}=    Create List
        ${Refnolist}=    Create List
        ${Debitlist}=    Create List
        ${Creditlist}=    Create List
        ${sequencelist}=    Create List
        ${TransIDlist}=    Create List
        ${Detailslist}=    Create List
        ${headers}=  Create Dictionary  Content-Type=application/json
        #getting Excel data through loop
         FOR    ${sales_rep}    IN    @{exceld}
                  ${exTransID}    Set Variable    ${sales_rep}[Transaction ID]
                  ${exTransID}    Run Keyword If    '${exTransID}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exTransID}
                  ${exTransdate}    Set Variable    ${sales_rep}[Transaction date]
                  ${exTransdate}    Convert Date    ${sales_rep}[Transaction date]    result_format=%d%m%Y 
                  ${exTransdate}    Convert To Number    ${exTransdate}
                  ${exRefno}    Set Variable    ${sales_rep}[reference No.]
                  ${exRefno}    Run Keyword If    '${exRefno}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exRefno}
                  ${exDetails}    Set Variable    ${sales_rep}[Details]
                  ${exDetails}    Run Keyword If    '${exDetails}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exDetails}
                  ${exDebit}    Set Variable    ${sales_rep}[Debit]
                  ${exDebit}    Run Keyword If    '${exDebit}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exDebit}
                  ${exCredit}    Set Variable    ${sales_rep}[Credit]
                  ${exCredit}    Run Keyword If    '${exCredit}' == 'None'    Set Variable    0    ELSE    Set Variable    ${exCredit}
                  Append To List    ${TransIDlist}    ${exTransID}
                  Append To List    ${Refnolist}    ${exRefno}
                  Append To List    ${Debitlist}    ${exDebit}
                  Append To List    ${Creditlist}    ${exCredit}
                  Append To List    ${Detailslist}    ${exDetails}
            END
        #    posting bankpages details
        ${list_length}=    Evaluate    len(${TransIDlist})
      #   FOR    ${counter}    IN RANGE    0    ${list_length}-1 
      #       IF    ${Debitlist}[${counter}] == 0
      #          ${payload1}    Set Variable         {"AccountCode": "${coded}", "CardCode": "${coded}", "CreditAmount": "${Creditlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "PaymentReference": ${Refnolist}[${counter}]}
      #       ELSE
      #          ${payload1}    Set Variable         {"AccountCode": "${coded}", "CardCode": "${coded}", "DebitAmount": "${Debitlist}[${counter}]", "DocNumberType": "bpdt_DocNum", "PaymentReference": ${Refnolist}[${counter}]} 
      #       END   
      #     ${response}=  Post Request  ${sessionname}    ${base_url}/BankPages  data=${payload1}  headers=${headers}
      #          Log To Console    Bank Pages: ${response.json()}

      #       IF    ${response.status_code} == 201
      #          Log To Console    successbankpages
      #       ELSE
      #          Log To Console    failbankpages
      #       END
      #   END
      
        
        # getting banktransaction details
        ${DebitAmount1list}=    Create List
        ${CreditAmount1list}=    Create List
         ${DueDate1list}=    Create List
         ${Memo1list}=    Create List
        FOR    ${counter}    IN RANGE    0    ${list_length}-1
            ${customer_response1}    Get Request    ${sessionname}    ${base_url}/BankPages?$select=AccountCode,PaymentReference,DueDate,CreditAmount,DebitAmount,Sequence,AccountName&$filter=AccountCode eq '${coded}' and CreditAmount eq ${Creditlist}[${counter}] and DebitAmount eq ${Debitlist}[${counter}]
               IF    ${customer_response1.status_code} == 200
                     ${customer_data1}    Set Variable    ${customer_response1.json()['value'][0]}
                     ${AccountCode}    Set Variable    ${customer_data1['AccountCode']}
                     ${Sequence}    Set Variable    ${customer_data1['Sequence']}
                     ${AccountName}    Set Variable    ${customer_data1['AccountName']}   
                     ${DueDate1}    Set Variable    ${customer_data1['DueDate']}   
                     ${DueDate1}    Convert Date    ${customer_data1['DueDate']}    result_format=%d%m%Y 
                     ${DueDate1}    Convert To Number    ${DueDate1}
                     ${Memo1}    Set Variable    ${customer_data1['PaymentReference']}
                     ${DebitAmount1}    Set Variable    ${customer_data1['DebitAmount']}
                     ${DebitAmount1}    Convert To Integer    ${DebitAmount1}
                     ${CreditAmount1}    Set Variable    ${customer_data1['CreditAmount']}
                     ${CreditAmount1}    Convert To Integer    ${CreditAmount1}  
                     Append To List    ${sequencelist}    ${Sequence}
                     Append To List    ${DebitAmount1list}    ${DebitAmount1}
                     Append To List    ${CreditAmount1list}    ${CreditAmount1}
                     Append To List    ${DueDate1list}    ${DueDate1}
                     Append To List    ${Memo1list}    ${Memo1}   
               ELSE
               Log To Console    failgetbankpages  
               END
            
   END

         # getting journal entries
         FOR    ${counter}    IN RANGE    0    ${list_length}
                     IF    ${TransIDlist}[${counter}] == 0
                           # IF    ${Creditlist}[${counter}] == 0
                           # ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank1}","Credit": ${Debitlist}[${counter}],"Debit": ${Creditlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank}","Credit": ${Creditlist}[${counter}],"Debit": ${Debitlist}[${counter}],"BPLID": 1}]}
                          
                           # ELSE
                           # ${PAYLOAD2}    Set Variable         {"JournalEntryLines": [{"AccountCode": "${bank}","Credit": ${Creditlist}[${counter}],"Debit": ${Debitlist}[${counter}],"BPLID": 1},{"AccountCode": "${bank1}","Credit": ${Debitlist}[${counter}],"Debit": ${Creditlist}[${counter}],"BPLID": 1}]}
                           # END
                           # ${response}=  Post Request  ${sessionname}    ${base_url}/JournalEntries  data=${PAYLOAD2}  headers=${headers}
                           # IF    ${response.status_code} == 201
                           #    Log To Console    successjournalentry
                           # ELSE
                           #     Log To Console    failjournalentry
                           #  END
                           Log to console    trans
                     ELSE
                        ${customer_response}    Get Request    ${sessionname}    ${base_url}/JournalEntries(${TransIDlist}[${counter}])/JournalEntryLines
                              IF    ${customer_response.status_code} == 200
                                 ${customer_datad}    Set Variable    ${customer_response.json()['JournalEntryLines']}
                                 ${count}=    Set Variable    0
                                 #getting count of journal entries lines storing count variable
                                       FOR    ${dict}    IN    @{customer_datad}
                                          ${line_id}=    Get From Dictionary    ${dict}    Line_ID
                                          ${count}=    Evaluate    ${count}+1    
                                       END
                              #iterate the journal entries lines to get the match details
                                       FOR    ${counter}    IN RANGE    0    ${count}    
                                             ${customer_data}    Set Variable    ${customer_response.json()['JournalEntryLines'][${counter}]}
                                             ${DebitAmount}    Set Variable    ${customer_data['Debit']}
                                             ${DebitAmount}    Convert To Integer    ${DebitAmount}
                                             ${CreditAmount}    Set Variable    ${customer_data['Credit']}
                                             ${CreditAmount}    Convert To Integer    ${CreditAmount}
                                             ${Line_ID}    Set Variable    ${customer_data['Line_ID']}  
                                             ${Memo}    Set Variable    ${customer_data['LineMemo']}
                                             FOR    ${counter1}    IN RANGE    0    ${list_length}-1    
                                                ${memo1}    Run Keyword And Ignore Error    Should Be Equal As Strings    ${Memo}    ${Detailslist}[${counter1}]
                                             ${memo1}    Set Variable    ${memo1}[0]
                                             Run Keyword And Ignore Error    ${CreditAmount1list}[${counter1}] == ${CreditAmount} and ${memo1} ==PASS and ${DebitAmount1list}[${counter1}] == ${DebitAmount} 
                                                      Append To List    ${linidlist}    ${Line_ID}     
                                             END

                                       END
                              ELSE
                                    Log To Console     fail
                              END
                     END

         END
         log to console    ${sequencelist} 
            ${sequencelist}    Remove Duplicates    ${sequencelist}
            ${linidlist}    Remove Duplicates    ${linidlist}
            ${TransIDlist}    Remove Duplicates    ${TransIDlist}
         # posting external reconciliation
         # posting ExternalReconciliation    ${linidlist}    ${TransIDlist}    ${coded}    ${sequencelist}  ${headers}

posting ExternalReconciliation 
    [Arguments]    ${linidlist}    ${TransIDlist}    ${coded}    ${sequencelist}    ${headers}  
       ${payload3}    Set Variable  {"ExternalReconciliation": {"ReconciliationAccountType": "${datatype}","ReconciliationBankStatementLines":[{"BankStatementAccountCode": "${coded}","Sequence": ${sequencelist}[0]},{"BankStatementAccountCode": "${coded}","Sequence": ${sequencelist}[1]}],"ReconciliationJournalEntryLines":[{"LineNumber": ${linidlist}[0],"TransactionNumber": ${TransIDlist}[0]},{"LineNumber": ${linidlist}[1],"TransactionNumber": ${TransIDlist}[1]}]}}          
         ${response1}=  Post Request  ${sessionname}    ${base_url}/ExternalReconciliationsService_Reconcile  data=${payload3}  headers=${headers}
         log to console    ${payload3}
         log to console    ${response1.status_code}      
        IF    ${response1.status_code} == 204
            Log To Console    success
        ELSE
         
            Log To Console    fail
            Log To Console    ${response1.json()}
        END
    