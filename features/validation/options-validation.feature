
@Validation @OptionsValidation
Feature: Holiday entitlement calculator radio-button validation
    As a calculator user
    I want to be informed when I miss a required question
    So that I can provide the necessary information

    @MissingRequiredOption
    Scenario Outline: Validate continuing without selecting a required option
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I click the "Continue" button
        Then I should see the "<Question>" page
        And I should see a required-answer validation error

        Examples: Required radio-button validation
            | Question                                                       | Question Path                   |
            | Does the employee work irregular hours or for part of the year | y                               |
            | Is the holiday entitlement based on                            | y/regular                       |
            | Do you want to work out holiday                                | y/regular/days-worked-per-week  |
            | Do you want to work out holiday                                | y/regular/hours-worked-per-week |
            | Do you want to work out holiday                                | y/regular/annualised-hours      |
            | Do you want to work out holiday                                | y/regular/compressed-hours      |
            | Do you want to calculate the holiday                           | y/regular/shift-worker          |
