
@Validation @DatesValidation
Feature: Holiday entitlement calculator date validation
    As a calculator user
    I want to receive clear errors for invalid dates
    So that I can correct my answers

    @InvalidDate
    Scenario Outline: Reject invalid leave-year start dates
        Given I open the calculator question at "y/irregular-hours-and-part-year"
        Then I should see the "When does the leave year start" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "When does the leave year start" page
        And I should see a date validation error containing "<Expected Error>"

        Examples: Missing and invalid date components
            | Day     | Month   | Year    | Expected Error              |
            | [blank] | [blank] | [blank] | Please answer this question |
            | [blank] | 09      | 2025    | Please answer this question |
            | 17      | [blank] | 2025    | Please answer this question |
            | 31      | 04      | 2025    | Please answer this question |
            | 29      | 02      | 2025    | Please answer this question |
            | 15      | 13      | 2025    | Please answer this question |
            | 0       | 09      | 2025    | Please answer this question |
            | abc     | 09      | 2025    | Please answer this question |


    @ValidDate
    Scenario Outline: Accept valid leave-year start dates
        Given I open the calculator question at "y/irregular-hours-and-part-year"
        Then I should see the "When does the leave year start" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "<Next Question>" page

        Examples: Valid calendar dates
            | Day | Month | Year | Next Question                                            |
            | 07  | 08    | 2025 | How many hours has the employee worked in the pay period |
            | 29  | 02    | 2024 | Is the holiday entitlement based on                      |
            | 30  | 11    | 2025 | How many hours has the employee worked in the pay period |
            | 31  | 12    | 2023 | Is the holiday entitlement based on                      |


    @DateFormatValidation
    Scenario Outline: Accept different valid date input formats
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "<Next Question>" page

        Examples: Valid date component formats
            | Question Path                                       | Question                           | Day   | Month | Year | Next Question                                            |
            | y/irregular-hours-and-part-year                     | When does the leave year start     | 8     | 7     | 2025 | How many hours has the employee worked in the pay period |
            | y/irregular-hours-and-part-year                     | When does the leave year start     | 00008 | 00007 | 2025 | How many hours has the employee worked in the pay period |
            | y/regular/days-worked-per-week/starting-and-leaving | What was the employment start date | 8     | 7     | 2023 | What was the employment end date                         |
            | y/regular/days-worked-per-week/starting-and-leaving | What was the employment start date | 00008 | 00007 | 2023 | What was the employment end date                         |


    @MalformedEmploymentDate
    Scenario Outline: Reject malformed employment and leave-year dates
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I enter day "<Day>", month "<Month>", and year "<Year>"
        And I click the "Continue" button

        Then I should see the "<Question>" page
        And I should see a date validation error containing "<Expected Error>"

        Examples: Invalid date components
            | Question Path                           | Question                           | Day  | Month | Year | Expected Error              |
            | y/regular/days-worked-per-week/starting | What was the employment start date | 31   | 11    | 2023 | Please answer this question |
            | y/regular/days-worked-per-week/starting | What was the employment start date | abc  | 07    | 2023 | Please answer this question |
            | y/regular/days-worked-per-week/leaving  | What was the employment end date   | 29   | 02    | 2023 | Please answer this question |
            | y/regular/days-worked-per-week/leaving  | What was the employment end date   | 15   | 13    | 2023 | Please answer this question |
            | y/irregular-hours-and-part-year         | When does the leave year start     | 12   | 08    | abcd | Please answer this question |
            | y/irregular-hours-and-part-year         | When does the leave year start     | 9999 | 08    | 2025 | Please answer this question |


