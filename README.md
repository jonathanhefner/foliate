# foliate

Pagination for Ruby on Rails.

**Why another pagination library?**  Because a different approach leads
to a cleaner and much simpler implementation.

**How is it different?**  Instead of extending ActiveRecord, or
dynamically defining methods on objects after instantiating them,
*foliate* adds a single method to ActionController:

```ruby
## app/controllers/posts_controller.rb
class PostsController < ApplicationController

  def index
    @posts = paginate(Post) # <-- single method
  end

end
```

Calling `paginate` with something like an ActiveRecord::Relation (or an
Array) returns an ActiveRecord::Relation (or an Array) scoped to the
current page of records, as dictated by `params[:page]`.

Calling `paginate` also sets a `@pagination` instance variable for use
in the view.  This object can be passed directly to `render`, which will
then render the "app/views/pagination/_pagination.html.erb" view
partial:

```html
<!-- app/views/posts/index.html.erb -->

Do something with @posts here...

<%= render @pagination %>
```

**How does that look?**  By default, something like this:

<img src="screenshots/page_input.png" alt="page input pagination">


## More Information

**How do I customize the appearance of the pagination?**  Running the
*foliate* installation generator creates
"app/views/pagination/_pagination.html.erb" and
"app/assets/stylesheets/pagination.css" in your project directory.
These files can be edited to meet your needs.

**How many records are in each page?**  By default, *foliate* allots
`Foliate.config.default_per_page` records per page, which is set in
"config/initializers/foliate.rb".  However, this can be overridden by
passing `per_page:` to `paginate`:

```ruby
@posts = paginate(Post, per_page: 50)
```

**What if I have a very large table, and don't want to incur a count of
all records for each page?**  The `paginate` method accepts a
`total_records:` argument, which will prevent a SQL count when set:

```ruby
@posts = paginate(Post, total_records: Post.cached_count)
```

**What if I want a different param than `:page` to dictate the current
page?**  That can be configured with `Foliate.config.page_param`, which
is set in "config/initializers/foliate.rb".

**For even more information,** see the
[full documentation](http://www.rubydoc.info/gems/foliate/).


## Installation

Add this line to your application's Gemfile:

```ruby
gem "foliate"
```

Then execute:

```bash
$ bundle
```

And finally, run the installation generator:

```bash
$ rails generate foliate:install
```


## Contributing

Run `rake test` to run the tests.


## License

[MIT License](https://opensource.org/licenses/MIT)
