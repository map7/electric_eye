Feature: Electric Eye
  In order to record cameras
  I want to have an easy to use interface

  Scenario: Basic UI
    When I get help for "electric_eye"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should include the version
    And the banner should document that this app takes options
    And the banner should document that this app's arguments are:
    | camera | which is optional |
    | url    | which is optional |
    And the following options should be documented:
    | --add      |
    | --remove   |
    | --duration |
    | --path     |
    | --list     |
    | --start    |

  Scenario: Record cameras
    Given I have a camera called "Reception"
    When I successfully run `electric_eye --start`
    Then the exit status should be 0
    And the stdout should contain "Cameras recording"
