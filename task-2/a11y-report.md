# Accessibility Test Report

## Introduction

This report summarises the accessibility issues identified on the Accessibility Chat Robot page by following Web Content Accessibility Guidelines (WCAG) 2.2 at AA.

## Summary

**Test Date:** 22 November 2026
**Accessibility Insights for Web** (automated checks powered by axe-core) is being used and carried out basic manual checks of the form and page layout.

- **Automated checks:** 3 failed instances.
- **Manual checks:** 3 additional issues identified.
- **Impact:** 1 Critical, 3 Serious and 1 Moderate.

Automated findings use axe-core rule impact levels; the manual findings are rated based on their likely effect on users.

## Issues identified

| Issue                                   | Impact   | User impact                                                                                                                                                                | Recommendation                                                                                     |
| --------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **Missing page title**                  | Critical | Without a  < title > element, users may have difficulty identifying the page in browser tabs or when switching between pages.                                              | Add a descriptive < title >  element.                                                              |
| **Page language not defined**           | Serious  | The < html > element has no 'lang' attribute, which may affect screen-reader pronunciation.                                                                                | Set the page language, for example 'lang="en-GB".                                                  |
| **Robot image has no alternative text** | Serious  | The image has no 'alt'  attribute, so its purpose is not clearly communicated to assistive technology.                                                                     | Add meaningful alternative text if the image conveys information, or  'alt="" if it is decorative. |
| **Form fields have no visible labels**  | Serious  | The name, email and message fields use placeholder text instead of labels.                                                                                                 | Add visible labels linked to the corresponding fields.                                             |
| **Placeholder text has low contrast**   | Moderate | The light grey placeholder text has a contrast ratio of 2.32:1 against the white background, making it difficult for users with low vision to read the field instructions. | Use a darker text colour that meets the minimum **4.5:1** contrast ratio for normal text.          |

## Manual observations

- Fixed widths and hidden overflow could cause content to be cut off on smaller screens or at increased zoom. This needs further testing before it can be confirmed as a defect.
- The placeholder text disappears when users type name, email or message. It is making harder to remember what each field is for.

* Decorative emoji on **Done** button is announced as a "**Done, party popper, button**". It might unnecessary information that does not explain the button's purpose. For an actual message submission form, "Send message" would be more descriptive.

## Conclusion

The checks identified **five accessibility issues**, including three reported by the automated tool. The missing image alternative text, page title, language declaration and form labels should be addressed. Further keyboard navigation between elements passed on axe-core.
