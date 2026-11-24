import { expect } from '@playwright/test';
import { mkdir, writeFile } from 'node:fs/promises';

export class StartAgainAuditPage {
  constructor(page) {
    this.page = page;
    this.root = '/calculate-your-holiday-entitlement';
  }

  async audit() {
    const queue = [{ url: this.page.url(), year: 2025 }];
    const visited = new Set();
    const testedUrls = [];

    while (queue.length > 0) {
      const { url, year } = queue.shift();
      await this.page.goto(url);
      const currentUrl = this.page.url();
      const path = new URL(currentUrl).pathname;

      if (visited.has(path)) continue;
      if (!path.startsWith(`${this.root}/y`)) {
        throw new Error(`Unexpected calculator route: ${currentUrl}`);
      }
      visited.add(path);

      if (path === `${this.root}/y`) {
        await expect(this.startAgainLink(this.page)).toHaveCount(0);
      } else {
        await this.verifyStartAgainFrom(currentUrl);
        testedUrls.push(currentUrl);
      }

      const form = this.page.locator('#current-question');
      if (await form.count() === 0) {
        await expect(this.page.getByRole('heading', { level: 1 }))
          .toContainText('Information based on your answers');
        continue;
      }

      const question = await this.page.getByRole('heading', { level: 1 })
        .or(form.locator('.govuk-label--l')).first().innerText();
      const radioCount = await form.getByRole('radio').count();

      if (radioCount > 0) {
        for (let i = 0; i < radioCount; i++) {
          await this.page.goto(currentUrl);
          await this.page.locator('#current-question')
            .getByRole('radio').nth(i).check();
          await this.continueToNext(queue, year, currentUrl);
        }
        continue;
      }

      const isDate = await form.getByLabel('Day', { exact: true }).count() === 1
        && await form.getByLabel('Month', { exact: true }).count() === 1
        && await form.getByLabel('Year', { exact: true }).count() === 1;

      if (isDate) {
        const isBranchDate = path === `${this.root}/y/irregular-hours-and-part-year`;
        const choices = isBranchDate
          ? [{ value: '01/01/2023', year: 2023 }, { value: '01/01/2025', year: 2025 }]
          : [{ value: this.validDateFor(question, year), year }];

        for (const choice of choices) {
          await this.page.goto(currentUrl);
          const [day, month, yyyy] = choice.value.split('/');
          const dateForm = this.page.locator('#current-question');
          await dateForm.getByLabel('Day', { exact: true }).fill(day);
          await dateForm.getByLabel('Month', { exact: true }).fill(month);
          await dateForm.getByLabel('Year', { exact: true }).fill(yyyy);
          await this.continueToNext(queue, choice.year, currentUrl);
        }
        continue;
      }

      const numberInput = form.getByRole('textbox')
        .or(form.getByRole('spinbutton'));
      if (await numberInput.count() === 1) {
        await numberInput.fill(this.validNumberFor(question));
        await this.continueToNext(queue, year, currentUrl);
        continue;
      }

      throw new Error(`Unrecognised question at ${currentUrl}: ${question}`);
    }

    testedUrls.sort();
    await mkdir('test-results', { recursive: true });
    await writeFile(
      'test-results/start-again-urls.json',
      JSON.stringify(testedUrls, null, 2),
      'utf8',
    );
    console.log(`Start again: verified ${testedUrls.length} distinct URLs.`);
    console.log('Saved URL inventory: test-results/start-again-urls.json');
    return testedUrls;
  }

  startAgainLink(page) {
    return page.getByRole('link', { name: 'Start again', exact: true });
  }

  async verifyStartAgainFrom(url) {
    const probe = await this.page.context().newPage();
    try {
      await probe.goto(url);
      await expect(this.startAgainLink(probe)).toBeVisible();
      await this.startAgainLink(probe).click();
      await expect(probe).toHaveURL(/\/calculate-your-holiday-entitlement\/?$/);
      await expect(probe.getByRole('heading', { level: 1 }))
        .toContainText('Calculate holiday entitlement');
      await expect(this.startAgainLink(probe)).toHaveCount(0);
    } finally {
      await probe.close();
    }
  }

  validDateFor(question, year) {
    if (/leave year start/i.test(question)) return `01/01/${year}`;
    if (/employment start date|starting date/i.test(question)) return `15/04/${year}`;
    if (/employment end date|leaving date/i.test(question)) return `20/06/${year}`;
    throw new Error(`No sample date defined for: ${question}`);
  }

  validNumberFor(question) {
    if (/hours.*pay period/i.test(question)) return '30';
    if (/shifts.*per shift pattern/i.test(question)) return '4';
    if (/days in the shift pattern/i.test(question)) return '8';
    if (/hours in each shift/i.test(question)) return '8.5';
    if (/hours worked per week/i.test(question)) return '32.5';
    if (/days worked per week/i.test(question)) return '4';
    throw new Error(`No sample number defined for: ${question}`);
  }

  async continueToNext(queue, year, previousUrl) {
    await this.page.getByRole('button', { name: 'Continue', exact: true }).click();
    const nextUrl = this.page.url();
    if (new URL(nextUrl).pathname === new URL(previousUrl).pathname) {
      throw new Error(`Calculator did not advance from ${previousUrl}`);
    }
    queue.push({ url: nextUrl, year });
  }
}
