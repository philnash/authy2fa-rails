# Two Factor Authy

Use Authy to add Two Factor Auth to your Rails app.

[![Build Status](https://travis-ci.org/TwilioDevEd/authy2fa-rails.svg?branch=master)](https://travis-ci.org/TwilioDevEd/authy2fa-rails)

## Running the application

Clone this repository and cd into the directory then.

```
$ bundle install
$ rake db:create db:migrate
$ export AUTHY_API_KEY=YOUR_AUTHY_KEY
$ rake test
$ rails server
```

Then visit the application at http://localhost:3000/

## Deploy to Heroku

Hit the button!

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
