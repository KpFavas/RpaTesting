# *** Settings ***
# Library     RPA.HTTP

# *** Variables ***
# ${base_url}        https://sap-api.sociusus.com:50000/b1s/v1
# ${Invoice_data}     Invoice(1)
# ${update_data}     {"name": "Favas","job": "SE"}
# ${username}        {"CompanyDB": "SBODemoGB","UserName": "favas"}
# ${password}        Test@123
# *** Keywords ***


# *** Tasks ***
# Get Single Employee Detail
#     create session           mysession   ${base_url}
    
#     ${response}            get request  mysession    ${Invoice_data}
#     log to console         ${response.status_code}
#     log to console         ${response.text}

*** Settings ***

Library     RPA.HTTP

*** Variables ***

${pdf_path}     input/AR Sales Order.pdf




${base_url}        https://sap-api.sociusus.com:50000/b1s/v1
${Invoice_data}     Invoice
${update_data}     {"name": "Favas","job": "SE"}
${username}        {"CompanyDB": "SBODemoGB","UserName": "favas"}
${password}        Test@123


*** Keywords ***

Get Single Employee Detail
    ${auth}            Create Dictionary   UserName={"CompanyDB": "SBODemoGB","UserName": "favas"}    Password=${password}
    create session     mysession    ${base_url}    auth=${auth}
    ${response}        get request    mysession    ${Invoice_data}
    log to console     ${response.status_code}
    log to console     ${response.text}

Extract Sales Order Details from PDF



*** Tasks ***
