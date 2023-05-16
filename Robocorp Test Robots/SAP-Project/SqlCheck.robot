*** Settings ***
Library    mod.py
Library    String
Library    Collections
*** Variables ***
${driver}    SQL Server
${server}    sap-api.sociusus.com
${dabasename}    DemoDatabaseBLGR    
${username}    sa
${password}    L@vEn#22o2
${column values}    T0.ItemCode,T0.ItemName,T0.ItmsGrpCod,T0.InvntItem,T0.SellItem,T0.PrchseItem
${table_values}    OITM
# ${filtervalue1}    00,rice
*** Test Cases ***
Connect to mssql
    ${filtervalue1}    Create List    01    rice
    ${sql_query1}    Set Variable    SELECT ${column values} FROM ${table_values} T0 
    ${sql_query2}    Set Variable    SELECT ${column values} FROM ${table_values} T0 WHERE T0.ItemCode = ? and T0.ItemName = ? 
    ${connect}    Connect_to_server    ${driver}    ${server}    ${dabasename}    ${username}    ${password}    
    # ${gettingdata}    gettingdata    ${connect}    ${sql_query1}
    # Log To Console    ${gettingdata}
    ${gettingdata}    gettingdataparameter    ${connect}    ${sql_query2}    ${filtervalue1}  
    Log To Console    ${gettingdata}