*** Settings ***
Documentation  Regard non-breaking spaces as normal spaces in parsing
Suite Setup    Run Tests  ${EMPTY}  parsing/nbsp.*
Force Tags     regression
Resource       atest_resource.robot


*** Test Cases ***

Non-breaking spaces in plain text file
    Check test case  ${TESTNAME}

Non-breaking spaces in plain text file with pipes
    Check test case  ${TESTNAME}

Non-breaking spaces in TSV file
    Check test case  ${TESTNAME}

Non-breaking spaces in HTML file
    Check test case  ${TESTNAME}
