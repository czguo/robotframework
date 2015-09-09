*** Settings ***
Test Setup      Empty output directory
Force Tags      regression
Resource        rebot_cli_resource.robot

*** Test Cases ***
Timestamped Outputs
    @{files} =  Run rebot and return outputs  --TimeStampOutputs
    Length Should Be  ${files}  2
    : FOR  ${file}  IN  @{files}
    \  Should Match Regexp  ${file}  (log|report)-20\\d{6}-\\d{6}\\.html

Timestamped Outputs With Custom Names
    @{files} =  Run rebot and return outputs  --timest -l l -r r.html -o o
    Length Should Be  ${files}  3
    : FOR  ${file}  IN  @{files}
    \  Should Match Regexp  ${file}  (l|o|r|s)-20\\d{6}-\\d{6}\\.(html|xml)

