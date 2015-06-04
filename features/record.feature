Feature: Record
  In order to record cameras
  I need a way to start recordings per camera

  Scenario: Record cameras
    Given I have a camera called "Reception"
    When I successfully run `electric_eye --start`
    Then the exit status should be 0
    And it should create a pid file in "/tmp/electric_eye.pid"
    And the stdout should contain "Cameras recording"
