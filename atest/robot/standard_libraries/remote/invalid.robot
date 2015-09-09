*** Settings ***
Suite Setup      Run Remote Tests    invalid.robot    invalid.py
Force Tags       regression
Resource         remote_resource.robot

*** Test Cases ***
Non dict result dict
    Check Test Case    ${TESTNAME}

Invalid result dict
    Check Test Case    ${TESTNAME}

Invalid char in XML
    [Tags]    no-ipy
    Check Test Case    ${TESTNAME}

Exception
    Check Test Case    ${TESTNAME}

Broken connection
    Check Test Case    ${TESTNAME}
