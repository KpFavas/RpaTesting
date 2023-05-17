** Settings **
Documentation    account reconciliation using RPA 
Library    RequestsLibrary
Library    Collections
Library    RPA.Excel.Files
Library    String
Library    DateTime
Library    RPA.Browser.Selenium
Library    base64

** Variables **

${base_url}         http://socius.sapserver.in:50001/b1s/v1
${username}         {"CompanyDB": "SBODemoGB","UserName": "favas"}
${password}         Test@123
${sessionname}      mysession
${url}              input/OBK-Sheets.xlsx
${datatype}         rat_BusinessPartner
${json_data}      {"AccountCode": "ACUST0004", "CardCode": "ACUST0004", "DebitAmount": "4800", "DocNumberType": "bpdt_DocNum", "PaymentReference": "first pay"}
# ${headers}        Content-Type: application/json
${bank}             208010
${auth_header}      ${username}:${password}
${headers}          Content-Type: application/json

*** Tasks ***

main task   
   main page
   sample
*** Keywords ***
main page
   ${auth_data}=    Create List    ${username}    ${password}
   Create Session    ${sessionname}    ${base_url}/Login    auth=${auth_data}
sample
   # ${payloadCred}    Set Variable    {"AccountCode": "ACUST0004", "CardCode": "ACUST0004", "CreditAmount": "4800", "DocNumberType": "bpdt_DocNum", "PaymentReference": "first pay"}
   # ${headers}=  Create Dictionary  Content-Type=application/json
    
   # ${auth_string}=    Catenate    basic    ${username}:${password}
   #  ${auth_encoded}=    Convert To Base64    ${auth_string}
   # ${headers}=     Create Dictionary    Authorization=Basic ${auth_string}
   # Log To Console    ${json_data}
   # Log To Console    ${headers}
   # Post Request      ${sessionname}    ${base_url}/BankPages    json=${json_data}    headers=${headers}
   # # ${response}=    Post Request    ${sessionname}    ${base_url}/BankPages    json=${payloadCred}    headers=${headers}
   # Log To Console      response:${response.json()}
   # Log To Console      response:${response.status_code}
