*** Settings ***
Library   SeleniumLibrary
Library   OperatingSystem

*** Variables ***
${url}      https://the-internet.herokuapp.com/
${browser}      chrome
${headless_browser}     headlesschrome
${login}    admin
${pass}     admin
${absolute_path}    SecretPATH

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
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Dynamic Content']
    Wait Until Page Contains   Dynamic Content
    FOR     ${i}    IN RANGE    1   4
        ${text}=    Get Text    XPath=(//div[contains(@class, 'large-10') and contains(@class, 'columns')])[${i}]
        ${img}=    Get Element Attribute   XPath=(//div[contains(@class, 'large-2') and contains(@class, 'columns')])[${i}]//img    src
        Reload Page
        ${textcpr}=  Get Text    XPath=(//div[contains(@class, 'large-10') and contains(@class, 'columns')])[${i}]
        ${imgcpr}=    Get Element Attribute   XPath=(//div[contains(@class, 'large-2') and contains(@class, 'columns')])[${i}]//img   src
        Run Keyword And Warn On Failure     Should Not Be Equal     ${text}    ${textcpr}   #as the images sometimes are randomly the same
        Run Keyword And Warn On Failure     Should Not Be Equal     ${img}    ${imgcpr}
    END
    Cleanup

TC_013
    [documentation]  Dynamic Controls
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Dynamic Controls']
    Wait Until Page Contains   Dynamic Controls
    Page Should Contain     A checkbox
    Click Element       XPath=//form[@id='checkbox-example']/div/input
    Checkbox Should Be Selected     XPath=//form[@id='checkbox-example']/div/input
    Click Element   XPath=//form[@id='checkbox-example']/button[text()='Remove']
    Wait Until Page Contains Element    XPath=//form[@id='checkbox-example']/button[text()='Add']       10s
    Click Element   XPath=//form[@id='checkbox-example']/button[text()='Add']
    Wait Until Page Contains Element    XPath=//form[@id='checkbox-example']/button[text()='Remove']      10s
    Click Element   XPath=//form[@id='input-example']/button[text()='Enable']
    Wait Until Page Contains Element    XPath=//form[@id='input-example']/button[text()='Disable']      10s
    Input Text      XPath=//form[@id='input-example']/input   AbCdEfGHiJKlMNoP
    Click Element   XPath=//form[@id='input-example']/button[text()='Disable']
    Wait Until Page Contains Element    XPath=//form[@id='input-example']/button[text()='Enable']      10s
    Cleanup

TC_014
    [documentation]  Dynamic Loading
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Dynamic Loading']
    Wait Until Page Contains   Dynamically Loaded Page Elements
    ${taburl}=      Get Element Attribute    XPath=//div[@id='content']/div[@class='example']/a     href
    Open Browser    ${taburl}      ${browser}
    Wait Until Page Contains   Example 1: Element on page that is hidden
    Click Element   XPath=//div[@id='content']/div[@class='example']/div[@id='start']/button
    Wait Until Page Contains    Hello World!    10s
    Cleanup
    Prepare
    Click Element       XPath=//a[text()='Dynamic Loading']
    Wait Until Page Contains   Dynamically Loaded Page Elements
    ${taburl}=      Get Element Attribute    XPath=//div[@id='content']/div[@class='example']/a[2]     href
    Open Browser    ${taburl}      ${browser}
    Wait Until Page Contains   Example 2: Element rendered after the fact
    Click Element   XPath=//div[@id='content']/div[@class='example']/div[@id='start']/button
    Wait Until Page Contains    Hello World!    10s
    Close Window
    Cleanup

TC_015
    [documentation]  Entry Ad
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Entry Ad']
    Wait Until Element Is Visible       XPath=//div[@class='modal-footer']/p
    Click Element       XPath=//div[@class='modal-footer']/p
    Cleanup

TC_016
    [documentation]  Exit Intent
    [tags]  Done    Issue
    Prepare
    Click Element       XPath=//a[text()='Exit Intent']
    Wait Until Page Contains   Mouse out of the viewport pane and see a modal window appear.
    Mouse Out    XPath=//h3[text()='Exit Intent']
    Cleanup

TC_017
    [documentation]  File Download
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='File Download']
    Wait Until Page Contains   File Downloader
    Click Element       XPath=//div[@class='example']/a[text()='2.png']
    Sleep   2s
    File Should Exist   2.png
    Cleanup

TC_018
    [documentation]  File Upload
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='File Upload']
    Wait Until Page Contains   Choose a file on your system and then click upload. Or, drag and drop a file into the area below.
    Choose File   XPath=//input[@id='file-upload']   ${absolute_path}   #run with command robot --variable absolute_path:*path* -i InProgress .\tihk.robot
    Click Element       XPath=//input[@class='button']
    Cleanup