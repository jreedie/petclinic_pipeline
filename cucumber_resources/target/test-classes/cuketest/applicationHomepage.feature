# language: en
Feature: Loads the application homepage

  @browser
  Scenario: The user goes to the homepage
    Given Open Firefox and launch the application
    Then The server responds with the homepage