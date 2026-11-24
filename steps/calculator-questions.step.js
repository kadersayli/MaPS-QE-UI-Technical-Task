
import { createBdd } from 'playwright-bdd';
import { CalculatorQuestionsPage } from '../pages/CalculatorQuestionsPage.js';

const { When, Then } = createBdd();

// Verify the displayed calculator question
Then('I should see the {string} page', async ({ page }, questionText) => {
  const questionsPage = new CalculatorQuestionsPage(page);

  await questionsPage.verifyQuestion(questionText);
});

// Select a radio option
When('I select {string} option', async ({ page }, option) => {
  const questionsPage = new CalculatorQuestionsPage(page);

  await questionsPage.selectOption(option);
});

// Click the specified button
When('I click the {string} button', async ({ page }, buttonName) => {
  const questionsPage = new CalculatorQuestionsPage(page);

  await questionsPage.clickButton(buttonName);
});

When(
  'I complete the remaining calculator questions:',
  async ({ page }, dataTable) => {
    const questionsPage = new CalculatorQuestionsPage(page);

    await questionsPage.completeRemainingQuestions(
      dataTable.hashes()
    );
  }
);

