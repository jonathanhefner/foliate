require "test_helper"
require "foliate/config"

class ConfigTest < Minitest::Test

  def teardown
    Foliate.config = Foliate::Config.new
  end

  def test_config_global
    assert_instance_of Foliate::Config, Foliate.config
  end

  def test_default_per_page_option
    Foliate.config.default_per_page = 42
    assert_equal 42, Foliate.config.default_per_page
  end

  def test_page_param_option
    Foliate.config.page_param = :foo
    assert_equal :foo, Foliate.config.page_param
  end

end
