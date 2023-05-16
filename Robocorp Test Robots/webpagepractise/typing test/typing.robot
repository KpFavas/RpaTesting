* Settings *
Library    RPA.Desktop
Library    RPA.Browser.Selenium    auto_close=${FALSE}

* Variables *
${url}          https://www.typingtest.com/
${start_button}      xpath://button[contains(text(), "Start Test")]
${test_text}        xpath://div[@id="test-example"]/p
${agree}    xpath://*[@id="qc-cmp2-ui"]/div[2]/div/button[2]
* Tasks *
Fast Typing Test
    Open Available Browser    ${url}
    Maximize Browser Window
    Sleep   3
    Click Element    ${agree} 
    Click Element    ${start_button}
   
    Sleep   3



Close Browser