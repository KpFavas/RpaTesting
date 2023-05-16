** Settings **

Library    RequestsLibrary
Library    Collections
Library    RPA.Excel.Files
** Variables **
${base_url}    http://socius.sapserver.in:50001/b1s/v1
${username}    {"CompanyDB": "SBODemoGB","UserName": "favas"}
${password}    Test@123
${session_name}    mysession

${Excel_Path}    input/invoice.xlsx
** Tasks **
main task 
    main page
     second
** Keywords **
main page
    ${auth_data}=    Create List    ${username}    ${password}
    Create Session    ${sessionname}    ${base_url}    auth=${auth_data}
 second
    Open Workbook    ${Excel_Path}
    ${sales_reps}=    Read Worksheet As Table    header=True
    FOR    ${sales_rep}    IN    @{sales_reps}
        ${customer_response}    Get Request    ${sessionname}    ${base_url}/Invoices(${sales_rep}[DocNum])    
        # log to console        ${customer_response.text}
        ${customer_data}    Set Variable            ${customer_response.json()}
        ${PaidToDate}       Set Variable            ${customer_data['PaidToDate']}
        ${DocTotal}         Set Variable            ${customer_data['DocTotal']}
        ${PaidToDate}       Convert To Integer      ${PaidToDate}
        ${DocTotal}         Convert To Integer      ${DocTotal}
        ${exPaidToDate}     Set Variable            ${sales_rep}[PaidToDate]
        ${exDocTotal}       Set Variable            ${sales_rep}[DocTotal]
        ${exPaidToDate}     Convert To Integer      ${exPaidToDate}
        ${exDocTotal}       Convert To Integer      ${exDocTotal}
       
        IF  ${PaidToDate} ==${exPaidToDate} and ${DocTotal} ==${exDocTotal}  
            Log To Console      DocNum: ${customer_data['DocNum']}
            Log To Console      PaidToDate: ${customer_data['PaidToDate']}
            Log To Console      DocTotal: ${customer_data['DocTotal']}  
            Log To Console      PAID
        ELSE
            Log To Console      DocNum: ${customer_data['DocNum']}
            Log To Console      UN-PAID
        END
        
    END
      
    
    