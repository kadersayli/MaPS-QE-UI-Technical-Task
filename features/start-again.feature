
@Navigation @StartAgain
Feature: Start again throughout the holiday entitlement calculator
    As a calculator user
    I want to restart at any stage after my first answer
    So that I can begin a fresh calculation

    Scenario: Restart works at every reachable question and result page
        Given I am on the holiday entitlement calculator start page
        When I click on the "Start now" button
        Then the "Start again" link should work on every reachable calculator page
