# [![Build Status](https://travis-ci.org/DNNX/badging.svg?branch=master)](https://travis-ci.org/DNNX/badging) Badging

The best way to explain what is Badging is by example.

Very often, OSS developers keep track of different metrics via so called "badges" -
status images at the top of a repo Readme. There are many services that provide
repository status as a badge: Travis CI, Code Climate, and many more.

However, sometimes the metric you want to display on a badge is something that
external services do not provide.

For example, let's imagine a situation when you are in the process of a migration from
[MiniTest](https://github.com/seattlerb/minitest) to [RSpec](https://github.com/rspec/rspec)
or vice versa. If your code base is large, it will take considerable amount of
time and it's desirable to track progress of this migration.

One way to do it is to leverage the excellent [shields.io](https://shields.io).
You just add something like `![RSpecing](https://img.shields.io/badge/RSpecing_Progress-83%-yellow.svg)`.
It will be displayed as ![RSpecing](https://img.shields.io/badge/RSpecing_Progress-83%-yellow.svg).

There is a problem with this approach.

The progress changes over time, so each time you convert a Minitest file to
RSpec, you need to remember to update the URL in the Readme. This is not too
convenient.

Badging is a small service which solves this problem by keeping badge metadata
(subject, status, color) in its own database and using this metadata to obtain
and cache badge SVG.

```bash
# CREATE BADGE

$  export WRITE_TOKEN=wz94aoKA32QMdg6JeC
$ export BADGING_URL=https://<your badging host>
$ curl -H 'Content-Type: application/json' \
       -X POST \
       $BADGING_URL/badges \
       --data '{"token": "'$WRITE_TOKEN'", "badge": {"subject": "RSpecing Progress", "status": "83%", "identifier": "rspecing", "color": "yellow"}}'

# GET BADGE

$ export READ_TOKEN=wz94aoKA32QMdg6
$ curl $BADGING_URL/badges/rspecing.svg?token=$READ_TOKEN
<svg xmlns="http://www.w3.org/2000/svg" width="148" height="20"><linear...

# UPDATE BADGE

$ curl -H 'Content-Type: application/json' \
       --user user:$WRITE_TOKEN \
       -X PATCH \
       $BADGING_URL/badges/rspecing \
       --data '{"token": "'$WRITE_TOKEN'", "badge": {"subject": "RSpecing Progress", "status": "95%", "identifier": "rspecing", "color": "green"}}'
```

Going back to our example, here is how you could add the badge showing RSpec
migration progress which updates automatically as code evolves:

1. Deploy Badging to Heroku or any other suitable hosting.
2. Configure randomly generated `READ_TOKEN` and `WRITE_TOKEN`.
3. Create a badge via curl request or directly via DB insert.
4. Add `![](<BADGING_URL>/badge/<identifier of created badge>.svg?token=<READ_TOKEN>)` to your repo Readme.
5. Create a script which would send a PATCH request to your Badging server
   each time a pull request is merged to your integration branch. You can call
   it from your CI server after each green build, for example. In our case,
   this script could just count the number of `_rspec.rb` and `_test.rb` files
   and figure out the progress based on that.

## Prerequisites

* Elixir
* PostgreSQL

## Running tests locally

```
mix deps.get
mix test
```

## Starting your Badging app locally

```
mix deps.get
mix ecto.create && mix ecto.migrate
mix phx.server
```

Local read/write passwords are in `config/dev.exs`.

## Deploying to Heroku

```bash
# Assuming you already created a new Heroku app and cd'ed to the project directory
heroku create --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"
heroku config:set POOL_SIZE=18 \
                  READ_TOKEN=<randomly generated string> \
                  WRITE_TOKEN=<any other random string> \
                  HOST=<your badging host> \
                  SECRET_KEY_BASE=`mix phoenix.gen.secret`

git push heroku master
```

## CORS

By default, requests from all origins are allowed. If you want to whitelist the
allowed domains, set `CORS_ALLOWED_ORIGIN` instance variable. For example:

```bash
heroku config:set CORS_ALLOWED_ORIGIN=https://github.com
```
