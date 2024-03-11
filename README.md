# Devloop [![Gem Version](https://badge.fury.io/rb/devloop.svg)](https://badge.fury.io/rb/devloop) [![GH Actions](https://github.com/pawurb/devloop/actions/workflows/ci.yml/badge.svg)](https://github.com/pawurb/devloop/actions)

Devloop is an automated Rspec runner for Rails apps inspired by [TLDR](https://github.com/tendersearls/tldr). The purpose of this tool is to provide continuous and instant feedback when working on the Rails app. It runs only specs from _lines_ modified in the recent git commits. Even if you have a large `spec/user_spec.rb` file, you'll receive specs feedback in ~second on each file save.

Optionally, you can edit first line of any spec file (i.e. add `#`) to run all the tests from it.

## Installation 

It uses [fswatch](https://github.com/emcrisostomo/fswatch) so make sure to install it first:

```bash
brew install fswatch
```

In your `Gemfile`:

```ruby
gem "devloop", group: :development
```

Now you can run: 

```bash
bundle exec devloop
```

While this command it running it will automatically execute tests related to the recently modified lines of code from `spec/` folder.

Devloop will automatically detect if [Spring](https://github.com/rails/spring) is enabled for your Rails app. I've observed it reduces time needed to run specs by ~4x.

If currently there are no modified spec files, devloop will run tests based on changes in the most recent git commit.

This is in a very early stage of development so feedback is welcome.
