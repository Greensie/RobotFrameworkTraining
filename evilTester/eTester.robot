Language: En

*** Keywords ***
GoToTestPageEdge
    Open Browser    ${url}    edge

GoToTestPageChrome
    Open Browser    ${url}    Chrome

GoToMainPageAndCloseBrowser
    Click Element    href=index.html
    Close Browser

CleanupAfterTest
    Close Browser

*** Variables ***
${url}            https://testpages.eviltester.com/styled/index.html
${jsondatatochange}    [{"name" : "John", "age" : 111}, {"name": "Jose", "age" : 51}]
@{expected_result}    Bob    George    John    Jose

*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
TC_001_BasicWebPageExample
    [Documentation]    Test Objective: Get text from a website paragraphs
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Basic Web Page Example
    ...    2. Check if paragraph 1 contains correct massage
    ...    3. Check if paragraph 2 contains correct massage
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Setup]    GoToTestPageEdge
    Click Element    id=basicpagetest
    Element Should Contain    id=para1    A paragraph of text
    Element Should Contain    id=para2    Another paragraph of text
    [Teardown]    CleanupAfterTest

TC_002_ElementAttributesExamples
    [Documentation]    Test Objective: Get text from a website paragraphs
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Element Attributes Examples
    ...    2. Check if paragraph 1 contains correct massage
    ...    3. Check if paragraph 2 contains correct massage
    ...    4. Click shown button
    ...    5. Check if paragraph 3 contains correct massage
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Setup]    GoToTestPageEdge
    Click Element    id=elementattributestest
    Element Should Contain    id=domattributes    This paragraph has attributes
    Element Should Contain    id=jsattributes    This paragraph has dynamic attributes
    Click Button    class=styled-click-button
    Element Should Contain    id=jsautoattributes    This paragraph has dynamic attributes
    [Teardown]    CleanupAfterTest

TC_003_FindByPlayground
    [Documentation]    Test Objective: Get text from a website paragraphs by name and id and compare them
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Find By Playground - Locator Examples
    ...    2. Check if paragraph entered by id contains text
    ...    3. Check if paragraph entered by name contains text
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Setup]    GoToTestPageEdge
    Click Element    id=findbytest
    ${p}=    Set Variable    //div[@id='div1']/p[@id='p
    ${pName}=    Set Variable    //div[@id='div1']/p[@name='pName
    ${closure}=    Set Variable    ']
    FOR    ${i}    IN RANGE    1    25
    ${id}=    Set Variable    ${p}${i}${closure}
    ${name}=    Set Variable    ${pName}${i}${closure}
    ${str1}=    Get Text    ${id}
    ${str2}=    Get Text    ${name}
    END
    [Teardown]    CleanupAfterTest

TC_004_HTMLTableTag
    [Documentation]    Test Objective: Get text from a HTML table displayed on page
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element HTML TABLE Tag
    ...    2. Check num of rows
    ...    3. Get data for name and amount
    ...    4. Log the data
    ...    5. Reapeat steps 3-4 for every row found
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    Table
    [Setup]    GoToTestPageEdge
    Click Element    id=tablestest
    Sleep    300ms
    ${rows}=    Get Element Count    //table[@id='mytable']/tbody/tr
    ${locator}=    Set Variable    //table[@id='mytable']/tbody/tr[
    ${name_closing}=    Set Variable    ]/td[1]
    ${amount_closing}=    Set Variable    ]/td[2]
    FOR    ${row_num}    IN RANGE    2    ${rows+1}
        ${name_cell}=    Get Text    ${locator}${row_num}${name_closing}
        ${amount_cell}=    Get Text    ${locator}${row_num}${amount_closing}
        Log    ${row_num}
        Log    ${name_cell}
        Log    ${amount_cell}
    END
    [Teardown]    CleanupAfterTest

TC_004_HTMLTableTagBasic
    [Documentation]    Test Objective: Get text from a HTML table displayed on page - Debug Tool
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element HTML TABLE Tag
    ...    2. Check num of rows
    ...    3. Get name data
    ...    4. Get amount data
    ...    5. Log the data
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    Table
    [Setup]    GoToTestPageEdge
    Click Element    id=tablestest
    Sleep    300ms
    ${rows}=    Get Element Count    //table[@id='mytable']/tbody/tr
    ${name_cell}=    Get Text    //table[@id='mytable']/tbody/tr[2]/td[1]
    ${amount_cell}=    Get Text    //table[@id='mytable']/tbody/tr[2]/td[2]
    Log    ${name_cell}
    Log    ${amount_cell}
    [Teardown]    CleanupAfterTest

