*** Settings ***
Documentation     Send Whatsapp Message
Resource    whatsapp.robot

*** Variables***
${whatsapp_no}=  919361426458
${message}=  "Hi sivaji how are you"

*** Tasks ***
Main Task
    Send Message AttachBrowser  ${whatsapp_no}  ${message} 