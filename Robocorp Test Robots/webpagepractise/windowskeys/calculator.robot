*** Settings ***
Library    RPA.Desktop.Windows
Library    Collections
Library    String
Library    RPA.Desktop
Resource    calculatorkey.robot
*** Tasks ***
Open calculator and Write Data
    Open calculator 
    ADDITION    244333    702489332    
    SUBTRACTION    69    69
    SQUARE    69
    FRACTION    3
    MULTIPLICATION    10    400
    close calculator







# *** Keywords ***
# ADD2
#     [Arguments]    ${first}    ${second}
#     Mouse Click    id:num${first}Button
#     Mouse Click    id:plusButton
#     Mouse Click    id:num${second}Button
#      Mouse Click    id:equalButton
#      ${result} =     Get Text    id:CalculatorResults
#       ${data}=    Get Regexp Matches    ${result['legacy_name']}    (?<=Display is ).* 
#      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
#      Log To Console    ${data}
#      Log To Console      ${my_value}
#      Mouse Click    id:clearButton
#  SUB
#   [Arguments]    ${first}    ${second}
#     Mouse Click    id:num${first}Button
#     Mouse Click    id:minusButton
#     Mouse Click    id:num${second}Button
#      Mouse Click    id:equalButton  
#      ${result} =     Get Text    id:CalculatorResults
#      ${my_value}=    Get From Dictionary    ${result}    legacy_name
#      Log To Console      ${my_value}
#     Mouse Click    id:clearButton
# Multiply
#      [Arguments]    ${first}    ${second}
#     Mouse Click    id:num${first}Button
#     Mouse Click    id:multiplyButton
#     Mouse Click    id:num${second}Button
#      Mouse Click    id:equalButton 
#      ${result} =     Get Text    id:CalculatorResults
#      ${my_value}=    Get From Dictionary    ${result}    legacy_name
#      Log To Console      ${my_value}
#     Mouse Click    id:clearButton
# division
#      [Arguments]    ${first}    ${second}
#     Mouse Click    id:num${first}Button
#     Mouse Click    id:divideButton
#     Mouse Click    id:num${second}Button
#      Mouse Click    id:equalButton 
#      ${result} =     Get Text    id:CalculatorResults
#      ${my_value}=    Get From Dictionary    ${result}    legacy_name
#      Log To Console      ${my_value}
#     Mouse Click    id:clearButton