
@Validation @DateBoundaries
Feature: Holiday entitlement calculator date boundary validation
    As a calculator user
    I want the calculator to process dates at important boundaries
    So that I am directed to the correct calculation questions

    @LeaveYearBoundary
    Scenario Outline: Verify calculator navigation around the April 2024 boundary
        Given I open the calculator question at "y/irregular-hours-and-part-year"
        Then I should see the "When does the leave year start" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "<Next Question>" page

        Examples: Leave-year boundary dates
            | Day | Month | Year | Next Question                                            |
            | 30  | 03    | 2024 | Is the holiday entitlement based on                      |
            | 31  | 03    | 2024 | Is the holiday entitlement based on                      |
            | 01  | 04    | 2024 | How many hours has the employee worked in the pay period |
            | 02  | 04    | 2024 | How many hours has the employee worked in the pay period |

    @EmploymentStartBoundaries
    Scenario Outline: Accept valid employment start dates
        Given I open the calculator question at "y/regular/days-worked-per-week/starting-and-leaving"
        Then I should see the "What was the employment start date" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "What was the employment end date" page

        Examples: Employment start dates around leap day
            | Day | Month | Year |
            | 28  | 02    | 2020 |
            | 29  | 02    | 2020 |
            | 01  | 03    | 2020 |
    @EmploymentEndBoundaries

    @EmploymentEndBoundaries
    Scenario Outline: Accept employment end dates within the permitted period
        Given I open the calculator question at "y/regular/days-worked-per-week/starting-and-leaving/2023-05-15"
        Then I should see the "What was the employment end date" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        Examples: Valid employment end dates
            | Day | Month | Year |
            | 16  | 05    | 2023 |
            | 14  | 05    | 2024 |

    @EmploymentEndBoundaries
    Scenario Outline: Reject employment end dates outside the permitted period
        Given I open the calculator question at "y/regular/days-worked-per-week/starting-and-leaving/2023-05-15"
        Then I should see the "What was the employment end date" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "What was the employment end date" page
        And I should see a date validation error containing "<Expected Error>"

        Examples: Invalid employment end dates
            | Day | Month | Year | Expected Error                                  |
            | 14  | 05    | 2023 | Your end date can not be before your start date |
            | 15  | 05    | 2023 | Your end date can not be before your start date |
            | 15  | 05    | 2024 | Your employment end date must be within 1 year  |

    @ValidLeaveYearEmploymentBoundary
    Scenario Outline: Accept leave-year dates within the employment date boundary
        Given I open the calculator question at "<Question Path>"
        Then I should see the "When does the leave year start" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        Examples: Valid leave-year dates
            | Question Path                                      | Day | Month | Year |
            | y/regular/days-worked-per-week/starting/2023-08-19 | 18  | 08    | 2023 |
            | y/regular/days-worked-per-week/starting/2023-08-19 | 20  | 08    | 2022 |
            | y/regular/days-worked-per-week/leaving/2023-10-21  | 20  | 10    | 2023 |
            | y/regular/days-worked-per-week/leaving/2023-10-21  | 22  | 10    | 2022 |

    @InvalidLeaveYearEmploymentBoundary
    Scenario Outline: Reject leave-year dates outside the employment date boundary
        Given I open the calculator question at "<Question Path>"
        Then I should see the "When does the leave year start" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "When does the leave year start" page
        And I should see a date validation error containing "<Expected Error>"

        Examples: Invalid leave-year dates
            | Question Path                                      | Day | Month | Year | Expected Error                                                  |
            | y/regular/days-worked-per-week/starting/2023-08-19 | 19  | 08    | 2023 | Your leave year start date must be earlier than your employment |
            | y/regular/days-worked-per-week/starting/2023-08-19 | 19  | 08    | 2022 | must be within 1 year of the leave year start date              |
            | y/regular/days-worked-per-week/leaving/2023-10-21  | 21  | 10    | 2023 | Your leave year start date must be earlier than your employment |
            | y/regular/days-worked-per-week/leaving/2023-10-21  | 21  | 10    | 2022 | must be within 1 year of the leave year start date              |

