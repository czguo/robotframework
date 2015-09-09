*** Setting ***
Documentation     Test that properties, most importantly java bean properties
...               generated by Jython, are not called at test library creation.
...               See issue 188 for more details.
Suite Setup       Run Tests    ${EMPTY}    test_libraries/avoid_properties_when_creating_libraries.robot
Force Tags        regression
Resource          atest_resource.robot

*** Test Case ***
Java Bean Property
    [Tags]    only-jython
    Check Test Case    ${TEST NAME}

Java Bean Property In Class Extended In Python
    [Tags]    only-jython
    Check Test Case    ${TEST NAME}

Python Property
    Check Test Case    ${TEST NAME}
