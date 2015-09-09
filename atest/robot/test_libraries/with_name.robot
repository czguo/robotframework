*** Settings ***
Suite Setup       Run 'With Name' Tests
Force Tags        regression
Resource          atest_resource.robot

*** Test Cases ***
Import Library Normally Before Importing With Name In Another Suite
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    OperatingSystem.Should Exist    args=*
    Keyword Data Should Be    ${tc.kws[1]}    ParameterLibrary.Parameters    \${p1}, \${p2}
    Check Syslog Contains    Imported library 'OperatingSystem' with arguments [ ] (version ${ROBOT VERSION}, class type, global scope,
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ before1 | before2 ] (version <unknown>, class type, testcase scope,

Import Library With Name Before Importing With Name In Another Suite
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    Params.Parameters    \${p1}, \${p2}
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ after1 | after2 ] (version <unknown>, class type, testcase scope,

Import Library Normally After Importing With Name In Another Suite
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    OperatingSystem.Should Exist    args=*
    Keyword Data Should Be    ${tc.kws[1]}    ParameterLibrary.Parameters    \${p1}, \${p2}

Import Library With Name After Importing With Name In Another Suite
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    Params.Parameters    \${a1}, \${a2}

Name Given Using "With Name" Can Be Reused In Different Suites
    ${tc} =  Check Test Case  Import Library With Name Before Importing With Name In Another Suite
    Keyword Data Should Be    ${tc.kws[0]}  Params.Parameters  \${p1}, \${p2}
    ${tc} =  Check Test Case  Name Given Using "With Name" Can Be Reused in Different Suites
    Keyword Data Should Be    ${tc.kws[0]}  Params.Keyword In My Lib File
    Check Log Message  ${tc.kws[0].msgs[0]}  Here we go!!
    ${tc} =  Check Test Case  Import Library With Name After Importing With Name In Another Suite
    Keyword Data Should Be    ${tc.kws[0]}  Params.Parameters  \${a1}, \${a2}

No Arguments
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    OS.Directory Should Exist    args=*
    Keyword Data Should Be    ${tc.kws[1]}    OS.Should Exist    args=*
    Check Syslog Contains    Imported library 'OperatingSystem' with name 'OS'

Embedded Arguments
    ${tc} =    Check Test Case    ${TEST NAME}
    Check Log Message    ${tc.kws[0].msgs[0]}    arg
    Check Log Message    ${tc.kws[1].msgs[0]}    --args--

Arguments Containing Variables And Import Same Library Twice
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    Param1.Parameters    \${a1}, \${a2}
    Keyword Data Should Be    ${tc.kws[3]}    Param2.Parameters    \${a1}, \${a2}
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ 1 | 2 ] (version <unknown>, class type, testcase scope,
    Check Syslog Contains    Imported library 'ParameterLibrary' with name 'Param1'
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ VAR | 42 ] (version <unknown>, class type, testcase scope,
    Check Syslog Contains    Imported library 'ParameterLibrary' with name 'Param2'

Alias Containing Variable
    Check Test Case    ${TEST NAME}

With Name Has No Effect If Not Second Last
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    ParameterLibrary.Parameters    \${a1}, \${a2}
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ whatever | with name ] (version <unknown>, class type, testcase scope,

With Name After Normal Import
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    B2.Fail    args=This failure comes from B2!
    Check Syslog Contains    Imported library 'BuiltIn' with name 'B2'

Module Library
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    MOD1.Argument    args=Hello
    Keyword Data Should Be    ${tc.kws[1]}    mod 2.Keyword From Submodule    \${s}    Tellus
    Keyword Data Should Be    ${tc.kws[3]}    MOD1.Failing
    Check Syslog Contains    Imported library 'module_library' with name 'MOD1'
    Check Syslog Contains    Imported library 'pythonmodule.library' with name 'mod 2'

Java Library
    [Tags]    only-jython
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    Java Lib.Return String From Library    \${s}    whatever
    Keyword Data Should Be    ${tc.kws[2]}    Java Lib.Get Java Object    \${obj}    My Name
    Check Syslog Contains    Imported library 'ExampleJavaLibrary' with name 'Java Lib'

Java Library In Package
    [Tags]    only-jython
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[0]}    Java Pkg.Return Value    \${s1}
    Keyword Data Should Be    ${tc.kws[1]}    Java Pkg.Return Value    \${s2}    Returned string value
    Check Syslog Contains    Imported library 'javapkg.JavaPackageExample' with name 'Java Pkg'

Import Library Keyword
    ${tc} =    Check Test Case    ${TEST NAME}
    Keyword Data Should Be    ${tc.kws[1]}    MyOS.Directory Should Exist    args=*
    Keyword Data Should Be    ${tc.kws[3]}    MyParamLib.Parameters    \${a1}, \${a2}

Correct Error When Using Keyword From Same Library With Different Names Without Prefix
    Check Test Case    ${TEST NAME} 1
    Check Test Case    ${TEST NAME} 2
    Check Test Case    ${TEST NAME} 3

Dynamic Library
    Check Test Case    ${TEST NAME}

Dynamic Java Library
    [Tags]    only-jython
    Check Test Case    ${TEST NAME}

Global Scope
    Check Test Case    ${TEST NAME} 1.1
    Check Test Case    ${TEST NAME} 1.2
    Check Test Case    ${TEST NAME} 2.1
    Check Test Case    ${TEST NAME} 2.2

Test Suite Scope
    Check Test Case    ${TEST NAME} 1.1
    Check Test Case    ${TEST NAME} 1.2
    Check Test Case    ${TEST NAME} 2.1
    Check Test Case    ${TEST NAME} 2.2

Test Case Scope
    Check Test Case    ${TEST NAME} 1.1
    Check Test Case    ${TEST NAME} 1.2
    Check Test Case    ${TEST NAME} 2.1
    Check Test Case    ${TEST NAME} 2.2

With Name When Library Arguments Are Not Strings
    Check Syslog Contains    Imported library 'ParameterLibrary' with arguments [ 1 | 2 ]

*** Keywords ***
Run 'With Name' Tests
    Run Tests    ${EMPTY}
    ...    test_libraries/with_name_1.robot
    ...    test_libraries/with_name_2.robot
    ...    test_libraries/with_name_3.robot
    Should Be Equal    ${SUITE.name}    With Name 1 & With Name 2 & With Name 3
