*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.JavaAccessBridge
Library    RPA.Word.Application

*** Tasks ***
main
    Login page
    Second page
    third browser
    fourth browser
*** Keywords ***
Login page
    Open Available Browser    https://www.countries-ofthe-world.com/flags-of-the-world.html    maximized=${True}
     Sleep    2
      Execute Javascript    window.scrollTo(0,2000)
    Sleep    2
    Execute Javascript    window.scrollTo(0,document.body.scroll.height)
    Sleep    2
    Execute Javascript    window.scrollTo(0,-document.body.scroll.height)
    Sleep    2
    Scroll Element Into View    xpath://*[@id="content"]/div[2]/div[2]/table[1]/tbody/tr[86]/td[1]
Second page
    Go To    https://www.selenium.dev/selenium/docs/api/java/index.html?overview-summary.html
third browser
    Open Available Browser    https://demo.automationtesting.in/Windows.html    maximized=${True}
    Click Button    xpath://*[@id="Tabbed"]/a/button
    ${test}    Get Title
    Log To Console    ${test}
    Switch Window    title=Selenium
    Sleep    2
    ${test1}    Get Title
    Log To Console    ${test1}
    Set Selenium Timeout    2
    Click Link    xpath:/html/body/div/main/section[2]/div/div/div[1]/div/div[2]/div/a
    Set Selenium Timeout    3
    Sleep    2
    Switch Window    title=Frames & windows
    Set Browser Implicit Wait    5
    Click Link    xpath:/html/body/div[1]/div/div/div/div[1]/ul/li[2]/a
    Sleep    2
fourth browser
    open Available browser  https://demo.automationtesting.in/Windows.html
    Click Button    xpath://*[@id="Tabbed"]/a/button
    Switch Window    title=Selenium
    Click Link    xpath:/html/body/div/main/section[2]/div/div/div[1]/div/div[2]/div/a
    Switch Browser    1
    Sleep    3
    Close Browser
    Close All Browsers

