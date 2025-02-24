*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}      https://the-internet.herokuapp.com/
${headless_browser}     headlesschrome

*** Test Cases ***
Opening and closing browser
    open browser    ${url}      ${headless_browser}
    close browser