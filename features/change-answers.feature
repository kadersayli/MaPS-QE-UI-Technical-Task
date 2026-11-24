
@ChangeAnswers
Feature: Change answers on the holiday entitlement results page
    As a calculator user
    I want to change my previously submitted answers
    So that I can correct information and recalculate my entitlement

    @ChangeWorkingDays
    Scenario Outline: Change working days and recalculate holiday entitlement
        Given I open the calculator question at "y/regular/days-worked-per-week/full-year"
        Then I should see the "Number of days worked per week" page

        When I enter "<Original Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And the statutory entitlement should be "<Original Entitlement>"

        When I click Change for the "Number of days worked per week" answer

        Then I should see the "Number of days worked per week" page
        And the current number field should contain "<Original Days>"

        When I enter "<Updated Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "Number of days worked per week" should be "<Updated Days>"
        And the statutory entitlement should be "<Updated Entitlement>"

        Examples: Working days changes
            | Original Days | Updated Days | Original Entitlement | Updated Entitlement |
            | 4             | 5            | 22.4 days            | 28 days             |
            | 3             | 4            | 16.8 days            | 22.4 days           |
            | 5             | 3            | 28 days              | 16.8 days           |


    @ChangeWorkingHours
    Scenario Outline: Change weekly working hours and recalculate holiday entitlement
        Given I open the calculator question at "y/regular/hours-worked-per-week/full-year"
        Then I should see the "Number of hours worked per week" page

        When I enter "<Original Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And the statutory entitlement should be "<Original Entitlement>"

        When I click Change for the "Number of hours worked per week" answer

        Then I should see the "Number of hours worked per week" page
        And the current number field should contain "<Original Hours>"

        When I enter "<Updated Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "Number of hours worked per week" should be "<Updated Hours>"
        And the summary answer for "Number of days worked per week" should be "<Working Days>"
        And the statutory entitlement should be "<Updated Entitlement>"

        Examples: Weekly working hours changes
            | Original Hours | Updated Hours | Working Days | Original Entitlement | Updated Entitlement |
            | 35             | 40            | 5            | 196 hours            | 224 hours           |
            | 20             | 25            | 4            | 112 hours            | 140 hours           |
            | 30             | 37.5          | 5            | 168 hours            | 210 hours           |



    @ChangeEmploymentEndDate
    Scenario Outline: Change employment end date and recalculate entitlement
        Given I open the calculator question at "y/regular/days-worked-per-week/starting-and-leaving/2023-05-15"
        Then I should see the "What was the employment end date" page

        When I enter day "<Original Day>", month "<Original Month>", and year "<Original Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And the summary answer for "What was the employment end date" should be "<Original End Date>"

        When I remember the current statutory entitlement
        And I click Change for the "What was the employment end date" answer

        Then I should see the "What was the employment end date" page
        And the current date fields should contain day "<Original Day>", month "<Original Month>", and year "<Original Year>"

        When I enter day "<Updated Day>", month "<Updated Month>", and year "<Updated Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "What was the employment start date" should be "15 May 2023"
        And the summary answer for "What was the employment end date" should be "<Updated End Date>"
        And the summary answer for "Number of days worked per week" should be "<Working Days>"
        And the statutory entitlement should increase after the change

        Examples: Change employment leaving dates
            | Working Days | Original Day | Original Month | Original Year | Original End Date | Updated Day | Updated Month | Updated Year | Updated End Date  |
            | 3            | 20           | 06             | 2023          | 20 June 2023      | 20          | 07            | 2023         | 20 July 2023      |
            | 5            | 10           | 08             | 2023          | 10 August 2023    | 10          | 09            | 2023         | 10 September 2023 |

