# Two Factor Authy

Use Authy to add Two Factor Auth to your Rails app.

[![Build Status](https://travis-ci.org/TwilioDevEd/authy2fa-rails.svg?branch=master)](https://travis-ci.org/TwilioDevEd/authy2fa-rails)

## Quickstart

### Create an Authy app

Create a free [Authy account](https://www.authy.com/developers/), if you don't
have one already, and then connect it to your Twilio account.

### Local development

This project is built using the [Ruby on Rails](http://rubyonrails.org/) web framework.

1. First clone this repository and `cd` into it.

   ```bash
   $ git clone git@github.com:TwilioDevEd/authy2fa-rails.git
   $ cd authy2fa-rails
   ```

1. Install the dependencies.

   ```bash
   $ bundle install
   ```

1. Export the environment variables.

   You can find your **Authy Api Key** for Production at https://dashboard.authy.com/.

   ```bash
   $ export AUTHY_API_KEY=Your Authy API Key
   ```

1. Create the database and run migrations.

   _Make sure you have installed [PostgreSQL](http://www.postgresql.org/). If on
   a Mac, I recommend [Postgres.app](http://postgresapp.com)_.

   ```bash
   $ bundle exec rake db:setup
   ```

1. Make sure the tests succeed.

   ```bash
   $ bundle exec rspec
   ```

1. Run the server.

   ```bash
   $ bundle exec rails s
   ```

1. Expose your application to the wider internet using [ngrok](http://ngrok.com). You can click
  [here](https://www.twilio.com/blog/2015/09/6-awesome-reasons-to-use-ngrok-when-testing-webhooks.html) for more details. This step
  is important because the application won't work as expected if you run it through localhost.

  ```bash
  $ ngrok http 3000
  ```

  Once ngrok is running, open up your browser and go to your ngrok URL. It will
  look something like this: `http://9a159ccf.ngrok.io`

### Deploy to Heroku

Hit the button!

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

That's it!

## Meta

* No warranty expressed or implied. Software is as is. Diggity.
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by Twilio Developer Education.
