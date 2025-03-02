*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}      https://the-internet.herokuapp.com/
${browser}      chrome
${headless_browser}     headlesschrome
${login}    admin
${pass}     admin

*** Keywords ***
Cleanup
    close browser

Prepare
    open browser    ${url}      ${browser}

Prepare Headless
    open browser    ${url}      ${headless_browser}

*** Test Cases ***
TC_001
    [documentation]  Clicking button in a page
    [tags]  Done
    Prepare
    click element       XPath=//a[text()='Add/Remove Elements']
    sleep   300ms
    click element       //div[@class='example']/button
    Cleanup

TC_002
    [documentation]  Clicking button multiple times in a page
    [tags]  Done
    Prepare
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
    [tags]  TBD
    ${path}=    Set Variable    /basic_auth
    ${cred}=    Set Variable     ${login}:${pass}@
    ${tempurl}=     Set Variable    ${cred}${url}${path}
    open browser    ${tempurl}      ${browser}
    sleep   500ms
    Page Should Contain     Basic Auth
    Cleanup

TC_004
    [documentation]  Checking if images are on a page
    [tags]  Done
    Prepare
    click element       XPath=//a[text()='Broken Images']
    Page Should Contain     Broken Images
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='img/avatar-blank.jpg']
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='asdf.jpg']
    Page Should Contain Image       XPath=//div[@id='content']/div[@class='example']/img[@src='hjkl.jpg']
    Cleanup

TC_005
    [documentation]  Checking items in table
    [tags]  Done
    @{resTab}=   Create List  Iuvaret0	Apeirian0	Adipisci0	Definiebas0	    Consequuntur0	Phaedrum0   edit delete
    Prepare
    click element       XPath=//a[text()='Challenging DOM']
    Sleep   200ms
    Page Should Contain     Challenging DOM
    ${rows}=    Get Element Count    //table/tbody/tr
    FOR     ${i}    IN RANGE    1   ${rows+1}
        ${elements}=    Get Element Count   //table/tbody/tr[${i}]/td
        FOR     ${j}    IN RANGE    1   ${elements+1}
            ${v}=   Get Text    //table/tbody/tr[${i}]/td[${j}]
            Run Keyword If  '${i}' == '1'    Should be Equal    ${v}     ${resTab}[${j-1}]
            Log     ${v}
        END
    END
    Cleanup


TC_006
    [documentation]  Checking Canvas value is changing
    [tags]  InProgress
    Prepare Headless
    click element       XPath=//a[text()='Challenging DOM']
    Sleep   200ms
    Page Should Contain     Challenging DOM
    FOR     ${i}    IN RANGE    10
        ${canvas_data}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Click Element       XPath=//div[@class='large-2 columns']//a[@class='button']
        ${canvas_data2}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Should Not Be Equal     ${canvas_data}      ${canvas_data2}
    END
    FOR     ${i}    IN RANGE    10
        ${canvas_data}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Click Element       XPath=//div[@class='large-2 columns']//a[@class='button alert']
        ${canvas_data2}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Should Not Be Equal     ${canvas_data}      ${canvas_data2}
    END
    FOR     ${i}    IN RANGE    10
        ${canvas_data}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Click Element       XPath=//div[@class='large-2 columns']//a[@class='button success']
        ${canvas_data2}    Execute JavaScript    return document.querySelector('canvas').toDataURL("image/png");
        Should Not Be Equal     ${canvas_data}      ${canvas_data2}
    END
    Cleanup
