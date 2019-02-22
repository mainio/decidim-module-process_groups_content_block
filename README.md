# Decidim::ProcessGroupsContentBlock

Adds a process groups content block to your Decidim instance to be used on the
home page of the app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-process_groups_content_block"
```

And then execute:

```bash
$ bundle
```

## Usage

1. Install the gem
1. As an administrator, go to Admin dashboard > Settings > Homepage
1. Enable the "Highlighted process groups" block by dragging it to the active
   content blocks section

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
