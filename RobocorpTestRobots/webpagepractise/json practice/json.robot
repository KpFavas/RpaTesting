*** Settings ***
Documentation    
Library    RPA.JSON
Library    json
Library    OperatingSystem
*** Variables ***
${json_data}    {'name': 'John', 'age': 30, 'city': 'New York'}
*** Tasks ***
working main
    open json
    Add json to object
*** Keywords ***
open json
    ${file}    Load JSON from file    ${CURDIR}${/}example.json
    ${json_name}    Get value from JSON    ${file}    $.Name
    Log To Console    ${json_name}
Add json to object
     ${file}    Load JSON from file    ${CURDIR}${/}example.json
     ${dic}    Create Dictionary    name:dillibabu    age:21
    ${json}    Add to JSON    ${file}    $    ${dic}
    Log To Console    ${json}
      ${delete}    Delete from JSON    ${file}    $.dilli
      Log To Console    ${delete}
     