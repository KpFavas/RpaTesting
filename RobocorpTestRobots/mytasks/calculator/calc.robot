*** Settings ***
Documentation       Template robot main suite.
Resource            calcall.robot


*** Task ***
Open calculator
    Open Calculator

Add Two Numbers
    Addition    10  10
    Subtraction  20   5   

Close calculator
    Close Calculator