Language: En

*** Keywords ***
GoToHomePage
    Open Browser    ${url}    edge

Login
    Input Text    id=user-name    ${name}
    Input Password    id=password    ${password}
    Click Button    id=login-button

Logout
    Click Element    id=react-burger-menu-btn
    Sleep    100 ms
    Click Element    id=logout_sidebar_link

LoginBadUser
    Input Text    id=user-name    ${bad_user}
    Input Password    id=password    ${password}
    Click Button    id=login-button

GoToHomePage2
    Open Browser    ${url}    Chrome

LoginAllGoodUsers
    FOR    ${item}    IN    @{CREDENTIALS}
        Input Text    id=user-name    ${item}
        Input Password    id=password    ${password}
        Click Button    id=login-button
        Click Element    id=react-burger-menu-btn
        Sleep    100 ms
        Click Element    id=logout_sidebar_link
        Sleep    300 ms
    END

AddTestItemToCart
    Click Button    id=add-to-cart-sauce-labs-backpack
    Sleep    100 ms
    Click Element    id=shopping_cart_container
    Sleep    100 ms
    Click Button    id=remove-sauce-labs-backpack

*** Variables ***
${url}            https://www.saucedemo.com
${name}           standard_user
${password}       secret_sauce
@{CREDENTIALS}    standard_user    problem_user    error_user    visual_user
&{LOGIN}          Username=standard_user    Password=secret_sauce
${bad_user}       locked_out_user
@{browsers}       edge    chrome
@{items_add}      id=add-to-cart-sauce-labs-backpack    id=add-to-cart-sauce-labs-bike-light    id=add-to-cart-sauce-labs-bolt-t-shirt    id=add-to-cart-sauce-labs-fleece-jacket    id=add-to-cart-sauce-labs-onesie    id=add-to-cart-test.allthethings()-t-shirt-(red)
@{items_remove}    id=remove-sauce-labs-backpack    id=remove-sauce-labs-bike-light    id=remove-sauce-labs-onesie    id=remove-sauce-labs-bolt-t-shirt    id=remove-sauce-labs-fleece-jacket
@{TestUser}       John    Doe    00-999
@{imagesid}       id=item_0_img_link    id=item_1_img_link    id=item_2_img_link    id=item_3_img_link    id=item_4_img_link    id=item_5_img_link
@{items_names}    Sauce Labs Bike Light    Sauce Labs Bolt T-Shirt    Sauce Labs Onesie    Test.allTheThings() T-Shirt (Red)    Sauce Labs Backpack    Sauce Labs Fleece Jacket
@{subpages_names}    www.saucedemo.com/inventory-item.html?id=0    www.saucedemo.com/inventory-item.html?id=1    www.saucedemo.com/inventory-item.html?id=2    www.saucedemo.com/inventory-item.html?id=3    www.saucedemo.com/inventory-item.html?id=4    www.saucedemo.com/inventory-item.html?id=5

*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
TC_001_LoginStandardUser
    [Documentation]    Test Objective: Check login procedure of standard user
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Logout
    ...    4. Close Edge
    ...    5. Open Open https://www.saucedemo.com/ on Edge
    ...    6. Login standard_user
    ...    7. Logout
    ...    8. Close Chrome
    ...
    ...    Pass Criteria: Succesfull login and logout procedure of standard user on both browsers.
    [Tags]    Login    Chrome    Edge
    FOR    ${web}    IN    @{browsers}
    Open Browser    ${url}    ${web}
    Login
    Logout
    Close Browser
    END

TC_002_LoginAllPossibleUsers_Edge
    [Documentation]    Test Objective: Check login procedure of all working users
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login user from list
    ...    3. Logout user
    ...    4. Take next user from list and repeat step 2 and 3
    ...    5. Close browser
    ...
    ...
    ...    Pass Criteria: Succesfull login and logout procedure of all users on Edge.
    [Tags]    Login    Edge
    GoToHomePage
    FOR    ${item}    IN    @{CREDENTIALS}
        Input Text    id=user-name    ${item}
        Input Password    id=password    ${password}
        Click Button    id=login-button
        Click Element    id=react-burger-menu-btn
        Sleep    100 ms
        Click Element    id=logout_sidebar_link
        Sleep    300 ms
    END
    Close Browser

