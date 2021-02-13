
# Recommended Reading

This was my first ever Power BI project.
As such I learned A LOT.
Online documentation, forums, etc... seemed to have a pattern of poor  
formatting, lack of complete examples, and general standards that I have  
become used to in my other programming communities.  
The Power BI community is amazing!
Very friendly, supportive, and good solutions.

This is the chance to put together what I have found spread throughout the internet.

---
# Contents

- [Recommended Reading](#recommended-reading)
- [Contents](#contents)
  - [Goals](#goals)
- [Markdown (`*.md`) - Text Formatting Standard](#markdown-md---text-formatting-standard)
  - [VS Code Extension: `markdownlint`](#vs-code-extension-markdownlint)
    - [`.markdownlint.json`](#markdownlintjson)
    - [MD034 - Bare URL used](#md034---bare-url-used)
  - [GOTCHA: `---` for a divider MUST have one empty line before](#gotcha-----for-a-divider-must-have-one-empty-line-before)
- [Coding](#coding)
  - [`JSDoc` Code Documentation](#jsdoc-code-documentation)
- [`Moodle`](#moodle)
- [`Power Query / M`](#power-query--m)
  - [Handle Date Conversion Errors](#handle-date-conversion-errors)
  - [Tools](#tools)
  - [Misc](#misc)
- [`PowerQuery / M`](#powerquery--m)

---

## Goals

1. Learn what is needed to understand, and potentially modify, this project.
2. Learn `Power BI`
   1. `PowerQuery / M` (*I feel icky whenever I type that, like I need to quote it*).
   2. Power BI Basics
3. Learn how to use `Moodle Web Services` to:
   1. `Get Courses`
   2. `Get Assignments`
   3. `Get Grades`
   4. *Basics of web services is beyond scope of this right now.*
4. Learn Good Coding/Dev Practices

This whole project and associated SCM repo ("git repo"), are meant to serve as a place for Students in the ~13 years old and up range, and adults of all ages *(I'm looking at you Grandpa, never too late to code)*.
 
I am hoping this package helps people, particularly Students, Parents, and Teachers, to be engaged by data science, programming, git/software management, and so much, because the data matters to them!
These are the Student's grades, their assignments, their life.
Hoping that means they want to see what's happening and how things work. Learn about how educators work, their school system, etc.
Looking at the Moodle schema opened a lot of insight for me into how teachers get to manage their assignments.

---

# Markdown (`*.md`) - Text Formatting Standard

- [Markdown Guide - Basic Syntax](https://www.markdownguide.org/basic-syntax/)
- Use 2 spaces (`  `) at the end of a line for a soft-break (one line space)
  instead of a full paragraph break

## VS Code Extension: `markdownlint`

Amazing. Annoying at first but so nice to be held to a standard.
https://github.com/DavidAnson/markdownlint/blob/v0.22.0/doc/Rules.md#md012

### `.markdownlint.json`


### MD034 - Bare URL used
https://github.com/DavidAnson/markdownlint/blob/v0.22.0/doc/Rules.md#md034

- I disabled the rule.

## GOTCHA: `---` for a divider MUST have one empty line before
Without a new line, the text before `---` becomes a header.
Just got caught on this file with this line:

>
> ```md
> me into how teachers get to manage their assignments.
> ---
> ```

Kept rendering as a header. Then realized, and thanks to `markdownlint`, there was no empty line.
Message was a bit confusing hence the tip here.

Working Version:

> ```md
> me into how teachers get to manage their assignments.
> // note the empty line below
> 
> ---
> ```

---
# Coding
## `JSDoc` Code Documentation
Yes, you're right, this project is not JS!
But JSDoc is a great way of documenting code.
Perhaps there is better, and we can switch, but at least it is a start.

- [Getting Started with JSDoc 3](https://jsdoc.app/about-getting-started.html)
  - Example JSDoc #1 - [`powerbi-snippets/TimestampToDate.function.pq`](powerbi-snippets/TimestampToDate.function.pq)
- [@requires](https://sjsdoc.app/tags-requires.html)
- [](https://github.com/shri/JSDoc-Style-Guide)

---
# `Moodle`
*Note: Links are in a numbered list b/c it's easier*  
*to say "Link 4" than trying to go through an unordered bullet list.*

1. https://docs.moodle.org/2x/ca/Gradebook

---
# `Power Query / M`

## Handle Date Conversion Errors
> try Date.FromText([Your Date Column]) otherwise (however you want the errors handled)
> https://community.powerbi.com/t5/Desktop/How-to-Remove-Error-in-Date-Field/td-p/347460

## Tools

https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery

- Wish I would have found this before 2021-02-12 when
most the work was done.
- Until then I thought I was using dax (somewhat, just thought it was the closest syntax b/c `Power Query / M` was hard to find).

## Misc

- https://github.com/mattmasson/PowerQuery
  - Why I used `.pq` instead of `.m` for scripts.

# `PowerQuery / M`

- [Comments](https://docs.microsoft.com/en-us/powerquery-m/comments)
  - `//` single line
  - `/* ... */` for multi-line *(Ooooh, I, sqrl-ca, didn't know this until 2021-02-13 at 11:54:13)*
