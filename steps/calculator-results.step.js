
import { createBdd } from 'playwright-bdd';
import { CalculatorResultsPage } from '../pages/CalculatorResultsPage.js';
import { expect } from '@playwright/test';

const { When,Then } = createBdd();
const originalEntitlements = new WeakMap();
const originalResultTexts = new WeakMap();


When(
  'I click Change for the {string} answer',
  async ({ page }, question) => {
    const resultsPage = new CalculatorResultsPage(page);

    await resultsPage.clickChangeForAnswer(question);
  }
);


Then(
  'the calculated holiday entitlement should be {string}',
  async ({ page }, expectedResult) => {
    const resultsPage = new CalculatorResultsPage(page);

    await resultsPage.verifyEntitlement(expectedResult);
  }
);

Then(
  'the holiday for each working day should be {string}',
  async ({ page }, expectedHours) => {
    const resultsPage = new CalculatorResultsPage(page);

    await resultsPage.verifyHolidayPerWorkingDay(expectedHours);
  }
);

Then(
  'the summary list should contain these answers:',
  async ({ page }, dataTable) => {
    const resultsPage = new CalculatorResultsPage(page);
    await resultsPage.verifySummaryAnswers(dataTable.hashes());
  }
);

Then(
  'the summary answer for {string} should be {string}',
  async ({ page }, question, answer) => {
    const resultsPage = new CalculatorResultsPage(page);

    await resultsPage.verifySummaryAnswers([
      {
        Question: question,
        Answer: answer,
      },
    ]);
  }
);

Then(
  'the statutory entitlement should be {string}',
  async ({ page }, expectedEntitlement) => {
    const resultsPage = new CalculatorResultsPage(page);

    await resultsPage.verifyEntitlement(expectedEntitlement);
  }
);

When(
  'I remember the current statutory entitlement',
  async ({ page }) => {
    const resultsPage = new CalculatorResultsPage(page);

    const entitlement = await resultsPage.getEntitlementDays();

    originalEntitlements.set(page, entitlement);
  }
);

Then(
  'the statutory entitlement should increase after the change',
  async ({ page }) => {
    const originalEntitlement = originalEntitlements.get(page);

    if (originalEntitlement === undefined) {
      throw new Error(
        'Original entitlement was not recorded'
      );
    }

    const resultsPage = new CalculatorResultsPage(page);

    const updatedEntitlement = await resultsPage.getEntitlementDays();

    expect(updatedEntitlement).toBeGreaterThan(
      originalEntitlement
    );
  }
);

When(
  'I record the current entitlement result',
  async ({ page }) => {
    const resultsPage = new CalculatorResultsPage(page);

    const result = await resultsPage.getEntitlementResultText();

    originalResultTexts.set(page, result);
  }
);

Then(
  'the entitlement result should be different after the change',
  async ({ page }) => {
    const originalResult = originalResultTexts.get(page);

    if (originalResult === undefined) {
      throw new Error('Original entitlement result was not recorded');
    }

    const resultsPage = new CalculatorResultsPage(page);
    const updatedResult = await resultsPage.getEntitlementResultText();

    expect(updatedResult).not.toBe(originalResult);
  }
);



