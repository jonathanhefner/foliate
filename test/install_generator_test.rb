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
    assert_file "app/views/pagination/_pagination.html.erb"
    assert_file "app/assets/stylesheets/pagination.css"
  end
end
