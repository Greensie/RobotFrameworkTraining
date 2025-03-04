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
    Close Browser

Prepare
    Open Browser    ${url}      ${browser}

Prepare Headless
    Open Browser    ${url}      ${headless_browser}

Refresh Page Until Success
    Reload Page
    Page Should Contain Element     XPath=//a[text()='Gallery']
*** Test Cases ***
TC_001
    [documentation]  Clicking button in a page
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Add/Remove Elements']
    Sleep   300ms
    Click Element       //div[@class='example']/button
    Cleanup

TC_002
    [documentation]  Clicking button multiple times in a page
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Add/Remove Elements']
    FOR     ${i}     IN RANGE        20
        Click Element       XPath=//div[@class='example']/button
        Sleep   150ms
        Click Element       XPath=//div[@id='elements']/button
        Sleep   150ms
    END
    Cleanup

TC_003
    [documentation]  Login onto Page with popup
    [tags]  TBD
    ${path}=    Set Variable    /basic_auth
    ${cred}=    Set Variable     ${login}:${pass}@
    ${tempurl}=     Set Variable    ${cred}${url}${path}
    Open Browser    ${tempurl}      ${browser}
    Sleep   500ms
    Page Should Contain     Basic Auth
    Cleanup

TC_004
    [documentation]  Checking if images are on a page
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Broken Images']
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
    Click Element       XPath=//a[text()='Challenging DOM']
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
    [tags]  Done
    Prepare Headless
    Click Element       XPath=//a[text()='Challenging DOM']
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

TC_007
    [documentation]  Checking checkboxes
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Checkboxes']
    Sleep   500ms
    Page Should Contain     Checkboxes
    Checkbox Should Not Be Selected     XPath=//form[@id='checkboxes']/input[1]
    Checkbox Should Be Selected     XPath=//form[@id='checkboxes']/input[2]
    Click Element   XPath=//form[@id='checkboxes']/input[1]
    Click Element   XPath=//form[@id='checkboxes']/input[2]
    Checkbox Should Be Selected     XPath=//form[@id='checkboxes']/input[1]
    Checkbox Should Not Be Selected     XPath=//form[@id='checkboxes']/input[2]
    Cleanup

TC_008
    [documentation]  Context menus
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Context Menu']
    Sleep   500ms
    Page Should Contain     Context Menu
    Open Context Menu   XPath=//div[@id='hot-spot']
    Handle Alert
    Sleep   500ms
    Cleanup

TC_009
    [documentation]  Disappearing Element
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Disappearing Elements']
    Sleep   500ms
    Page Should Contain     Disappearing Elements
    Repeat Keyword      5 times     Run Keyword And Warn On Failure     Refresh Page Until Success
    Cleanup

TC_010
    [documentation]  Drag and drop element
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Drag and Drop']
    Wait Until Page Contains   Drag and Drop
    Drag And Drop   XPath=//div[@id='column-a']     XPath=//div[@id='column-b']
    Cleanup

TC_011
    [documentation]  Choose an option from dropdown list
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Dropdown']
    Wait Until Page Contains   Dropdown List
    Select From List By Value   XPath=//select[@id='dropdown']  1
    Select From List By Value   XPath=//select[@id='dropdown']  2
    Cleanup

TC_012
    [documentation]  Checking if dynamic content changes after refresh
    [tags]  TBD
    Prepare
    Click Element       XPath=//a[text()='Dynamic Content']
    Wait Until Page Contains   Dynamic Content
