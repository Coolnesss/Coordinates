# Capistrano::Harrow

A plugin for tighter integration with Harrow.io whilst using Capistrano.

Harrow.io is a continuous integration and deployment solution for people
who like software that works like Capistrano does.

A webbased "CI" platform which has the concept of "stages" (environments) baked
in to allow reuse of scripts and tasks. Harrow.io also has powerful access
control to allow certain team members to work in certain envirnments, but not
in others.

Harrow.io is a commercial SaaS product founded by Lee Hambley, long-time
maintainer of Capistrano in an effort to make FOSS work sustainable and find a
model where a commercial entity can serve the community better.

## Installation

This Gem should not be installed directly, it is a dependency of `capistrano`
so that Capistrano's main gem release cycle is not burdened by changes to this
Gem, or to Harrow's public API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

To run the integration test on your local machine, run `bundle exec
rake integration`.  This starts a development server on port 12345 and
runs the installer against that server.  If you need to use another
port, you can specify it with the `port` argument to `rake`: `bundle
exec rake integration port=3333`

## Opting Out

The `capistrano-harrow` gem reads it's configuration from Git, you can completely
disable the gem integration by setting `git config harrow.disabled true`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/harrowio/capistrano-harrow.
