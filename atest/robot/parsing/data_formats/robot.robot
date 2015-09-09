*** Settings ***
Force Tags      regression
Resource        formats_resource.robot

*** Test Cases ***
One ROBOT
    Run sample file and check tests  ${ROBOT DIR}${/}sample.robot

ROBOT With ROBOT Resource
    Previous Run Should Have Been Successful
    Check Test Case  Resource File

ROBOT Directory
    Run Suite Dir And Check Results  ${ROBOT DIR}

Directory With ROBOT Init
    Previous Run Should Have Been Successful
    Check Suite With Init  ${SUITE.suites[1]}

