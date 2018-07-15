require "test_helper"
require "foliate"

PostsController.class_eval do
  def index
    @posts = paginate(params[:test_as_array] ? Post.all.to_a : Post,
      per_page: params[:test_per_page],
      total_records: params[:test_total_records].try(&:to_i))

    render inline: "<%= render @pagination %> <hr> <%= @posts.map(&:title) %>"
  end
end

Namespaced::ThingsController.class_eval do
  def index
    @things = paginate(Namespaced::Thing)
    render inline: "<%= render @pagination %> <hr> <%= @things.map(&:color) %>"
  end
end

class IntegrationTest < ActionDispatch::IntegrationTest

  fixtures "posts"
  fixtures "namespaced/things"

  setup do
    Rails.application.config.action_dispatch.show_exceptions = false
  end

  def test_vanilla
    iterate_page_and_assert_invariants(Post)
  end

  def test_with_namespaced_resource
    iterate_page_and_assert_invariants(Namespaced::Thing)
  end

  def test_as_array
    iterate_page_and_assert_invariants(Post, test_as_array: true)
  end

  def test_with_per_page
    iterate_page_and_assert_invariants(Post, test_per_page: 13)
  end

  def test_with_total_records
    iterate_page_and_assert_invariants(Post, test_total_records: 31)
  end

  def test_with_deeply_nested_params
    iterate_page_and_assert_invariants(
      Post,
      shallow: "value",
      deeply: { nested: { values: [1, 2] } },
    )
  end

  private

  def iterate_page_and_assert_invariants(model_class, params = {})
    pagination = Foliate::Pagination.new.tap do |p|
      p.per_page = params[:test_per_page] || Foliate.config.default_per_page
      p.total_records = params[:test_total_records] || model_class.count
      p.query_params = params
    end

    (1..pagination.total_pages + 1).each do |i|
      get polymorphic_path(model_class), params: params.merge(Foliate.config.page_param => i)
      pagination.current_page = i
      azzert_invariants(pagination)
    end
  end

  # NOTE: named thusly to prevent Rails test runner from cutting off the
  # stack trace
  def azzert_invariants(pagination)
    assert_response :success

    assert_empty css_select(".translation_missing"),
      "missing translations"

    refute_empty css_select(".foliate-pagination"),
      "missing wrapper div in\n#{css_select("body")}"

    query_param_pairs = parse_query_to_pairs(pagination.query_params.to_query)

    # all links...
    css_select(".foliate-pagination a").each do |link|
      link_param_pairs = parse_query_to_pairs(URI(link.attr("href")).query)
      link_page = link_param_pairs.to_h[Foliate.config.page_param.to_s].try(&:to_i)

      assert_empty (query_param_pairs - link_param_pairs),
        "link does not preserve query_params:\n#{link}"

      refute_equal 1, link_page,
        "link does not ellide :page param for first page:\n#{link}"

      assert_includes (1..pagination.total_pages), (link_page || 1),
        "link points to invalid page:\n#{link}"

      refute_equal pagination.current_page, (link_page || 1),
        "link points to current page (use placeholder text instead):\n#{link}"
    end

    # all forms...
    css_select(".foliate-pagination form").each do |form|
      # must preserve query_params (e.g. via hidden inputs)
      form_param_pairs = css_select(form, 'input').map do |input|
        [input.attr("name"), input.attr("value")]
      end

      assert_empty (query_param_pairs - form_param_pairs),
        "form does not preserve query_params:\n#{form}"
    end
  end

end
