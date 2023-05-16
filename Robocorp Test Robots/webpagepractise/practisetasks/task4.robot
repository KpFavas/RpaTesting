*** Settings ***
Library    RPA.Desktop.Windows
Library    RPA.Desktop.OperatingSystem
Library    Process
*** Tasks ***
calculator
    open calculator
*** Keywords ***
open calculator
    Open Executable    calc.exe    calculator
    