# Historical irregular hours — compressed hours
# This tests changing weekly hours while keeping the number of working days unchanged. 

    @ChangeHistoricalCompressedHours
    Scenario Outline: Change compressed hours in the historical irregular-hours journey
        Given I open the calculator question at "y/irregular-hours-and-part-year/2023-10-01/compressed-hours/full-year"
        Then I should see the "Number of hours worked per week" page

        When I enter "<Original Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page

        When I record the current entitlement result
        And I click Change for the "Number of hours worked per week" answer

        Then I should see the "Number of hours worked per week" page
        And the current number field should contain "<Original Hours>"

        When I enter "<Updated Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "Number of hours worked per week" should be "<Updated Hours>"
        And the summary answer for "Number of days worked per week" should be "<Working Days>"
        And the entitlement result should be different after the change

        Examples: Update compressed weekly hours
            | Original Hours | Updated Hours | Working Days |
            | 30             | 35            | 3            |
            | 35             | 30            | 4            |


    @ChangeHistoricalShifts
    Scenario Outline: Change shift pattern in the historical irregular-hours journey
        Given I open the calculator question at "y/irregular-hours-and-part-year/2023-10-01/shift-worker/full-year"
        Then I should see the "How many hours in each shift" page

        When I enter "<Hours Per Shift>" in the current number field
        And I click the "Continue" button

        Then I should see the "How many shifts will be worked per shift pattern" page

        When I enter "<Original Shifts>" in the current number field
        And I click the "Continue" button

        Then I should see the "How many days in the shift pattern" page

        When I enter "<Pattern Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page

        When I record the current entitlement result
        And I click Change for the "How many shifts will be worked per shift pattern" answer

        Then I should see the "How many shifts will be worked per shift pattern" page
        And the current number field should contain "<Original Shifts>"

        When I enter "<Updated Shifts>" in the current number field
        And I click the "Continue" button

        Then I should see the "How many days in the shift pattern" page

        When I enter "<Pattern Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "How many shifts will be worked per shift pattern" should be "<Updated Shifts>"
        And the summary answer for "How many days in the shift pattern" should be "<Pattern Days>"
        And the entitlement result should be different after the change

        Examples: Update number of shifts
            | Hours Per Shift | Original Shifts | Updated Shifts | Pattern Days |
            | 8               | 3               | 4              | 10           |
            | 9               | 5               | 3              | 10           |


    @ChangeModernIrregularHours
    Scenario Outline: Change pay period hours and recalculate holiday entitlement
        Given I open the calculator question at "y/irregular-hours-and-part-year/2025-09-17"
        Then I should see the "How many hours has the employee worked in the pay period" page

        When I enter "<Original Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And the statutory entitlement should be "<Original Entitlement>"

        When I click Change for the "How many hours has the employee worked in the pay period" answer

        Then I should see the "How many hours has the employee worked in the pay period" page
        And the current number field should contain "<Original Hours>"

        When I enter "<Updated Hours>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "How many hours has the employee worked in the pay period" should be "<Updated Hours>"
        And the statutory entitlement should be "<Updated Entitlement>"

        Examples: Change hours worked in the pay period
            | Original Hours | Updated Hours | Original Entitlement | Updated Entitlement |
            | 30             | 40            | 4 hours              | 5 hours             |
            | 40             | 30            | 5 hours              | 4 hours             |


    @ChangePartYearEmployment
    Scenario Outline: Change employment date for a part-year worker
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Date Question>" page

        When I enter day "<Original Day>", month "<Original Month>", and year "<Original Year>"
        And I click the "Continue" button

        Then I should see the "When does the leave year start" page

        When I enter day "<Leave Year Day>", month "<Leave Year Month>", and year "<Leave Year Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page

        When I remember the current statutory entitlement
        And I click Change for the "<Date Question>" answer

        Then I should see the "<Date Question>" page
        And the current date fields should contain day "<Original Day>", month "<Original Month>", and year "<Original Year>"

        When I enter day "<Updated Day>", month "<Updated Month>", and year "<Updated Year>"
        And I click the "Continue" button

        Then I should see the "When does the leave year start" page

        When I enter day "<Leave Year Day>", month "<Leave Year Month>", and year "<Leave Year Year>"
        And I click the "Continue" button

        Then I should see the "Number of days worked per week" page

        When I enter "<Working Days>" in the current number field
        And I click the "Continue" button

        Then I should see the "Information based on your answers" page
        And I should see no validation errors
        And the summary answer for "<Date Question>" should be "<Updated Date>"
        And the summary answer for "Number of days worked per week" should be "<Working Days>"
        And the statutory entitlement should increase after the change

        Examples: Starting and leaving part way through a leave year
            | Question Path                           | Date Question                      | Original Day | Original Month | Original Year | Updated Day | Updated Month | Updated Year | Updated Date   | Leave Year Day | Leave Year Month | Leave Year Year | Working Days |
            | y/regular/days-worked-per-week/leaving  | What was the employment end date   | 15           | 06             | 2025          | 15          | 08            | 2025         | 15 August 2025 | 01             | 01               | 2025            | 4            |
            | y/regular/days-worked-per-week/starting | What was the employment start date | 15           | 07             | 2025          | 15          | 06            | 2025         | 15 June 2025   | 01             | 02               | 2025            | 5            |
