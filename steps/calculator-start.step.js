
import { createBdd } from 'playwright-bdd';
import { CalculatorStartPage } from '../pages/CalculatorStartPage.js';

const { Given, When } = createBdd();

Given(
  'I am on the holiday entitlement calculator start page',
  async ({ page }) => {
    const startPage = new CalculatorStartPage(page);
    await startPage.navigate();
  }
);

When(
  'I click on the "Start now" button',
  async ({ page }) => {
    const startPage = new CalculatorStartPage(page);
    await startPage.clickStartNow();
  }
);

