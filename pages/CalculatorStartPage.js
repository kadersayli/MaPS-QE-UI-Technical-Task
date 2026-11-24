
import { expect } from '@playwright/test';

export class CalculatorStartPage {
  constructor(page) {
    this.page = page;

    // Page heading
    this.pageHeading = page.getByRole('heading', {
      level: 1,
    });

    // Start now button
    this.startNowButton = page.getByRole('button', {
      name: 'Start now',
      exact: true,
    });

    // Start again link
    this.startAgainLink = page.getByRole('link', {
      name: 'Start again',
      exact: true,
    });
  }

  // Navigate to the holiday entitlement calculator start page
 
async navigate() {
  await this.page.goto(
    '/calculate-your-holiday-entitlement',
    {
      waitUntil: 'domcontentloaded',
    }
  );

  await expect(this.pageHeading).toHaveText(
    'Calculate holiday entitlement'
  );

  await expect(this.startNowButton).toBeVisible();
}

  // Alternative method name for navigation
  async navigateToStartPage() {
    await this.navigate();
  }

  // Click Start now to begin the calculator
  async clickStartNow() {
    await expect(this.startNowButton).toBeVisible();

    await this.startNowButton.click();

    await expect(this.page).toHaveURL(
      /\/calculate-your-holiday-entitlement\/y\/?$/
    );
  }
  // Verify Start again returns to the calculator start page
  async verifyReturnedToStartPage() {
    await expect(this.page).toHaveURL(
      /\/calculate-your-holiday-entitlement\/?$/
    );

    await expect(this.pageHeading).toHaveText(
      'Calculate holiday entitlement'
    );

    await expect(this.startNowButton).toBeVisible();
    await expect(this.startAgainLink).toHaveCount(0);
  }
}
