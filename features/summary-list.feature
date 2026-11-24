#The reference solution uses summaryList.feature to check the answers shown at the end of the questionnaire

@SummaryList
Feature: Holiday entitlement calculator summary list
    As an employee
    I want to review my answers on the results page
    So that I can confirm the calculation uses the correct information

    Scenario: Verify submitted answers appear correctly in the summary
        Given I am on the holiday entitlement calculator start page
        When I click on the "Start now" button
        Then I should see the "Does the employee work irregular hours or for part of the year?" page

        When I select "Yes" option
        And I click the "Continue" button
        Then I should see the "When does the leave year start" page

        When I complete the remaining calculator questions:
            | Question                                                 | Answer     |
            | When does the leave year start                           | 17/09/2025 |
            | How many hours has the employee worked in the pay period | 30         |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "4 hours"
        And the summary list should contain these answers:
            | Question                                                       | Answer            |
            | Does the employee work irregular hours or for part of the year? | Yes               |
            | When does the leave year start?                                 | 17 September 2025 |
            | How many hours has the employee worked in the pay period?       | 30.0                |
