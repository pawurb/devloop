# Devloop 

Devloop is an automated Rspec runner for Rails apps inspired by [TLDR](https://github.com/tendersearls/tldr). The purpose of this tool is to provide continuous and instant feedback when working on the Rails app. It runs only specs from *lines* modified in the recent git commits. Even if you have a large `spec/user_spec.rb` file, you'll receive specs feedback in a fraction of a second on each file save.

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

While this command it running it will automatically execute tests related to the recently modified lines of code from `specs/` folder.

Devloop will automatically detect if [Spring](https://github.com/rails/spring) is enabled for your Rails app. I've observed it reduces time needed to run specs by ~4x.

If currently there are no modified spec files, devloop will run tests based on changes in the most recent git commit.

This is in a very early stage of development so feedback is welcome.
