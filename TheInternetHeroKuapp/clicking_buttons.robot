*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}      https://the-internet.herokuapp.com/
${browser}      chrome
${login}    admin
${pass}     admin

*** Test Cases ***
TC_001
    [documentation]  Clicking button in a page
    [tags]  Done
    open browser    ${url}      ${browser}
    click element       XPath=//a[text()='Add/Remove Elements']
    sleep   300ms
    click element       //div[@class='example']/button
    Cleanup

TC_002
    [documentation]  Clicking button multiple times in a page
    [tags]  Done
    open browser    ${url}      ${browser}
    click element       XPath=//a[text()='Add/Remove Elements']
    FOR     ${i}     IN RANGE        20
        click element       XPath=//div[@class='example']/button
        sleep   150ms
        click element       XPath=//div[@id='elements']/button
        sleep   150ms
    END
    Cleanup

TC_003
    [documentation]  Login onto Page with popup
    [tags]  Done
    ${path}=    Set Variable    /basic_auth
    ${cred}=    Set Variable     ${login}:${pass}@
    ${tempurl}=     Set Variable    ${cred}${url}${path}
    open browser    ${tempurl}      ${browser}
    sleep   500ms
    Cleanup

TC_004
    [documentation]  Checking if images are on a page
    [tags]  Done
    open browser    ${url}      ${browser}
    click element       XPath=//a[text()='Broken Images']
    Page Should Contain     Broken Images
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='img/avatar-blank.jpg']
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='asdf.jpg']
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='hjkl.jpg']
    Cleanup

TC_005
    [documentation]  Checking if images are on a page
    [tags]  InProgress
    open browser    ${url}      ${browser}
    click element       XPath=//a[text()='Challenging DOM']

    Cleanup

*** Keywords ***
Cleanup
    close browser