TC_002_LoginAllPossibleUsers_Chrome
    [Documentation]    Test Objective: Check login procedure of all working users
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login user from list
    ...    3. Logout user
    ...    4. Take next user from list and repeat step 2 and 3
    ...    5. Close browser
    ...
    ...    Pass Criteria: Succesfull login and logout procedure of all users on Edge.
    [Tags]    Login    Chrome
    GoToHomePage
    FOR    ${item}    IN    @{CREDENTIALS}
        Input Text    id=user-name    ${item}
        Input Password    id=password    ${password}
        Click Button    id=login-button
        Click Element    id=react-burger-menu-btn
        Sleep    100 ms
        Click Element    id=logout_sidebar_link
        Sleep    300 ms
    END
    Close Browser

TC_003_LoginFail
    [Documentation]    INCOMPLETE
    ...    Test Objective: Check login procedure of all not working users
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login user from list
    ...    3. Check if error appears
    ...    4. Take next user from list and repeat step 2 and 3
    ...    5. Close browser
    ...
    ...    Pass Criteria: Lack of succesfull login and of wrong users on both browsers.
    [Tags]    Login     InProgress
    GoToHomePage
    LoginBadUser
    Page Should Contain    Epic sadface: Sorry, this user has been locked out.
    Close Browser

TC_004_AddingItemToCart_Edge
    [Documentation]    Test Objective: Check adding an item to a cart and removing it
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Add item to a cart
    ...    4. Enter cart
    ...    5. Remove item from cart
    ...    6. Logout
    ...    7. Close browser
    ...
    ...    Pass Criteria: Succesfull adding and removing an item from cart.
    [Tags]    Cart    Edge
    GoToHomePage
    Login
    Sleep    100 ms
    Click Button    id=add-to-cart-sauce-labs-backpack
    Sleep    100 ms
    Click Element    id=shopping_cart_container
    Sleep    1 second100 ms
    Click Button    id=remove-sauce-labs-backpack
    Logout
    Close Browser

TC_004_AddingItemToCart_Chrome
    [Documentation]    Test Objective: Check adding an item to a cart and removing it
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Chrome
    ...    2. Login standard_user
    ...    3. Add item to a cart
    ...    4. Enter cart
    ...    5. Remove item from cart
    ...    6. Logout
    ...    7. Close browser
    ...
    ...
    ...    Pass Criteria: Succesfull adding and removing an item from cart.
    [Tags]    Cart    Chrome
    GoToHomePage
    Login
    Sleep    100 ms
    Click Button    id=add-to-cart-sauce-labs-backpack
    Sleep    100 ms
    Click Element    id=shopping_cart_container
    Sleep    1 second100 ms
    Click Button    id=remove-sauce-labs-backpack
    Logout
    Close Browser

TC_005_AddingMultipleItemsToCart_Edge
    [Documentation]    Test Objective: Check adding multiple items to a cart and removing them
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Add items to a cart
    ...    4. Enter cart
    ...    5. Remove items from cart
    ...    6. Logout
    ...    7. Close browser
    ...
    ...    Pass Criteria: Succesfull adding and removing items from cart.
    [Tags]    Login    Cart    Edge
    GoToHomePage
    Login
    FOR    ${item}    IN    @{items_add}
        Click Button    ${item}
        Sleep    100 ms
    END
    Click Element    id=shopping_cart_container
    Sleep    100 ms
    FOR    ${item}    IN    @{items_remove}
        Click Button    ${item}
        Sleep    100 ms
    END
    Logout
    Close Browser

TC_005_AddingMultipleItemsToCart_Chrome
    [Documentation]    Test Objective: Check adding multiple items to a cart and removing them
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Chrome
    ...    2. Login standard_user
    ...    3. Add items to a cart
    ...    4. Enter cart
    ...    5. Remove items from cart
    ...    6. Logout
    ...    7. Close browser
    ...
    ...    Pass Criteria: Succesfull adding and removing items from cart.
    [Tags]    Login    Cart    Chrome
    GoToHomePage
    Login
    FOR    ${item}    IN    @{items_add}
        Click Button    ${item}
        Sleep    100 ms
    END
    Click Element    id=shopping_cart_container
    Sleep    100 ms
    FOR    ${item}    IN    @{items_remove}
        Click Button    ${item}
        Sleep    100 ms
    END
    Logout
    Close Browser

TC_006_OrderingAnItem_Edge
    [Documentation]    Test Objective: Check ordering procedure
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Add item to a cart
    ...    4. Enter cart
    ...    5. Enter checkout
    ...    6. Enter user data
    ...    7. Finish checkout
    ...    8. Go back to main page
    ...    9. Logout
    ...    10. Close browser
    ...
    ...    Pass Criteria: Succesfull processing whole ordering process
    [Tags]    Cart    Order
    GoToHomePage
    Login
    AddTestItemToCart
    Sleep    500ms
    Click Element    id=shopping_cart_container
    Sleep    500ms
    Click Button    id=checkout
    Sleep    500ms
    Input Text    id=first-name    ${TestUser}[0]
    Input Text    id=last-name    ${TestUser}[1]
    Input Text    id=postal-code    ${TestUser}[2]
    Sleep    500ms
    Click Button    id=continue
    Sleep    500ms
    Click Button    id=finish
    Sleep    500ms
    Click Button    id=back-to-products
    Logout
    Close Browser

