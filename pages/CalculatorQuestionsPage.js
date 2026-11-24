
import { expect } from '@playwright/test';

export class CalculatorQuestionsPage {
  constructor(page) {
    this.page = page;

    // Current calculator question container
    this.questionForm = page.locator('#current-question');

    // Question heading or large form label
    this.questionHeading = page
      .getByRole('heading', { level: 1 })
      .or(this.questionForm.locator('.govuk-label--l'))
      .first();
  }

  // Verify the current calculator question
  async verifyQuestion(questionText) {
    await expect(this.questionHeading).toContainText(questionText);
  }

  // Select a radio option by its accessible name
  async selectOption(option) {
    const radioOption = this.questionForm.getByRole('radio', {
      name: option,
      exact: true,
    });

    await radioOption.check();
  }

  // Click a button by its accessible name
  async clickButton(buttonName) {
    await this.page.getByRole('button', {
      name: buttonName,
      exact: true,
    }).click();
  }

  // Enter a numeric value
  async enterNumber(value) {
    const numberInput = this.questionForm
      .getByRole('textbox')
      .or(this.questionForm.getByRole('spinbutton'));

    await expect(numberInput).toHaveCount(1);
    await numberInput.fill(value);
  }

  // Enter a date in DD/MM/YYYY format
  async enterDate(date) {
    const dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
    const match = date.match(dateFormat);

    if (!match) {
      throw new Error(`Invalid date format: ${date}`);
    }

    const [, day, month, year] = match;

    await this.questionForm.getByLabel('Day', { exact: true }).fill(day);
    await this.questionForm.getByLabel('Month', { exact: true }).fill(month);
    await this.questionForm.getByLabel('Year', { exact: true }).fill(year);
  }

  // Identify the question type from the displayed UI controls
  async detectQuestionType() {
    const dayField = this.questionForm.getByLabel('Day', {
      exact: true,
    });

    const monthField = this.questionForm.getByLabel('Month', {
      exact: true,
    });

    const yearField = this.questionForm.getByLabel('Year', {
      exact: true,
    });

    const radioOptions = this.questionForm.getByRole('radio');

    const numberInputs = this.questionForm
      .getByRole('textbox')
      .or(this.questionForm.getByRole('spinbutton'));

    // Date question
    if (
      await dayField.count() === 1 &&
      await monthField.count() === 1 &&
      await yearField.count() === 1
    ) {
      return 'date';
    }

    // Radio question
    if (await radioOptions.count() > 0) {
      return 'radio';
    }

    // Number question
    if (await numberInputs.count() === 1) {
      return 'number';
    }

    throw new Error('Unable to identify the current question type');
  }

  // Complete calculator questions using the Gherkin data table
  async completeRemainingQuestions(questions) {
    const pendingQuestions = questions.filter(
      ({ Answer }) => Answer.trim() !== '-'
    );

    while (pendingQuestions.length > 0) {
      // Get the displayed question
      await expect(this.questionHeading).toBeVisible();

      const currentQuestion = await this.questionHeading.innerText();

      // Find the matching question in the data table
      const questionIndex = pendingQuestions.findIndex(
        ({ Question }) =>
          currentQuestion
            .toLowerCase()
            .includes(Question.toLowerCase())
      );

      if (questionIndex === -1) {
        throw new Error(
          `No matching answer found for: ${currentQuestion}`
        );
      }

      // Get the answer and remove it from pending questions
      const { Answer } = pendingQuestions.splice(questionIndex, 1)[0];

      // Detect the question type from the page
      const questionType = await this.detectQuestionType();

      // Answer using the appropriate method
      switch (questionType) {
        case 'radio':
          await this.selectOption(Answer);
          break;

        case 'number':
          await this.enterNumber(Answer);
          break;

        case 'date':
          await this.enterDate(Answer);
          break;

        default:
          throw new Error(
            `Unsupported question type: ${questionType}`
          );
      }

      // Continue to the next question
      await this.clickButton('Continue');
    }
  }

// Verify the value of a number input field within the question form matches the expected value
async verifyNumberFieldValue(expectedValue) {
  const numberInput = this.questionForm
    .getByRole('textbox')
    .or(this.questionForm.getByRole('spinbutton'));

  await expect(numberInput).toHaveCount(1);

  // Ensure the field contains an actual value before conversion.
  await expect(numberInput).not.toHaveValue(/^\s*$/);

  const actualValue = await numberInput.inputValue();

  expect(Number(actualValue)).toBe(Number(expectedValue));
}


// Verify the values of date input fields (day, month, year) within the question form match the expected values
async verifyDateFieldValues(expectedDay, expectedMonth, expectedYear) {
  const expectedFields = [
    ['Day', expectedDay],
    ['Month', expectedMonth],
    ['Year', expectedYear],
  ];

  for (const [label, expectedValue] of expectedFields) {
    const field = this.questionForm.getByLabel(label, {
      exact: true,
    });

    await expect(field).toBeVisible();
    await expect(field).not.toHaveValue('');

    const actualValue = await field.inputValue();

    expect(
      Number(actualValue),
      `Incorrect prefilled ${label}`
    ).toBe(Number(expectedValue));
  }
}

}

