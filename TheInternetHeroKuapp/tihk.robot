*** Settings ***
Library   SeleniumLibrary
Library   OperatingSystem
Library   Collections

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

TC_019
    [documentation]  Floating Menu
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Floating Menu']
    Wait Until Page Contains    Floating Menu
    Element Should Be Visible       XPath=//div[@id='menu']/ul/li/a[text()='Contact']
    FOR     ${i}    IN RANGE    1   5
        ${x}=   Evaluate     1000*${i}
        Set Window Position     ${x}    100
        Element Should Be Visible       XPath=//div[@id='menu']/ul/li/a[text()='Contact']
    END
    Cleanup

TC_020
    [documentation]  Forgotten password
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Forgot Password']
    Wait Until Page Contains    Forgot Password
    ${mail}=    Set Variable   deffnotsomeonesmail@gmail.com
    Input Text      XPath=//input[@id='email']      ${mail}
    Click Element       XPath=//button[@id='form_submit']
    Wait Until Page Contains    Internal Server Error
    Cleanup

TC_021
    [documentation]  Form Authentication
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Form Authentication']
    Wait Until Page Contains    Login Page
    ${user}=    Set Variable   tomsmith
    ${pass}=    Set Variable    SuperSecretPassword!
    Input Text      XPath=//input[@id='username']      ${user}
    Input Password      XPath=//input[@id='password']       ${pass}
    Click Element       XPath=//button[@class='radius']/i
    Wait Until Page Contains    Secure Area
    Click Element       XPath=//a[@class='button secondary radius']/i
    Cleanup

TC_021_Negative
    [documentation]  Form Authentication
    [tags]  Done  Negative
    Prepare
    Click Element       XPath=//a[text()='Form Authentication']
    Wait Until Page Contains    Login Page
    ${user}=    Set Variable   Nottomsmith
    ${pass}=    Set Variable    SuperPublicPassword:(
    Input Text      XPath=//input[@id='username']      ${user}
    Input Password      XPath=//input[@id='password']       ${pass}
    Click Element       XPath=//button[@class='radius']/i
    Page Should Contain      Your username is invalid!
    Cleanup

TC_022
    [documentation]  Frames
    [tags]  Done
    @{exp}=     Create List      LEFT   MIDDLE  RIGHT   BOTTOM
    Prepare
    Click Element       XPath=//a[text()='Frames']
    Wait Until Page Contains    Frames
    Click Element       XPath=//a[text()='Nested Frames']
    Sleep   500ms
    Select Frame    XPath=//frame[@name='frame-top']
    Select Frame    XPath=//frame[@name='frame-left']
    ${left_txt}=    Get Text    XPath=//body
    Unselect Frame
    Select Frame    XPath=//frame[@name='frame-top']
    Select Frame    XPath=//frame[@name='frame-middle']
    ${mid_txt}=    Get Text    XPath=//body
    Unselect Frame
    Select Frame    XPath=//frame[@name='frame-top']
    Select Frame    XPath=//frame[@name='frame-right']
    ${right_txt}=    Get Text    XPath=//body
    Unselect Frame
    Select Frame    XPath=//frame[@name='frame-bottom']
    ${bot_txt}=    Get Text    XPath=//body
    Unselect Frame
    @{act}=     Create List     ${left_txt}     ${mid_txt}     ${right_txt}     ${bot_txt}
    Lists Should Be Equal   ${exp}  ${act}
    Cleanup

TC_023
    [documentation]  Horizontal Slider
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Horizontal Slider']
    Wait Until Page Contains    Horizontal Slider
    ${value}=    Get Text  XPath=//div[@class='sliderContainer']/span
    Should Be Equal As Numbers  ${value}    0
    Click Element At Coordinates    XPath=//div[@class='sliderContainer']/input     5   0
    ${value}=    Get Text  XPath=//div[@class='sliderContainer']/span
    Should Be Equal As Numbers  ${value}    2.5
    Cleanup

TC_024
    [documentation]  Hovers
    [tags]  Done
    Prepare
    Click Element       XPath=//a[text()='Hovers']
    Wait Until Page Contains    Hovers
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user1']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user2']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user3']
    Mouse Over      XPath=//div[@class='figure'][1]
    Element Should Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user1']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user2']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user3']
    Mouse Over      XPath=//div[@class='figure'][2]
    Element Should Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user2']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user1']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user3']
    Mouse Over      XPath=//div[@class='figure'][3]
    Element Should Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user3']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user1']
    Element Should Not Be Visible   XPath=//div[@class='figcaption']/h5[text()='name: user2']
    Cleanup

TC_025
    [documentation]  Inputs
    [tags]  Done    TBD
    Prepare
    Click Element       XPath=//a[text()='Inputs']
    Wait Until Page Contains    Inputs
    Input Text      XPath=//div[@class='example']/input     99999
    Cleanup

TC_026
    [documentation]  JQueryUI - Menu
    [tags]  InProgress
    Prepare
    Click Element       XPath=//a[text()='JQuery UI Menus']
    Wait Until Page Contains    UI element
    Mouse Over       XPath=//a[text()='Enabled']
    Wait Until Element Is Visible   XPath=//a[text()='Downloads']
    Mouse Over       XPath=//a[text()='Downloads']
    Wait Until Element Is Visible   XPath=//a[text()='PDF']
    Click Element       XPath=//a[text()='PDF']
    Click Element       XPath=//a[text()='Back to JQuery UI']
    File Should Exist   menu.pdf
    Wait Until Page Contains    JQuery UI
    Page Should Contain     set of Widgets
    Cleanup