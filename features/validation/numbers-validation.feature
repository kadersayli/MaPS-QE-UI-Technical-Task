
@Validation @NumbersValidation
Feature: Holiday entitlement calculator numeric input validation
    As a calculator user
    I want to see clear errors for invalid numbers
    So that I can correct my answers

    @InvalidNumbers
    Scenario Outline: Validate invalid numeric input
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I enter "<Input>" in the current number field
        And I click the "Continue" button

        Then I should see the "<Question>" page
        And I should see a numeric validation error containing "<Expected Error>"

        @PayPeriodHoursValidation
        Examples: Invalid hours worked in a pay period
            | Question Path                                      | Question                                                 | Input   | Expected Error                            |
            | y/irregular-hours-and-part-year/2025-09-17         | How many hours has the employee worked in the pay period | [blank] | Please answer this question               |
            | y/irregular-hours-and-part-year/2025-09-17         | How many hours has the employee worked in the pay period | 0       | You need to enter a number greater than 0 |
            | y/irregular-hours-and-part-year/2025-09-17         | How many hours has the employee worked in the pay period | -2      | You need to enter a number greater than 0 |
            | y/irregular-hours-and-part-year/2025-09-17         | How many hours has the employee worked in the pay period | abc     | Please answer this question               |

        @WeeklyHoursValidation
        Examples: Invalid weekly working hours
            | Question Path                             | Question                        | Input   | Expected Error                                |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | [blank] | Please answer this question                   |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 0       | Please enter at least .5 hours worked         |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | -3      | Please enter at least .5 hours worked         |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 169     | You can enter a maximum of 168 hours per week |


        @WorkingDaysValidation
        Examples: Invalid number of working days per week
            | Question Path                            | Question                       | Input   | Expected Error                  |
            | y/regular/days-worked-per-week/full-year | Number of days worked per week | 0       | There are only 7 days in a week |
            | y/regular/days-worked-per-week/full-year | Number of days worked per week | 8       | There are only 7 days in a week |
            | y/regular/days-worked-per-week/full-year | Number of days worked per week | [blank] | There are only 7 days in a week |

        @ShiftHoursValidation
        Examples: Invalid hours per shift
            | Question Path                    | Question                     | Input   | Expected Error                              |
            | y/regular/shift-worker/full-year | How many hours in each shift | -2      | You need to enter a number greater than 0   |
            | y/regular/shift-worker/full-year | How many hours in each shift | 24.5    | 24 is the maximum number of hours per shift |
            | y/regular/shift-worker/full-year | How many hours in each shift | [blank] | Please answer this question                 |

        @ShiftsPerPatternValidation
        Examples: Invalid number of shifts per pattern
            | Question Path                        | Question                                         | Input   | Expected Error                            |
            | y/regular/shift-worker/full-year/8.5 | How many shifts will be worked per shift pattern | -1      | You need to enter a number greater than 0 |
            | y/regular/shift-worker/full-year/8.5 | How many shifts will be worked per shift pattern | 0       | You need to enter a number greater than 0 |
            | y/regular/shift-worker/full-year/8.5 | How many shifts will be worked per shift pattern | [blank] | You need to enter a number greater than 0 |

        @DaysInShiftPatternValidation
        Examples: Invalid number of days in the shift pattern
            | Question Path                          | Question                           | Input   | Expected Error                                                                    |
            | y/regular/shift-worker/full-year/8.5/4 | How many days in the shift pattern | 3       | You need to enter a number greater than or equal to the number of shifts you work |
            | y/regular/shift-worker/full-year/8.5/4 | How many days in the shift pattern | 0       | You need to enter a number greater than or equal to the number of shifts you work |
            | y/regular/shift-worker/full-year/8.5/4 | How many days in the shift pattern | [blank] | You need to enter a number greater than or equal to the number of shifts you work |
