Feature: Electric Eye
  In order to record cameras
  I want to do this easily with a script
  So I don't have to use some proprietary junk

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
    | --add    |
    | --remove |

  Scenario: Add camera
    When I successfully run `electric_eye -a Reception rtsp://user:passwd@192.168.0.100/live.sdp`
    Then the exit status should be 0
    And we should have a directory called "~/.electric_eye"
    And we should have a file called "~/.electric_eye/config.yml"
    And within the file "~/.electric_eye/config.yml" we should have the camera "Reception"
    And the stdout should contain "Camera added"

  Scenario: Remove camera
    Given I have a camera called "Reception"
    When I successfully run `electric_eye -r Reception`
    Then the exit status should be 0
    And we should have a directory called "~/.electric_eye"
    And we should have a file called "~/.electric_eye/config.yml"
    And within the file "~/.electric_eye/config.yml" we should no cameras
    And the stdout should contain "Camera removed"
