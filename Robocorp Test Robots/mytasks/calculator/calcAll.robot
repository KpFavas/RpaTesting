***Settings
Library    Collections

Library    String

Library    RPA.Desktop

Library    RPA.Desktop.Windows

***Variables***
${calc}     Calc.exe
${title}    Calculator


***Keywords***
Open Calculator
    Open Executable     ${calc}     ${title}

Close Calculator
    Mouse Click    id:Close

Addition
    [Arguments]     ${first}      ${second}
    ${first_digits}     Split String To Characters      ${first}
    FOR     ${i}    IN  @{first_digits}
        Mouse Click     id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:plusButton
    ${second_digits}     Split String To Characters      ${second}
    FOR     ${i}    IN  @{second_digits}
        Mouse Click     id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:equalButton

Subtraction
    [Arguments]     ${first}      ${second}
    Sleep   2
    Mouse Click     id:clearButton

    ${first_digits}     Split String To Characters      ${first}
    FOR     ${i}    IN  @{first_digits}
        Mouse Click     id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:minusButton
    ${second_digits}     Split String To Characters      ${second}
    FOR     ${i}    IN  @{second_digits}
        Mouse Click     id:num${i}Button
    END
    Sleep    1
    Mouse Click    id:equalButton
    Sleep   3

