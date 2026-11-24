# MaPS QE UI Technical Task

This repository contains my solutions to the two parts of the Money and Pensions Service (MaPS) Senior Test Engineer - technical exercise:

- **Part 1 — UI test automation:** a data-driven test suite for the GOV.UK [Calculate your holiday entitlement](https://www.gov.uk/calculate-your-holiday-entitlement) service.
- **Part 2 — Accessibility testing:** an accessibility review of the supplied local _Accessibility Chat Robot_ page, with findings and a formal bug report.

## Part 1 — UI test automation

### Tech stack

| Technology                 | Purpose                                                      |
| -------------------------- | ------------------------------------------------------------ |
| JavaScript (ES modules)    | Automation language                                          |
| Node.js and npm            | Runtime and dependency management                            |
| Playwright Test            | Browser automation, assertions and test execution            |
| Playwright BDD and Gherkin | Given/When/Then scenarios and reusable step definitions      |
| Page Object Model (POM)    | Page-specific locators, actions and assertions               |
| Chromium and WebKit        | Cross-browser testing (configurable in playwright.config.js) |
| Playwright HTML Reporter   | Test results and available failure diagnostics               |

### Test coverage

| Area                      | Coverage                                                                                                                                             |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Calculator journeys       | Regular-hours calculations based on days, weekly hours, annualised hours, compressed hours and shifts, across full- and part-year employment periods |
| Irregular hours           | Historical and current calculation paths, including the 1 April 2024 rule change                                                                     |
| Validation and boundaries | Required selections, numeric inputs, date formats, leap years, minimum/maximum values and related constraints                                        |
| Results and summary       | Calculated holiday entitlement and the answers displayed in the results summary                                                                      |
| Change answers            | Previously entered values, edits, updated summaries and recalculation across representative journeys                                                 |
| Start Again               | Restart-link behavior across routes reached using representative inputs (169 distinct URLs observed in the latest run)                               |
| Cookies                   | Accepting or rejecting additional cookies, dismissing the confirmation and continuing to the calculator                                              |

Tests are organised using "Gherkin Scenario Outline" and "Examples" tables where appropriate. Full calculator journeys are supplemented by focused validation and boundary tests.

### Project structure

```text
features/                    # Gherkin scenarios, including validation/
pages/                       # Page Object Model classes
steps/                       # Reusable JavaScript step definitions
task 2/                      # Accessibility report and bug report
package.json                 # npm scripts and dependencies
playwright.config.js         # Playwright projects and test configuration
README.md                    # Setup and assessment overview
```

### Installation

**Prerequisites:** Node.js and npm, an internet connection, and a machine that supports Playwright.

From the repository root, install the dependencies and browser binaries:

```bash
npm install
npx playwright install chromium webkit
```

Generate the Playwright tests from the Gherkin feature files:

```bash
npx bddgen
```

Run the suite in Chromium:

```bash
npx playwright test --project=chromium --reporter=html
```

Open the results:

```bash
npx playwright show-report
```

Run `npx bddgen` again after changing feature files or step definitions.

### Other useful commands

```bash
# Run in WebKit (Safari engine)
npx playwright test --project=webkit --reporter=list

# Run both configured browser projects
npx playwright test --project=chromium --project=webkit --reporter=html

# Run Change Answers scenarios only
npx playwright test --project=chromium --grep @ChangeAnswers --reporter=list

# Run cookie-consent scenarios only
npx playwright test --project=chromium --grep @Cookies --reporter=list

# Exclude the longer Start Again audit
npx playwright test --project=chromium --grep-invert @StartAgain --reporter=list

# List discovered tests without running them
npx playwright test --project=chromium --list
```

### Framework approach

The framework separates **feature files** (expected behaviour), **step definitions** (test flow) and **Page Objects** (locators, interactions and assertions). It favours accessible Playwright locators such as `getByRole()` and `getByLabel()`, with scoped CSS selectors where needed. Playwright's isolated browser contexts keep scenarios independent, and auto-retrying assertions help reduce timing-related failures.

The tests run against a live GOV.UK service, so network issues or changes to the site can affect results. The Start Again audit can be excluded from routine runs because it visits many pages. Dedicated Browser Back button and GOV.UK cookie-information-page tests are outside the current coverage, but the cookie banner is covered.

## Part 2 — Accessibility testing

Part 2 reviews the supplied **Accessibility Chat Robot** page. The review uses **WCAG 2.1 Level AA** as its reference and includes automated accessibility checks and focused manual inspection.

The assessment results are documented in Task 2 folder:

- **a11y-report.md** — accessibility findings, impact and recommended improvements.
- **bug-report.md** — a formal bug report for the missing page title.

The evaluation follows the Web Content Accessibility Guidelines (WCAG) 2.2 at level AA.

## Part 3 — Further considerations

Given more time, I would extend coverage in the following areas:

- **Change Answers:** Test more combinations of edited answers and recalculations, using reusable journey helpers and data-driven scenarios to avoid duplicating lengthy test flows.
- **Other page interactions:** Check relevant navigation, help and feedback links beyond the main **Start now** calculator journey, while keeping the suite focused on the service.
