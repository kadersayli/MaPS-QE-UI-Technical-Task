
@RegularHours
Feature: Holiday entitlement for employees with regular working hours
    As an employee with regular working hours
    I want to check my statutory holiday entitlement
    So that I know how much annual leave I can take

    Background:
        Given I am on the holiday entitlement calculator start page
        When I click on the "Start now" button
        And I should see the "Does the employee work irregular hours or for part of the year?" page
        And I select "No" option
        And I click the "Continue" button
        Then I should see the "Is the holiday entitlement based on" page

#@Rxx Placeholder for future regular hours scenarios

    @DaysWorkedPerWeek
    Scenario Outline: Check annual leave for a regular working week
        When I select "days worked per week" option
        And I click the "Continue" button
        And I should see the "Do you want to work out holiday" page
        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | Number of days worked per week     | <Working Days>     |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |
            | When does the leave year start     | <Leave Year>       |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @R01
        Examples: Full leave year
            | Entitlement Type      | Working Days | Start Date | End Date | Leave Year | Expected Result |
            | for a full leave year | 5            | -          | -        | -          | 28 days         |

        @R02
        Examples: Starting part way through a leave year
            | Entitlement Type                                   | Working Days | Start Date | End Date | Leave Year | Expected Result |
            | for someone starting part way through a leave year | 3            | 02/02/2025 | -        | 01/01/2025 | 15.5 days       |


        @R03
        Examples: Leaving part way through a leave year
            | Entitlement Type                                  | Working Days | Start Date | End Date   | Leave Year | Expected Result |
            | for someone leaving part way through a leave year | 4            | -          | 03/03/2025 | 01/01/2025 | 3.9 days        |


        @R04
        Examples: Starting and leaving part way through a leave year
            | Entitlement Type                                               | Working Days | Start Date | End Date   | Leave Year | Expected Result |
            | for someone starting and leaving part way through a leave year | 3            | 02/02/2025 | 03/03/2025 | -          | 1.4 days        |


    @HoursWorkedPerWeek
    Scenario Outline: Check annual leave based on weekly working hours
        When I select "hours worked per week" option
        And I click the "Continue" button
        And I should see the "Do you want to work out holiday" page
        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | Number of hours worked per week    | <Working Hours>    |
            | Number of days worked per week     | <Working Days>     |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |
            | When does the leave year start     | <Leave Year>       |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @R05
        Examples: Full leave year
            | Entitlement Type      | Working Hours | Working Days | Start Date | End Date | Leave Year | Expected Result |
            | for a full leave year | 40            | 5            | -          | -        | -          | 224 hours       |


        @R06
        Examples: Starting part way through a leave year
            | Entitlement Type                                   | Working Hours | Working Days | Start Date | End Date | Leave Year | Expected Result |
            | for someone starting part way through a leave year | 38            | 5            | 02/02/2025 | -        | 01/01/2025 | 197.6 hours     |


        @R07
        Examples: Leaving part way through a leave year
            | Entitlement Type                                  | Working Hours | Working Days | Start Date | End Date   | Leave Year | Expected Result |
            | for someone leaving part way through a leave year | 37            | 5            | -          | 03/03/2025 | 01/01/2025 | 35.2 hours      |


        @R08
        Examples: Starting and leaving part way through a leave year
            | Entitlement Type                                               | Working Hours | Working Days | Start Date | End Date   | Leave Year | Expected Result |
            | for someone starting and leaving part way through a leave year | 40            | 4            | 02/02/2025 | 03/03/2025 | -          | 18.5 hours      |



    @AnnualisedHours
    Scenario Outline: Check annual leave based on annualised hours
        When I select "annualised hours" option
        And I click the "Continue" button
        And I should see the "Do you want to work out holiday" page
        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |
            | When does the leave year start     | <Leave Year>       |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @R09
        Examples: Full leave year
            | Entitlement Type      | Start Date | End Date | Leave Year | Expected Result |
            | for a full leave year | -          | -        | -          | 5.6 weeks       |


        @R10
        Examples: Starting part way through a leave year
            | Entitlement Type                                   | Start Date | End Date | Leave Year | Expected Result |
            | for someone starting part way through a leave year | 02/02/2025 | -        | 01/01/2025 | 5.14 weeks      |


        @R11
        Examples: Leaving part way through a leave year
            | Entitlement Type                                  | Start Date | End Date   | Leave Year | Expected Result |
            | for someone leaving part way through a leave year | -          | 03/03/2025 | 01/01/2025 | 0.96 weeks      |


        @R12
        Examples: Starting and leaving part way through a leave year
            | Entitlement Type                                               | Start Date | End Date   | Leave Year | Expected Result |
            | for someone starting and leaving part way through a leave year | 02/02/2025 | 03/03/2025 | -          | 0.47 weeks      |


    @CompressedHours
    Scenario Outline: Check annual leave for employees working compressed hours
        When I select "compressed hours" option
        And I click the "Continue" button
        Then I should see the "Do you want to work out holiday" page

        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | Number of hours worked per week    | <Working Hours>    |
            | Number of days worked per week     | <Working Days>     |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |
            | When does the leave year start     | <Leave Year>       |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"
        And the holiday for each working day should be "<Hours Per Day>"

        @R13
        Examples: Full leave year
            | Entitlement Type      | Working Hours | Working Days | Start Date | End Date | Leave Year | Expected Result         | Hours Per Day          |
            | for a full leave year | 40            | 4            | -          | -        | -          | 224 hours and 0 minutes | 10 hours and 0 minutes |


        @R14
        Examples: Starting part way through a leave year
            | Entitlement Type                                   | Working Hours | Working Days | Start Date | End Date | Leave Year | Expected Result         | Hours Per Day          |
            | for someone starting part way through a leave year | 40            | 4            | 02/02/2025 | -        | 01/01/2025 | 210 hours and 0 minutes | 10 hours and 0 minutes |


        @R15
        Examples: Leaving part way through a leave year
            | Entitlement Type                                  | Working Hours | Working Days | Start Date | End Date   | Leave Year | Expected Result        | Hours Per Day          |
            | for someone leaving part way through a leave year | 40            | 4            | -          | 03/03/2025 | 01/01/2025 | 38 hours and 6 minutes | 10 hours and 0 minutes |


        @R16
        Examples: Starting and leaving part way through a leave year
            | Entitlement Type                                               | Working Hours | Working Days | Start Date | End Date   | Leave Year | Expected Result         | Hours Per Day          |
            | for someone starting and leaving part way through a leave year | 40            | 4            | 02/02/2025 | 03/03/2025 | -          | 18 hours and 30 minutes | 10 hours and 0 minutes |


    @ShiftWorkers
    Scenario Outline: Check annual leave for employees working shifts
        When I select "shifts" option
        And I click the "Continue" button
        Then I should see the "Do you want to calculate the holiday" page

        When I complete the remaining calculator questions:
            | Question                                         | Answer               |
            | Do you want to calculate the holiday             | <Entitlement Type>   |
            | What was the employment start date               | <Start Date>         |
            | What was the employment end date                 | <End Date>           |
            | How many hours in each shift                     | <Shift Hours>        |
            | How many shifts will be worked per shift pattern | <Shifts Per Pattern> |
            | How many days in the shift pattern               | <Days In Pattern>    |
            | When does the leave year start                   | <Leave Year>         |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @R17
        Examples: Full leave year
            | Entitlement Type      | Start Date | End Date | Shift Hours | Shifts Per Pattern | Days In Pattern | Leave Year | Expected Result |
            | for a full leave year | -          | -        | 6           | 5                  | 9               | -          | 21.8 shifts     |


        @R18
        Examples: Starting part way through a leave year
            | Entitlement Type                                   | Start Date | End Date | Shift Hours | Shifts Per Pattern | Days In Pattern | Leave Year | Expected Result |
            | for someone starting part way through a leave year | 02/02/2025 | -        | 6           | 5                  | 9               | 01/01/2025 | 20 shifts       |


        @R19
        Examples: Leaving part way through a leave year
            | Entitlement Type                                  | Start Date | End Date   | Shift Hours | Shifts Per Pattern | Days In Pattern | Leave Year | Expected Result |
            | for someone leaving part way through a leave year | -          | 03/03/2025 | 6           | 5                  | 9               | 01/01/2025 | 3.70 shifts      |


        @R20
        Examples: Starting and leaving part way through a leave year
            | Entitlement Type                                               | Start Date | End Date   | Shift Hours | Shifts Per Pattern | Days In Pattern | Leave Year | Expected Result |
            | for someone starting and leaving part way through a leave year | 02/02/2025 | 03/03/2025 | 6           | 5                  | 9               | -          | 1.79 shifts     |
