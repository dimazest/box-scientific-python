# Python box

A [wercker box](http://devcenter.wercker.com/articles/boxes/) with python 2.6,
2.7, 3.3 and 3.4 installed. For both versions of python setuptools, wheel, and
pip are installed.

There are two steps by default added to the wercker.yml:

## Usage

The following is the default [wercker.yml](http://devcenter.wercker.com/articles/werckeryml/) for python:

```yaml

box: dimazest/scientific-python
services:
    # - wercker/postgresql # Don't forget to add your databases as a service

# Build definition
build:

  # The steps that will be executed on build
  steps:
    - pip-install:
        requirements_file: "requirements.txt" # Optional argument.

    # A custom script step, name value is used in the UI
    # and the code value contains the command that get executed
    - script:
        name: echo python information
        code: |
          python --version
          pip freeze
```

For guides on how to use
[python on wercker](http://devcenter.wercker.com/articles/languages/python.html),
see our [devcenter](http://devcenter.wercker.com).

# Changelog

## 0.0.4

- Initial release
