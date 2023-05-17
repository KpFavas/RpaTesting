*** Settings ***
Library    RPA.PDF
Library    PyPDF2
*** Tasks ***
main 
    ${p}    Is Pdf Encrypted    wordtopd.pdf
    Log To Console    ${p}
    Encrypt Pdf    wordtopd.pdf       user_pwd=1234568
     ${d}    Is Pdf Encrypted    wordtopd.pdf
    Log To Console    ${d}
*** Variables ***

*** Keywords ***
main pdf
  