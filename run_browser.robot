*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${browser}      chrome
@{list_of_browsers}     chrome  edge
${url}      https://the-internet.herokuapp.com/

*** Test Cases ***
Run Browser
    FOR     ${i}    IN      @{list_of_browsers}
    open browser    ${url}  ${i}
    close browser
    END