TC_006_OrderingAnItem_Chrome
    [Documentation]    Test Objective: Check ordering procedure
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Add item to a cart
    ...    4. Enter cart
    ...    5. Enter checkout
    ...    6. Enter user data
    ...    7. Finish checkout
    ...    8. Go back to main page
    ...    9. Logout
    ...    10. Close browser
    ...
    ...    Pass Criteria: Succesfull processing whole ordering process
    [Tags]    Cart    Order    Chrome
    GoToHomePage
    Login
    AddTestItemToCart
    Sleep    500ms
    Click Element    id=shopping_cart_container
    Sleep    500ms
    Click Button    id=checkout
    Sleep    500ms
    Input Text    id=first-name    ${TestUser}[0]
    Input Text    id=last-name    ${TestUser}[1]
    Input Text    id=postal-code    ${TestUser}[2]
    Sleep    500ms
    Click Button    id=continue
    Sleep    500ms
    Click Button    id=finish
    Sleep    500ms
    Click Button    id=back-to-products
    Logout
    Close Browser

TC_007_EnterProdcutsPages
    [Documentation]    Test Objective: Check all items subpages and adding items to cart on subpage
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Click on item image
    ...    4. Enter subpage
    ...    5. Add item to cart
    ...    6. Go back to main page
    ...    7. Reapeat steps 3-6 on all items
    ...    8. Remove all items from cart from main page
    ...    9. Logout
    ...    10. Close browser
    ...
    ...    Pass Criteria: Succesfull enering all subpages via images, adding items to cart on subpage and removing them on main page
    [Tags]    Edge    Subpage    Cart
    GoToHomePage
    Login
    FOR    ${item}    IN    @{imagesid}
    Click Element    ${item}
    Sleep    100 ms
    Click Button    id=add-to-cart
    Sleep    100ms
    Click Button    id=back-to-products
    END
    FOR    ${item}    IN    @{items_remove}
        Click Button    ${item}
        Sleep    100 ms
    END
    Logout
    Close Browser

TC_008_AddItemsToCartThenRemoveThemInSubpages
    [Documentation]    Test Objective: Check all items subpages and adding items to caart on main page and remove them from cart on subpage
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Add all items to cart
    ...    4. Enter subpage
    ...    5. Remove item from cart
    ...    6. Go back to main page
    ...    7. Reapeat steps 4-6 on all items
    ...    8. Enter Cart
    ...    9. Verify that cart is empty
    ...    9. Logout
    ...    10. Close browser
    ...
    ...    Pass Criteria: Succesfull adding all items to cart on main page then enering all subpages via images, removing items from cart on subpage and confirming that cart is empty.
    [Tags]    Edge    Subpage    Cart
    GoToHomePage
    Login
    FOR    ${item}    IN    @{items_add}
        Click Button    ${item}
        Sleep    1 second
    END
    FOR    ${item}    IN    @{imagesid}
    Click Element    ${item}
    Sleep    100 ms
    Click Button    id=remove
    Sleep    100ms
    Click Button    id=back-to-products
    END
    Page Should Not Contain    Remove
    Logout
    Close Browser

TC_009_TestThatAllPhotosDirectToGoodSubpage
    [Documentation]    Test Objective: Check all items photos redirect to correct subpage
    ...
    ...    Test steps:
    ...    1. Open https://www.saucedemo.com/ on Edge
    ...    2. Login standard_user
    ...    3. Click on item photo
    ...    4. Enter subpage
    ...    5. Check if page contain item name
    ...    6. Go back to main page
    ...    7. Reapeat steps 3-6 on all items
    ...    8. Logout
    ...    9. Close browser
    ...
    ...    Pass Criteria: Succesfull checking all subpages that contain proper items.
    [Tags]    Edge    Items    Subpage
    GoToHomePage
    Login
    FOR    ${i}    IN RANGE    5
    Click Element    ${imagesid}[${i}]
    Sleep    100 ms
    Page Should Contain    ${items_names}[${i}]
    Sleep    100 ms
    Click Button    id=back-to-products
    END
    Logout
    Close Browser