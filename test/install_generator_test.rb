require "test_helper"
require "generators/foliate/install/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Foliate::Generators::InstallGenerator
  destination File.join(__dir__, "tmp")
  setup :prepare_destination

  def test_necessary_files_are_created
    run_generator

    assert_file "config/initializers/foliate.rb"
    assert_file "config/locales/foliate.yml"
    assert_file "app/views/application/_pagination.html.erb"
    assert_file "app/assets/stylesheets/pagination.scss" do |stylesheet|
      refute_stylesheet_whitespace_artifacts stylesheet
    end
  end

  def test_bootstrap_stylesheet_option
    run_generator %w"--bootstrap"

    assert_file "app/assets/stylesheets/pagination.scss" do |stylesheet|
      refute_stylesheet_whitespace_artifacts stylesheet
      assert_match %r"@extend", stylesheet
    end
  end

  private

  # Asserts no whitespace artifacts from stylesheet ERB template
  def refute_stylesheet_whitespace_artifacts(stylesheet)
    assert_equal stylesheet.scan("{").length, stylesheet.scan(%r"{\n  \S").length
    assert_equal stylesheet.scan("}").length, stylesheet.scan(%r";\n}").length
    refute_match %r" {3,}", stylesheet
  end

end
