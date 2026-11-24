@Validation @NumberBoundaries
Feature: Holiday entitlement calculator numeric boundary validation
    As a calculator user
    I want valid boundary values to be accepted and invalid values rejected
    So that my holiday entitlement is calculated correctly

    @ValidNumberBoundary
    Scenario Outline: Accept valid numeric boundary values
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I enter "<Input>" in the current number field
        And I click the "Continue" button

        Then I should see the "<Next Question>" page
        And I should see no validation errors

        Examples: Valid minimum and maximum values
            | Question Path                             | Question                        | Input | Next Question                                    |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 0.5   | Number of days worked per week                   |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 168   | Number of days worked per week                   |
            | y/regular/days-worked-per-week/full-year  | Number of days worked per week  | 1     | Information based on your answers                |
            | y/regular/days-worked-per-week/full-year  | Number of days worked per week  | 7     | Information based on your answers                |
            | y/regular/shift-worker/full-year          | How many hours in each shift    | 0.1   | How many shifts will be worked per shift pattern |
            | y/regular/shift-worker/full-year          | How many hours in each shift    | 24    | How many shifts will be worked per shift pattern |

        @ExtendedNumberBoundaries
        Examples: Additional valid numeric boundaries
            | Question Path                                  | Question                                                 | Input    | Next Question                                    |
            | y/irregular-hours-and-part-year/2025-09-17     | How many hours has the employee worked in the pay period | 1        | Information based on your answers                |
            | y/irregular-hours-and-part-year/2025-09-17     | How many hours has the employee worked in the pay period | 1.1      | Information based on your answers                |
            | y/regular/hours-worked-per-week/full-year      | Number of hours worked per week                          | 167.9999 | Number of days worked per week                   |
            | y/regular/days-worked-per-week/full-year       | Number of days worked per week                           | 1.5      | Information based on your answers                |
            | y/regular/shift-worker/full-year               | How many hours in each shift                             | 23.99    | How many shifts will be worked per shift pattern |
            | y/regular/shift-worker/full-year/8.5           | How many shifts will be worked per shift pattern         | 1        | How many days in the shift pattern               |
            | y/regular/shift-worker/full-year/8.5/4         | How many days in the shift pattern                       | 4        | Information based on your answers                |
            | y/regular/hours-worked-per-week/full-year/48.0 | Number of days worked per week                           | 2        | Information based on your answers                |


    @InvalidNumberBoundary
    Scenario Outline: Reject numeric values outside permitted boundaries
        Given I open the calculator question at "<Question Path>"
        Then I should see the "<Question>" page

        When I enter "<Input>" in the current number field
        And I click the "Continue" button

        Then I should see the "<Question>" page
        And I should see a numeric validation error containing "<Expected Error>"

        Examples: Values immediately outside permitted limits
            | Question Path                             | Question                        | Input | Expected Error                              |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 0     | Please enter at least .5 hours worked       |
            | y/regular/hours-worked-per-week/full-year | Number of hours worked per week | 168.1 | You can enter a maximum of 168 hours        |
            | y/regular/days-worked-per-week/full-year  | Number of days worked per week  | 0     | There are only 7 days in a week             |
            | y/regular/days-worked-per-week/full-year  | Number of days worked per week  | 7.1   | There are only 7 days in a week             |
            | y/regular/shift-worker/full-year          | How many hours in each shift    | 0     | You need to enter a number greater than 0   |
            | y/regular/shift-worker/full-year          | How many hours in each shift    | 24.1  | 24 is the maximum number of hours per shift |

        @ExtendedNumberBoundaries
        Examples: Additional invalid numeric boundaries
            | Question Path                                  | Question                                         | Input    | Expected Error                                         |
            | y/regular/shift-worker/full-year               | How many hours in each shift                     | 24.00001 | 24 is the maximum number of hours per shift            |
            | y/regular/shift-worker/full-year/8.5           | How many shifts will be worked per shift pattern | 0.5      | You need to enter a number greater than 0              |
            | y/regular/shift-worker/full-year/8.5/4         | How many days in the shift pattern               | 3.9      | greater than or equal to the number of shifts you work |
            | y/regular/hours-worked-per-week/full-year/48.0 | Number of days worked per week                   | 1        | There are only 24 hours per day                        |


