require "test_helper"
require "foliate/pagination"

class PaginationTest < Minitest::Test

  def setup
    @pagination = Foliate::Pagination.new.tap do |p|
      p.current_page = 1
      p.per_page = 10
      p.total_records = 30
      p.controller = :things
      p.action = :index
      p.query_params = {}
    end

    Foliate.config.page_param = :page
  end

  def teardown
    Foliate.config = Foliate::Config.new
  end

  def test_total_pages
    (0..3).each do |i|
      @pagination.total_records = i * @pagination.per_page
      assert_equal i, @pagination.total_pages

      @pagination.total_records += 1
      assert_equal (i + 1), @pagination.total_pages
    end
  end

  def test_offset
    (1..@pagination.total_pages + 1).each do |i|
      @pagination.current_page = i
      assert_equal ((i - 1) * @pagination.per_page), @pagination.offset
    end
  end

  def test_params_for_page_has_controller_and_action
    (1..@pagination.total_pages + 1).each do |i|
      params = @pagination.params_for_page(i)
      assert_equal params[:controller], @pagination.controller
      assert_equal params[:action], @pagination.action
    end
  end

  def test_params_for_page_ellides_first_page
    params = @pagination.params_for_page(1)
    assert_nil params[:params][:page]
  end

  def test_params_for_page_beyond_first_page
    (2..@pagination.total_pages + 1).each do |i|
      params = @pagination.params_for_page(i)
      assert_equal i, params[:params][:page]
    end
  end

  def test_params_for_page_preserves_query_params
    @pagination.query_params = { x: "foo", y: "bar" }
    (1..@pagination.total_pages + 1).each do |i|
      params = @pagination.params_for_page(i)
      assert_equal "foo", params[:params][:x]
      assert_equal "bar", params[:params][:y]
    end
  end

  def test_params_for_page_reflects_page_param_config
    Foliate.config.page_param = :the_current_page_number
    params = @pagination.params_for_page(42)
    assert_equal 42, params[:params][:the_current_page_number]
  end

  def test_prev_predicate
    (1..@pagination.total_pages + 1).each do |i|
      @pagination.current_page = i
      assert_equal (i > 1), @pagination.prev?
    end
  end

  def test_next_predicate
    (1..@pagination.total_pages + 1).each do |i|
      @pagination.current_page = i
      assert_equal (i < @pagination.total_pages), @pagination.next?
    end
  end

  def test_prev_page_params
    (1..@pagination.total_pages + 1).each do |i|
      @pagination.current_page = i
      params = @pagination.prev_page_params
      if @pagination.prev?
        assert_equal @pagination.params_for_page(i - 1), params
      else
        assert_nil params
      end
    end
  end

  def test_next_page_params
    (1..@pagination.total_pages + 1).each do |i|
      @pagination.current_page = i
      params = @pagination.next_page_params
      if @pagination.next?
        assert_equal @pagination.params_for_page(i + 1), params
      else
        assert_nil params
      end
    end
  end

end
