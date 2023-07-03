*** Settings ***
Library    RPA.Browser.Selenium         auto_close=${FALSE}

*** Variables ***
${BROWSER}    Chrome

*** Test Cases ***
Retrieve Browser Tab Details
    Open Available Browser    http://127.0.0.1:5500/src/index.html 
    
    # Check if the "from date" field has a value
    ${from_date_value}      Get Value    id=fromdate
    Log To Console      \nFrom Date: ${from_date_value}
    
    # Check if the "to date" field has a value
    ${to_date_value}        Get value    id=todate
    Log To Console      \nTo Date: ${to_date_value}  
    
