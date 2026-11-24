
import { expect } from '@playwright/test';

// Match the expected result without allowing partial numeric matches.
// For example, "4 hours" must not match "14 hours" or "14.4 hours".
function exactResultValuePattern(expected) {
  const escaped = String(expected)
    .trim()
    .replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

  return new RegExp(
    `(?<![\\d.,-])${escaped}(?!\\w)`,
    'i'
  );
}
export class CalculatorResultsPage {
  constructor(page) {
    this.page = page;

    // Locate the statutory holiday entitlement result.
    this.entitlementResult = page
      .getByRole('main')
      .getByText(
        /^The statutory (?:holiday )?entitlement (?:for this pay period )?is\b/i
      );
  }

  // Verify the expected holiday entitlement.
  async verifyEntitlement(expectedResult) {
    await expect(this.entitlementResult).toBeVisible();

    await expect(this.entitlementResult).toContainText(
      exactResultValuePattern(expectedResult)
    );
  }
  // Verify the holiday hours for each working day.
  async verifyHolidayPerWorkingDay(expectedHours) {
    const dailyHoliday = this.page
      .getByRole('main')
      .getByText(/Rather than taking a day.s holiday/i);

    await expect(dailyHoliday).toContainText(
      exactResultValuePattern(expectedHours)
    );
  }
  // Verify submitted answers in the summary list.
  async verifySummaryAnswers(expectedAnswers) {
    const summaryList = this.page
      .getByRole('main')
      .locator('dl.govuk-summary-list');

    await expect(summaryList).toBeVisible();

    for (const { Question, Answer } of expectedAnswers) {
      // Find the summary row using its question text.
      const row = summaryList
        .locator('.govuk-summary-list__row')
        .filter({
          has: this.page.locator('dt.govuk-summary-list__key', {
            hasText: Question,
          }),
        });

      await expect(
        row,
        `Summary question not found: "${Question}"`
      ).toHaveCount(1);

      // Read only the answer, excluding the Change link.
      const answer = row.locator('dd.govuk-summary-list__value');
      await expect(answer).toHaveCount(1);

      const expectedValue = Answer.trim();

      if (/^-?\d+(?:\.\d+)?$/.test(expectedValue)) {
        // Compare numeric values, accepting 30 and 30.0 as equivalent.
        const actualValue = (await answer.innerText()).trim();

        expect(
          Number(actualValue),
          `Incorrect summary answer for "${Question}"`
        ).toBe(Number(expectedValue));
      } else {
        // Check text and formatted dates exactly.
        await expect(answer).toHaveText(expectedValue);
      }
    }
  }
  // Click the Change link for a particular summary answer.
  async clickChangeForAnswer(question) {
    const summaryRow = this.page
      .getByRole('main')
      .locator('.govuk-summary-list__row')
      .filter({
        has: this.page.locator(
          '.govuk-summary-list__key',
          { hasText: question }
        ),
      });

    await expect(summaryRow).toHaveCount(1);

    const changeLink = summaryRow.getByRole('link', {
      name: /^Change\b/i,
    });

    await expect(changeLink).toBeVisible();
    await changeLink.click();
  }

  // Read the statutory entitlement expressed in days.
  async getEntitlementDays() {
    await expect(this.entitlementResult).toBeVisible();

    const resultText = await this.entitlementResult.innerText();

    const match = resultText.match(
      /(\d+(?:\.\d+)?)\s+days?\b/i
    );

    if (!match) {
      throw new Error(
        `Could not read holiday entitlement in days: ${resultText}`
      );
    }

    return Number(match[1]);
  }

  // Read the full entitlement result text.
  async getEntitlementResultText() {
    await expect(this.entitlementResult).toBeVisible();

    const resultText = await this.entitlementResult.innerText();

    return resultText.replace(/\s+/g, ' ').trim();
  }
}
