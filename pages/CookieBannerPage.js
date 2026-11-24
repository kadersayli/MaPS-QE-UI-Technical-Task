
import { expect } from '@playwright/test';

export class CookieBannerPage {
  constructor(page) {
    this.page = page;

    this.rejectButton = page.getByRole('button', {
      name: 'Reject additional cookies',
      exact: true,
    });

    this.rejectionConfirmation = page.getByText(
      /rejected additional cookies/i
    );

    this.hideButton = page.getByRole('button', {
      name: /^Hide (?:this message|cookie message)$/i,
    });

    // New Accept Cookies locators
    this.acceptButton = page.getByRole('button', {
      name: 'Accept additional cookies',
      exact: true,
    });

    this.acceptanceConfirmation = page.getByText(
      /accepted additional cookies/i
    );
  }

  async rejectAdditionalCookies() {
    await expect(this.rejectButton).toBeVisible();
    await this.rejectButton.click();
  }

  async verifyRejectionConfirmation() {
    await expect(this.rejectionConfirmation).toBeVisible();
  }

  async acceptAdditionalCookies() {
    await expect(this.acceptButton).toBeVisible();
    await this.acceptButton.click();
  }

  async verifyAcceptanceConfirmation() {
    await expect(this.acceptanceConfirmation).toBeVisible();
  }

  async hideCookieMessage() {
    await expect(this.hideButton).toBeVisible();
    await this.hideButton.click();
  }

  async verifyCookieBannerHidden() {
    await expect(this.rejectButton).toBeHidden();
    await expect(this.acceptButton).toBeHidden();
    await expect(this.hideButton).toBeHidden();
    await expect(this.rejectionConfirmation).toBeHidden();
    await expect(this.acceptanceConfirmation).toBeHidden();
  }
}
