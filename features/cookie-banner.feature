
@Cookies
Feature: GOV.UK cookie consent
    As a calculator user
    I want to control additional cookies
    So that I can use the calculator with my preferred settings

    @RejectCookies
    Scenario: Reject additional cookies and continue to the calculator
        Given I open the calculator without saved cookie preferences

        When I reject additional cookies
        Then I should see confirmation that additional cookies were rejected

        When I hide the cookie message
        Then I should no longer see the cookie banner

        When I click on the "Start now" button
        Then I should reach the first calculator question


    @AcceptCookies
    Scenario: Accept additional cookies and continue to the calculator
        Given I open the calculator without saved cookie preferences

        When I accept additional cookies
        Then I should see confirmation that additional cookies were accepted

        When I hide the cookie message
        Then I should no longer see the cookie banner

        When I click on the "Start now" button
        Then I should reach the first calculator question

