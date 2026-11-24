import { expect, test } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import { StartAgainAuditPage } from '../pages/StartAgainAuditPage.js';

const { Then } = createBdd();

Then('the "Start again" link should work on every reachable calculator page', async ({ page }) => {
  test.setTimeout(15 * 60 * 1000); // Full route crawl makes many real page requests.
  const urls = await new StartAgainAuditPage(page).audit();
  const paths = urls.map(url => new URL(url).pathname);
  const bases = [
    'days-worked-per-week',
    'hours-worked-per-week',
    'annualised-hours',
    'compressed-hours',
    'shift-worker',
  ];
  for (const basis of bases) {
    expect(paths.some(path => path.includes(`/regular/${basis}`)),
      `Did not explore regular calculation basis: ${basis}`).toBe(true);
    expect(paths.some(path => path.includes(`/irregular-hours-and-part-year/2023-01-01/${basis}`)),
      `Did not explore historical calculation basis: ${basis}`).toBe(true);
  }
  expect(paths.some(path => path.includes('/irregular-hours-and-part-year/2025-01-01')))
    .toBe(true);
});
