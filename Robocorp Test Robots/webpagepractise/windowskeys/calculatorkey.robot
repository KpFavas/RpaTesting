*** Settings ***
Library    RPA.Desktop.Windows
Library    Collections
Library    String
Library    RPA.Desktop
*** Variables ***
${url}    calc.exe
${title}    Calculator
*** Keywords ***

Open calculator
    Open Executable    ${url}    ${title}

close calculator
    Mouse Click    id:Close


ADDITION
   [Arguments]    ${first}    ${second}
   ${first_char}     Split String To Characters    ${first}
   FOR    ${i}    IN    @{first_char}
      Mouse Click    id:num${i}Button
   END
   Sleep    1
   Mouse Click    id:plusButton
   ${second_char}=    Split String To Characters    ${second}
   FOR    ${i}    IN    @{second_char}
       Mouse Click    id:num${i}Button
   END
   Sleep    1
   Mouse Click    id:equalButton
   ${result} =     Get Text    id:CalculatorResults
   ${my_value}=    Get From Dictionary    ${result}    legacy_name  
   Log To Console    "addition value ${my_value} "
   Sleep    2
   Mouse Click    id:clearButton

SUBTRACTION
    [Arguments]    ${first}    ${second}
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:minusButton
    ${second_char}=    Split String To Characters    ${second}
    FOR    ${i}    IN    @{second_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
     Mouse Click    id:equalButton
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console   "subtraction value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton
MULTIPLICATION
    [Arguments]    ${first}    ${second}
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:multiplyButton
    ${second_char}=    Split String To Characters    ${second}
    FOR    ${i}    IN    @{second_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
     Mouse Click    id:equalButton
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console    "multiplication value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton
Division
    [Arguments]    ${first}    ${second}
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:divideButton
    ${second_char}=    Split String To Characters    ${second}
    FOR    ${i}    IN    @{second_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
     Mouse Click    id:equalButton
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console    "division value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton

PERCENTAGE
    [Arguments]    ${first}    ${second}
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:percentButton
    ${second_char}=    Split String To Characters    ${second}
    FOR    ${i}    IN    @{second_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
     Mouse Click    id:equalButton
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console    "percentage value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton
FRACTION
    [Arguments]    ${first}    
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:invertButton
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console    "fraction value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton
SQUARE 
     [Arguments]    ${first}    
    ${first_char}=    Split String To Characters    ${first}
    FOR    ${i}    IN    @{first_char}
       Mouse Click    id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:xpower2Button
     ${result} =     Get Text    id:CalculatorResults
      ${my_value}=    Get From Dictionary    ${result}    legacy_name  
     Log To Console    "square value ${my_value}"
     Sleep    2
     Mouse Click    id:clearButton