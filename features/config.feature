Feature: Config Electric Eye
  In order to record cameras
  I want to easily setup cameras and other variables
  So we can just start and stop the recordings

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
    And within the file "~/.electric_eye/config.yml" we should no cameras
    And the stdout should contain "Camera removed"

  Scenario: List cameras
    Given I have a camera called "Reception"
    When I successfully run `electric_eye -l`
    Then the exit status should be 0
    And within the file "~/.electric_eye/config.yml" we should have the camera "Reception"
    And the stdout should contain "Cameras"
    And the stdout should contain "Reception"

  Scenario: Set duration
    When I successfully run `electric_eye -d 10`
    Then the exit status should be 0
    And within the file "~/.electric_eye/config.yml" we should have the duration "10"
    And the stdout should contain "Duration set to 10 seconds"

  Scenario: Set path
    When I successfully run `electric_eye -p '/data/recordings'`
    Then the exit status should be 0
    And within the file "~/.electric_eye/config.yml" we should have the path "/data/recordings"
    And the stdout should contain "Path set to /data/recordings"

