
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import { CalculatorQuestionsPage } from '../pages/CalculatorQuestionsPage.js';

const { Given, When, Then } = createBdd();


/**
 * Navigate directly to a calculator question page.
 *
 * Example:
 * Given I open the calculator question at "y/regular"
 */
Given(
  'I open the calculator question at {string}',
  async ({ page }, questionPath) => {
    const path = questionPath.replace(/^\/+/, '');

    
await page.goto(
  `/calculate-your-holiday-entitlement/${path}`,
  {
    waitUntil: 'domcontentloaded',
    timeout: 30000,
  }
);

    await expect(
      page.getByRole('main')
    ).toBeVisible();
  }
);

/**
 * Verify that submitting a required radio-button
 * question without selecting an option displays
 * the correct GOV.UK validation error.
 */
Then(
  'I should see a required-answer validation error',
  async ({ page }) => {
    // Locate the GOV.UK validation error summary.
    const errorSummary = page.locator(
      '.govuk-error-summary'
    );

    await expect(errorSummary).toBeVisible();

    // Verify the error summary heading.
    await expect(
      errorSummary.getByRole('heading', {
        name: 'There is a problem',
        exact: true,
      })
    ).toBeVisible();

    // Verify the missing-answer validation message.
    await expect(errorSummary).toContainText(
      'Please answer this question'
    );
  }
);


When(
  'I enter {string} in the current number field',
  async ({ page }, input) => {
    const questionsPage = new CalculatorQuestionsPage(page);

    // Convert our Gherkin marker into an empty input.
    const value = input === '[blank]' ? '' : input;

    await questionsPage.enterNumber(value);
  }
);

Then(
  'I should see a numeric validation error containing {string}',
  async ({ page }, expectedError) => {
    const errorSummary = page.locator('.govuk-error-summary');

    await expect(errorSummary).toBeVisible();
    await expect(errorSummary).toContainText(expectedError);

    await expect(
      errorSummary.getByRole('heading', {
        name: 'There is a problem',
        exact: true,
      })
    ).toBeVisible();

    await expect(errorSummary).toContainText(expectedError);
  }
);

When(
  'I enter day {string}, month {string}, and year {string}',
  async ({ page }, day, month, year) => {
    const dateFields = page.getByRole('main');

    const values = [
      ['Day', day],
      ['Month', month],
      ['Year', year],
    ];

    for (const [label, input] of values) {
      const field = dateFields.getByLabel(label, {
        exact: true,
      });

      await expect(field).toBeVisible();

      await field.fill(
        input === '[blank]' ? '' : input
      );
    }
  }
);

Then(
  'I should see a date validation error containing {string}',
  async ({ page }, expectedError) => {
    const errorSummary = page.locator(
      '.govuk-error-summary'
    );

    await expect(errorSummary).toBeVisible();

    await expect(
      errorSummary.getByRole('heading', {
        name: 'There is a problem',
        exact: true,
      })
    ).toBeVisible();

    await expect(errorSummary).toContainText(
      expectedError
    );
  }
);

Then('I should see no validation errors', async ({ page }) => {
  const errorSummary = page.locator('.govuk-error-summary');

  await expect(errorSummary).toHaveCount(0);
});

Then(
  'the current number field should contain {string}',
  async ({ page }, expectedValue) => {
    const questionsPage = new CalculatorQuestionsPage(page);

    await questionsPage.verifyNumberFieldValue(expectedValue);
  }
);

Then(
  'the current date fields should contain day {string}, month {string}, and year {string}',
  async ({ page }, day, month, year) => {
    const questionsPage = new CalculatorQuestionsPage(page);

    await questionsPage.verifyDateFieldValues(
      day,
      month,
      year
    );
  }
);




