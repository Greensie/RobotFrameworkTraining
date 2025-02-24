*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}      https://the-internet.herokuapp.com/
${browser}      chrome

*** Test Cases ***
Clicking buttons
    open browser        ${url}      ${browser}
    sleep    700ms
    click element       XPath=//a[text()='Add/Remove Elements']
    sleep   300ms
    click element       //div[@class='example']/button
    close browser