TC_005_DynamicHTMLTableTag
    [Documentation]    Test Objective: Get text from a HTML dinamic table displayed on page, modify table and get changed data
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Dynamic HTML TABLE Tag
    ...    2. Check num of rows
    ...    3. Get name data
    ...    4. Get age data
    ...    5. Compare name data to the expected data
    ...    6. Reapeat steps 3-5 for all rows
    ...    7. Reel out table menu
    ...    8. Change table data via json textarea
    ...    9. Click the button to refresh table
    ...    10. Get name data
    ...    11. Get age data
    ...    12. Compare name data to the expected data
    ...    13. Reapeat steps 10-12 for all rows
    ...    14. Imput new table caption
    ...    15. Click the button to refresh table
    ...    16. Compare table caption if it equals new value
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    Table
    [Setup]    GoToTestPageChrome
    Click Element    id=dynamictablestest
    Sleep    300ms
    ${rows}=    Get Element Count    //table[@id='dynamictable']/tr
    ${locator}=    Set Variable    //table[@id='dynamictable']/tr[
    ${name_closing}=    Set Variable    ]/td[1]
    ${age_closing}=    Set Variable    ]/td[2]
    ${table_caption}=    Get Text    //table/caption
    Should Be Equal    ${table_caption}    Dynamic Table
    FOR    ${row_num}    IN RANGE    2    ${rows+1}
        ${name_cell}=    Get Text    ${locator}${row_num}${name_closing}
        ${amount_cell}=    Get Text    ${locator}${row_num}${age_closing}
        Should Be Equal    ${name_cell}    ${expected_result}[${row_num-2}]
    END
    Click Element    //details/summary
    Sleep    500 ms
    Input Text    //details/div/p/textarea[@id='jsondata']    ${jsondatatochange}
    Click Button    //details/div/button
    Sleep    500 ms
    FOR    ${row_num}    IN RANGE    2    ${rows+1}
        ${name_cell}=    Get Text    ${locator}${row_num}${name_closing}
        ${amount_cell}=    Get Text    ${locator}${row_num}${age_closing}
        Should Be Equal    ${name_cell}    ${expected_result}[${row_num}]
    END
    Input Text    //details/div/p/input[@id='caption']    Different Table
    Click Button    //details/div/button
    ${table_caption2}    Get Text    //table/caption
    Should Be Equal    ${table_caption2}    Different Table
    [Teardown]    CleanupAfterTest

TC_006_AlertBoxExamples
    [Documentation]    Test Objective: Click buttons and handle alerts
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Alert Box Examples
    ...    2. Click button 'Show alert box'
    ...    3. Wait for alert
    ...    4. Handle alert with accept
    ...    5. Get text confirming the alert was handled proper way
    ...    6. Reapeat steps for 'Show confirm box' button and 'Show propt box'
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    AlertBox
    [Setup]    GoToTestPageChrome
    Click Element    id=alerttest
    Sleep    100ms
    Click Button    //div/input[@id='alertexamples']
    Sleep    200ms
    Alert Should Be Present    action=ACCEPT    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='alertexplanation']
    ${explenation_expected}=    Set Variable    You triggered and handled the alert dialog
    Should Be Equal    ${explanation}    ${explenation_expected}
    Sleep    200ms
    Click Button    //div/input[@id='confirmexample']
    Alert Should Be Present    action=ACCEPT    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='confirmexplanation']
    ${explenation_expected}=    Set Variable    You clicked OK, confirm returned true.
    Should Be Equal    ${explanation}    ${explenation_expected}
    Sleep    200ms
    Click Button    //div/input[@id='promptexample']
    Alert Should Be Present    action=ACCEPT    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='promptexplanation']
    ${explenation_expected}=    Set Variable    You clicked OK. 'prompt' returned change me
    Should Be Equal    ${explanation}    ${explenation_expected}
    [Teardown]    CleanupAfterTest

TC_006_AlertBoxExamplesNegative
    [Documentation]    Test Objective: Click buttons and handle alerts
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Alert Box Examples
    ...    2. Click button 'Show alert box'
    ...    3. Wait for alert
    ...    4. Handle alert with dissmis
    ...    5. Get text confirming the alert was handled proper way
    ...    6. Reapeat steps for 'Show confirm box' button and 'Show propt box'
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    AlertBox    Negative
    [Setup]    GoToTestPageChrome
    Click Element    id=alerttest
    Sleep    100ms
    Click Button    //div/input[@id='alertexamples']
    Sleep    200ms
    Alert Should Be Present    action=ACCEPT    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='alertexplanation']
    ${explenation_expected}=    Set Variable    You triggered and handled the alert dialog
    Should Be Equal    ${explanation}    ${explenation_expected}
    Sleep    200ms
    Click Button    //div/input[@id='confirmexample']
    Alert Should Be Present    action=DISMISS    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='confirmexplanation']
    ${explenation_expected}=    Set Variable    You clicked Cancel, confirm returned false.
    Should Be Equal    ${explanation}    ${explenation_expected}
    Sleep    200ms
    Click Button    //div/input[@id='promptexample']
    Alert Should Be Present    action=DISMISS    timeout=100ms
    ${explanation}=    Get Text    //div/p[@id='promptexplanation']
    ${explenation_expected}=    Set Variable    You clicked Cancel. 'prompt' returned null
    Should Be Equal    ${explanation}    ${explenation_expected}
    [Teardown]    CleanupAfterTest

TC_007_FakeAlertBoxExamples
    [Documentation]    Test Objective: Click buttons and handle alerts
    ...
    ...    Test steps:
    ...    [SETUP] Open Browser and enter https://testpages.eviltester.com/styled/index.html
    ...    1. Click element Alert Box Examples
    ...    2. Click button 'Show fake alert box'
    ...    3. Wait for alert
    ...    4. Click fake alert box to close it
    ...    5. Click button 'Show modal dialog'
    ...    6. Wait for alert
    ...    7. Click fake alert box to close it
    ...    [TEARDOWN]
    ...    Clowse Browser
    [Tags]    FakeAlerts
    [Setup]    GoToTestPageChrome
    Click Element    //a[@id='fakealerttest']
    Wait Until Page Contains    Fake Alert Box Examples    200ms
    Click Button    //input[@class='styled-click-button']
    Wait Until Element Is Visible    //div[@class='dialog-actions']/button[@id='dialog-ok']    200ms
    Click Button    //div[@class='dialog-actions']/button[@id='dialog-ok']
    Sleep    50ms
    Click Button    //input[@id='modaldialog']
    Wait Until Element Is Visible    //div[@class='dialog-actions']/button[@id='dialog-ok']    200ms
    Click Button    //div[@class='dialog-actions']/button[@id='dialog-ok']
    [Teardown]    CleanupAfterTest
