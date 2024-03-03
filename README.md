# Devloop 

Devloop is an automated Rspec runner for Rails app inspired by [TLDR](https://github.com/tendersearls/tldr). The purpose of this tool is to provide continous and instant feedback when working on Rails app. It runs only specs from _lines_ modified in the recent git commits. It means that even if you have a large `spec/user_spec.rb` file, you'll receive specs feedback in fraction on a second on each file save.

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

This is in a very early stage of development so feedback is welcome.
