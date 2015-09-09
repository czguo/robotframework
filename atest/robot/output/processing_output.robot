*** Settings ***
Documentation   Testing reading and processing data from xml outputs generated by Robot or Rebot itself.
Force Tags      regression
Resource        atest_resource.robot

*** Test Cases ***
Test Case File Suite
    [Documentation]  Testing that output file created from simple test case file is correct.
    My Run Robot And Rebot  ${EMPTY}  misc/normal.robot
    Should Be Equal  ${SUITE.name}  Normal
    Should Be Equal  ${SUITE.doc}  Normal test cases
    Should Be Equal  ${SUITE.metadata['Something']}  My Value
    Should Be Equal as Strings   ${SUITE.metadata}  {Something: My Value}
    Check Normal Suite Defaults  ${SUITE}
    Should Be Equal  ${SUITE.full_message}  2 critical tests, 2 passed, 0 failed\n 2 tests total, 2 passed, 0 failed
    Should Be Equal  ${SUITE.statistics.message}  2 critical tests, 2 passed, 0 failed\n 2 tests total, 2 passed, 0 failed
    Should Contain Tests  ${SUITE}  First One  Second One

Directory Suite
    [Documentation]  Testing suite created from a test suite directory. Also testing metadata from cli.
    My Run Robot And Rebot  --metadata x:y -M a:b --name My_Name --doc Something  misc/suites
    Should Be Equal  ${SUITE.name}  My Name
    Should Be Equal  ${SUITE.doc}  Something
    Should Be Equal  ${SUITE.metadata['x']}  y
    Should Be Equal  ${SUITE.metadata['a']}  b
    Should Be True   ${SUITE.metadata.items()} == [('a', 'b'), ('x', 'y')]
    Check Suite Got From misc/suites/ Directory

Minimal hand-created output
    [Documentation]  Testing minimal hand created suite with tests or subsuites
    Run Rebot  --log log_from_created_output.html  rebot/created_normal.xml
    File Should Not Be Empty    ${OUTDIR}/log_from_created_output.html
    Check Names  ${SUITE}  Root
    Should Contain Suites  ${SUITE}  Sub 1  Sub 2
    Check Names  ${SUITE.suites[0]}  Sub 1  Root.
    Check Names  ${SUITE.suites[1]}  Sub 2  Root.
    Check Minimal Suite Defaults  ${SUITE}
    Check Minimal Suite Defaults  ${SUITE.suites[0]}
    Check Minimal Suite Defaults  ${SUITE.suites[1]}
    Should Contain Tests  ${SUITE}  Test 1.1  Test 1.2  Test 2.1
    Check Names  ${SUITE.suites[0].tests[0]}  Test 1.1  Root.Sub 1.
    Check Names  ${SUITE.suites[0].tests[1]}  Test 1.2  Root.Sub 1.
    Check Names  ${SUITE.suites[1].tests[0]}  Test 2.1  Root.Sub 2.

*** Keywords ***
My Run Robot And Rebot
    [Arguments]  ${params}  @{paths}
    Run Tests Without Processing Output  ${params}  @{paths}
    Run Rebot  ${EMPTY}  ${OUTFILE}

Check Normal Suite Defaults
    [Arguments]  ${mysuite}  ${message}=  ${tests}=[]  ${setup}=${None}  ${teardown}=${None}
    Log  ${mysuite.name}
    Check Suite Defaults  ${mysuite}  ${message}  ${tests}  ${setup}  ${teardown}
    Check Normal Suite Times  ${mysuite}

Check Minimal Suite Defaults
    [Arguments]  ${mysuite}  ${message}=
    Check Suite Defaults  ${mysuite}  ${message}
    Check Minimal Suite Times  ${mysuite}

Check Normal Suite Times
    [Arguments]  ${mysuite}
    Is Valid Timestamp  ${mysuite.starttime}
    Is Valid Timestamp  ${mysuite.endtime}
    Is Valid Elapsed Time  ${mysuite.elapsedtime}
    Should Be True  ${mysuite.elapsedtime} >= 1

Check Minimal Suite Times
    [Arguments]  ${mysuite}
    Should Be Equal  ${mysuite.starttime}  ${NONE}
    Should Be Equal  ${mysuite.endtime}  ${NONE}
    Should Be Equal  ${mysuite.elapsedtime}  ${0}

Check Suite Defaults
    [Arguments]  ${mysuite}  ${message}=  ${tests}=[]  ${setup}=${None}  ${teardown}=${None}
    Should Be Equal  ${mysuite.message}  ${message}
    Check Setup Or Teardown  ${mysuite.setup}  ${setup}
    Check Setup Or Teardown  ${mysuite.teardown}  ${teardown}

Check Setup Or Teardown
    [Arguments]    ${item}    ${expected}
    ${actual} =  Set Variable If  "${expected}" == "None"  ${item}  ${item.name}
    Should Be Equal    ${actual}    ${expected}

Check Suite Got From Misc/suites/ Directory
    Check Normal Suite Defaults  ${SUITE}  teardown=BuiltIn.Log
    Should Be Equal  ${SUITE.status}  FAIL
    Should Contain Suites  ${SUITE}  Fourth  Subsuites  Subsuites2  Tsuite1  Tsuite2  Tsuite3
    Should Be Empty  ${SUITE.tests}
    Should Contain Suites  ${SUITE.suites[1]}  Sub1  Sub2
    Should Be True  ${SUITE.suites[0].suites} + ${SUITE.suites[1].suites[0].suites}+ ${SUITE.suites[1].suites[1].suites}+ ${SUITE.suites[2].suites[0].suites}+ ${SUITE.suites[3].suites} + ${SUITE.suites[4].suites} + ${SUITE.suites[5].suites}== []
    Should Contain Tests  ${SUITE}  SubSuite1 First  SubSuite2 First  SubSuite3 First  SubSuite3 Second  Suite1 First  Suite1 Second
    ...  Third In Suite1  Suite2 First  Suite3 First  Suite4 First  Test From Sub Suite 4
    Check Normal Suite Defaults  ${SUITE.suites[0]}  ${EMPTY}  []  teardown=BuiltIn.Log
    Check Normal Suite Defaults  ${SUITE.suites[1]}
    Check Normal Suite Defaults  ${SUITE.suites[1].suites[0]}  setup=BuiltIn.Log  teardown=BuiltIn.No Operation
    Check Normal Suite Defaults  ${SUITE.suites[1].suites[1]}
    Check Normal Suite Defaults  ${SUITE.suites[2].suites[0]}
    Check Normal Suite Defaults  ${SUITE.suites[3]}
    Check Normal Suite Defaults  ${SUITE.suites[4]}

