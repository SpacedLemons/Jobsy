# Jobsy

Welcome to Jobsy, powered by AI and designed to empower candidates in their job search.

## Project overview

Jobsy is built using a standard **MVVM** architecture, with potential plans to transition to **MVVM-CA** once the backend is fully implemented.

## Version 1 plan / MVP

The first version of Jobsy will feature a **Python-based backend** called [Jobsy-Django](https://github.com/SpacedLemons/Jobsy-Django) that utilizes text parsing to extract key information from resumes in **PDF, Word, and text** formats. The goal is to accurately identify essential details, such as contact information and other recruiter-relevant data.

Please find a link to the planned v1 of the app [here](https://docs.google.com/document/d/1-rNdZz7zHScNhZ9viG1k6qI3WBDACeG8iRomj3YMpZo/edit?usp=sharing).

# Setup Instructions

## Clone the Repository

To get started, clone the repository to your local machine:

```
git clone https://github.com/jobsy.git
cd jobsy
```

## Environment Setup

Once cloned, run the following command to configure your development environment:

```
./scripts/bootstrap
```

This will:

* Install Homebrew (if not already installed).
* Install SwiftLint for code linting.
* Configure Git settings and pre-commit hooks.
* Set up Xcode preferences.

# Design Resources

## Figma

After setting up your environment, visit the [Figma file](https://www.figma.com/design/XMEXwFJ9eoynuY59Xdxyoa/Jobsy?node-id=0-1&t=xGtRbjSNLrY2h3tl-1) to explore the app’s designs and get a feel for the user experience.
