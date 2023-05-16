*** Settings ***
Library    RPA.Browser
Library    Process

*** Variables ***
${phone_no}=  918247810154
${message}=  Hello World!

*** Keywords ***
Send Message AttachBrowser
    [Arguments]  ${phone_no}   ${message}
    #RPA.Browser.Close All Browsers
    Process.Run Process    ${CURDIR}/scripts/killChromeAllInstances.bat
    Sleep    5
    Process.Run Process    ${CURDIR}/scripts/chrome_remote_devtools.bat
    Sleep    5
    RPA.Browser.Attach Chrome Browser    9222
    RPA.Browser.Go To  https://api.whatsapp.com/send/?phone=${phone_no}&text=${message}
    RPA.Browser.Maximize Browser Window
    RPA.Browser.Set Selenium Timeout    30
    Sleep    5
    RPA.Browser.Click Element    //a[@id='action-button']
    Sleep    5
    RPA.Browser.Click Element    //a[normalize-space()='use WhatsApp Web']
    Sleep    20
    RPA.Browser.Click Element    //*[@id="main"]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button/span