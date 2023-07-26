# pharma-shares-exchange

![Build Status](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiU3ZWdVJTTkllOTdON0hjaThodXdNOHdMUDFRalpSVWZBLzRQTXdoZlQrbitwczdrQWlMY0xXTzczbWFXVFg3VlR0MHo1L0NRWHBZemtpemMvclQzSHRrPSIsIml2UGFyYW1ldGVyU3BlYyI6IjJsdjlPMkJNMkl6V1B0VEkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master) [build history](https://us-east-1.console.aws.amazon.com/codesuite/codebuild/projects/pharma-shares-exchange/)

Pharma Shares Exchange (SVB Leerink)

## Install local dev

### Prereqs

* Ruby 2.6.6 (`rvm install 2.6.6`)

### Steps to install

* Clone the repo.
* `bundle install`
* `bundle exec rails db:migrate`
* `bundle exec rails db:seed`

### Run tests

* `bundle exec rspec` - runs spec tests
* `bundle exec cucumber` - runs cuke tests

#### Generate build reports for CI

* `CI_GENERATE_REPORTS=true bundle exec rake ci:all`
* `bundle exec cucumber --format junit --out features/reports/regression`
* `bundle exec cucumber --profile wip --format pretty --format junit --out features/reports/wip`

## Run the server locally

* `rails server`
* Point your browser at http://localhost:3000
