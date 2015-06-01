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

  Scenario: Add camera
    Given I have a camera called "Reception"
    When I successfully run `electric_eye --add Reception rtsp://user:passwd@192.168.0.100/live.sdp`
    Then the exit status should be 0
    And we should have a directory called "~/.electric_eye"
    And we should have a file called "~/.electric_eye/config.yml"
    And the stdout should contain "Camera added"
