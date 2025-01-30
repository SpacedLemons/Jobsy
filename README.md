# Jobsy

Welcome to Jobsy, powered by AI and designed to empower candidates in their job search.

The app is built using a standard MVVM structure. I will possibly look into implementing MVVM-CA once we have the backend up and running.

Please find a link to the planned v1 of the app [here](https://docs.google.com/document/d/1-rNdZz7zHScNhZ9viG1k6qI3WBDACeG8iRomj3YMpZo/edit?usp=sharing)

The planned proposal is to build a Python backend utilising text parsing to de-couple PDF, Word and text files to accurately spot basic information required in a CV for a recruiter (Such as contact information & more(

# Setup

## Clone the Repository

To get started, clone the repository to your local machine:

```
git clone https://github.com/jobsy.git
cd jobsy
```

## Environment Setup

Once cloned, run the following command to ensure your environment is correctly configured:

```
./scripts/bootstrap
```

This will:

* Install Homebrew (if not already installed).
* Install SwiftLint for code linting.
* Configure Git settings and pre-commit hooks.
* Set up Xcode preferences.

# Figma

Now that you're setup, you can visit the [Figma file](https://www.figma.com/files/team/1144665948924585552/project/330014268/Jobsy?fuid=1144665941832929822) to have a look around at the designs to get a good feel for the app.
