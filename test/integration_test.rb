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

class IntegrationTest < ActionDispatch::IntegrationTest

  fixtures :posts

  def test_vanilla
    iterate_page_and_assert_invariants
  end

  def test_as_array
    iterate_page_and_assert_invariants(test_as_array: true)
  end

  def test_with_per_page
    iterate_page_and_assert_invariants(test_per_page: 13)
  end

  def test_with_total_records
    iterate_page_and_assert_invariants(test_total_records: 31)
  end

  private

  def iterate_page_and_assert_invariants(params = {})
    pagination = Foliate::Pagination.new.tap do |p|
      p.per_page = params[:test_per_page] || Foliate.config.default_per_page
      p.total_records = params[:test_total_records] || Post.count
      p.query_params = params.stringify_keys.transform_values(&:to_s)
    end

    (1..pagination.total_pages + 1).each do |i|
      get "/posts", params: params.merge(Foliate.config.page_param => i)
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

    # all links...
    css_select(".foliate-pagination a").each do |link|
      link_params = Rack::Utils.parse_nested_query(URI(link.attr("href")).query)
      link_page = link_params[Foliate.config.page_param.to_s].try(&:to_i)

      assert_empty (pagination.query_params.to_a - link_params.to_a),
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
      assert_empty (pagination.query_params.to_a - form_param_pairs),
        "form does not preserve query_params:\n#{form}"
    end
  end

end
