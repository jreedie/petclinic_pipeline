# language: en
Feature: Defines a person

  Scenario: A person is created
    Given Given a Person is named "Mike"
    Then Their name is recorded as "Mike"