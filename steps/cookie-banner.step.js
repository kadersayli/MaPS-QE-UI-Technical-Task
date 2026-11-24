
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';

import { CalculatorStartPage } from '../pages/CalculatorStartPage.js';
import { CookieBannerPage } from '../pages/CookieBannerPage.js';

const { Given, When, Then } = createBdd();

Given(
  'I open the calculator without saved cookie preferences',
  async ({ page }) => {
    await page.context().clearCookies();

    const startPage = new CalculatorStartPage(page);
    await startPage.navigate();
  }
);

When(
  'I reject additional cookies',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);
    await cookieBanner.rejectAdditionalCookies();
  }
);

Then(
  'I should see confirmation that additional cookies were rejected',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);
    await cookieBanner.verifyRejectionConfirmation();
  }
);

When(
  'I hide the cookie message',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);
    await cookieBanner.hideCookieMessage();
  }
);

Then(
  'I should no longer see the cookie banner',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);
    await cookieBanner.verifyCookieBannerHidden();
  }
);

Then(
  'I should reach the first calculator question',
  async ({ page }) => {
    await expect(page).toHaveURL(
      /\/calculate-your-holiday-entitlement\/y\/?$/
    );

    await expect(page.getByRole('main')).toBeVisible();
  }
);

When(
  'I accept additional cookies',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);

    await cookieBanner.acceptAdditionalCookies();
  }
);

Then(
  'I should see confirmation that additional cookies were accepted',
  async ({ page }) => {
    const cookieBanner = new CookieBannerPage(page);

    await cookieBanner.verifyAcceptanceConfirmation();
  }
);

