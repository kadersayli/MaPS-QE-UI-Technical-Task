
@IrregularHours
Feature: Holiday entitlement for employees working irregular hours
    As an employee working irregular hours
    I want to calculate my statutory holiday entitlement
    So that I know how much leave I can take

    Background:
        Given I am on the holiday entitlement calculator start page
        When I click on the "Start now" button
        Then I should see the "Does the employee work irregular hours or for part of the year?" page
        When I select "Yes" option
        And I click the "Continue" button
        Then I should see the "When does the leave year start" page

#@MXX Placeholder for future modern irregular hours scenarios(a date on or after 1 April 2024)
#@HXX Placeholder for future historical irregular hours scenarios(before 1 April 2024)

    @ModernIrregularHours
    Scenario Outline: Calculate holiday entitlement for a pay period
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "How many hours has the employee worked in the pay period" page

        When I complete the remaining calculator questions:
            | Question                                                 | Answer         |
            | How many hours has the employee worked in the pay period | <Hours Worked> |

        Then the calculated holiday entitlement should be "<Expected Result>"

        @M01
        Examples: Leave year starting on or after 1 April 2024
            | Leave Year | Hours Worked | Expected Result |
            | 01/01/2025 | 30           | 4 hours         |

    @HistoricalIrregularHours
    @HistoricalDaysWorkedPerWeek
    Scenario Outline: Calculate historical irregular-hours entitlement based on days worked
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "Is the holiday entitlement based on" page
        When I select "days worked per week" option
        And I click the "Continue" button
        Then I should see the "Do you want to work out holiday" page

        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | Number of days worked per week     | <Working Days>     |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @H01
        Examples: Full leave year before 1 April 2024
            | Leave Year | Entitlement Type      | Working Days | Start Date | End Date | Expected Result |
            | 01/01/2021 | for a full leave year | 5            | -          | -        | 28 days         |

        @H02
        Examples: Starting part way through a leave year
            | Leave Year | Entitlement Type                                   | Working Days | Start Date | End Date | Expected Result |
            | 01/01/2021 | for someone starting part way through a leave year | 3            | 02/02/2021 | -        | 15.5 days       |

        @H03
        Examples: Leaving part way through a leave year
            | Leave Year | Entitlement Type                                  | Working Days | Start Date | End Date   | Expected Result |
            | 01/01/2021 | for someone leaving part way through a leave year | 4            | -          | 03/03/2021 | 3.9 days        |

        @H04
        Examples: Starting and leaving part way through a leave year
            | Leave Year | Entitlement Type                                               | Working Days | Start Date | End Date   | Expected Result |
            | 01/01/2021 | for someone starting and leaving part way through a leave year | 3            | 02/02/2021 | 03/03/2021 | 1.4 days        |


    @HistoricalHoursWorkedPerWeek
    Scenario Outline: Calculate historical irregular-hours entitlement based on weekly working hours
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "Is the holiday entitlement based on" page
        When I select "hours worked per week" option
        And I click the "Continue" button
        Then I should see the "Do you want to work out holiday" page

        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | Number of hours worked per week    | <Working Hours>    |
            | Number of days worked per week     | <Working Days>     |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @H05
        Examples: Full leave year
            | Leave Year | Entitlement Type      | Working Hours | Working Days | Start Date | End Date | Expected Result |
            | 01/01/2021 | for a full leave year | 40            | 5            | -          | -        | 224 hours       |


        @H06
        Examples: Starting part way through a leave year with decimal weekly hours
            | Leave Year | Entitlement Type                                   | Working Hours | Working Days | Start Date | End Date | Expected Result |
            | 01/01/2021 | for someone starting part way through a leave year | 37.5          | 4            | 02/02/2021 | -        | 196.9 hours     |


        @H07
        Examples: Leaving part way through a leave year
            | Leave Year | Entitlement Type                                  | Working Hours | Working Days | Start Date | End Date   | Expected Result |
            | 01/01/2022 | for someone leaving part way through a leave year | 37            | 5            | -          | 03/03/2022 | 35.2 hours      |

        @H08
        Examples: Starting and leaving part way with decimal weekly hours
            | Leave Year | Entitlement Type                                               | Working Hours | Working Days | Start Date | End Date   | Expected Result |
            | 01/01/2021 | for someone starting and leaving part way through a leave year | 32.5          | 4            | 15/04/2021 | 20/06/2021 | 33.5 hours      |


    @HistoricalAnnualisedHours
    Scenario Outline: Calculate historical irregular-hours entitlement based on annualised hours
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "Is the holiday entitlement based on" page
        When I select "annualised hours" option
        And I click the "Continue" button
        Then I should see the "Do you want to work out holiday" page

        When I complete the remaining calculator questions:
            | Question                           | Answer             |
            | Do you want to work out holiday    | <Entitlement Type> |
            | What was the employment start date | <Start Date>       |
            | What was the employment end date   | <End Date>         |

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @H09
        Examples: Full leave year
            | Leave Year | Entitlement Type      | Start Date | End Date | Expected Result |
            | 01/01/2021 | for a full leave year | -          | -        | 5.6 weeks       |

        @H10
        Examples: Starting part way through a historical leave year
            | Leave Year | Entitlement Type                                   | Start Date | End Date | Expected Result |
            | 01/04/2022 | for someone starting part way through a leave year | 15/11/2022 | -        | 2.34 weeks      |

        @H11
        Examples: Leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                  | Start Date | End Date   | Expected Result |
            | 01/07/2022 | for someone leaving part way through a leave year | -          | 15/10/2022 | 1.65 weeks      |

        @H12
        Examples: Starting and leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                               | Start Date | End Date   | Expected Result |
            | 01/09/2022 | for someone starting and leaving part way through a leave year | 10/10/2022 | 18/12/2022 | 1.08 weeks      |

    @HistoricalCompressedHours
    Scenario Outline: Calculate historical irregular-hours entitlement based on compressed hours
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "Is the holiday entitlement based on" page
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

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"
        And the holiday for each working day should be "<Hours Per Day>"

        @H13
        Examples: Full historical leave year with decimal hours
            | Leave Year | Entitlement Type      | Working Hours | Working Days | Start Date | End Date | Expected Result         | Hours Per Day           |
            | 01/01/2022 | for a full leave year | 37.5          | 3            | -          | -        | 210 hours and 0 minutes | 12 hours and 30 minutes |

        @H14
        Examples: Starting part way through a historical leave year
            | Leave Year | Entitlement Type                                   | Working Hours | Working Days | Start Date | End Date | Expected Result          | Hours Per Day           |
            | 01/07/2022 | for someone starting part way through a leave year | 37.5          | 3            | 15/08/2022 | -        | 193 hours and 48 minutes | 12 hours and 30 minutes |

        @H15
        Examples: Leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                  | Working Hours | Working Days | Start Date | End Date   | Expected Result         | Hours Per Day           |
            | 01/07/2022 | for someone leaving part way through a leave year | 37.5          | 3            | -          | 14/09/2022 | 43 hours and 48 minutes | 12 hours and 30 minutes |

        @H16
        Examples: Starting and leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                               | Working Hours | Working Days | Start Date | End Date   | Expected Result         | Hours Per Day           |
            | 01/01/2023 | for someone starting and leaving part way through a leave year | 34.5          | 3            | 15/04/2023 | 20/06/2023 | 35 hours and 30 minutes | 11 hours and 30 minutes |

    @HistoricalShiftWorkers
    Scenario Outline: Calculate historical irregular-hours entitlement for shift workers
        When I complete the remaining calculator questions:
            | Question                       | Answer       |
            | When does the leave year start | <Leave Year> |

        Then I should see the "Is the holiday entitlement based on" page
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

        Then I should see the "Information based on your answers" page
        And the calculated holiday entitlement should be "<Expected Result>"

        @H17
        Examples: Full historical leave year
            | Leave Year | Entitlement Type      | Start Date | End Date | Shift Hours | Shifts Per Pattern | Days In Pattern | Expected Result |
            | 01/01/2023 | for a full leave year | -          | -        | 7.5         | 5                  | 9               | 21.8 shifts     |

        @H18
        Examples: Starting part way through a historical leave year
            | Leave Year | Entitlement Type                                   | Start Date | End Date | Shift Hours | Shifts Per Pattern | Days In Pattern | Expected Result |
            | 01/07/2022 | for someone starting part way through a leave year | 15/08/2022 | -        | 7.5         | 4                  | 8               | 18 shifts       |

        @H19
        Examples: Leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                  | Start Date | End Date   | Shift Hours | Shifts Per Pattern | Days In Pattern | Expected Result |
            | 01/07/2022 | for someone leaving part way through a leave year | -          | 14/09/2022 | 7.5         | 5                  | 9               | 4.54 shifts     |

        @H20
        Examples: Starting and leaving part way through a historical leave year
            | Leave Year | Entitlement Type                                               | Start Date | End Date   | Shift Hours | Shifts Per Pattern | Days In Pattern | Expected Result |
            | 01/01/2023 | for someone starting and leaving part way through a leave year | 15/04/2023 | 20/06/2023 | 8.5         | 4                  | 8               | 3.60 shifts     |
