require "foliate/config"
require "rails/generators/base"

module Foliate
  # @!visibility private
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def copy_config
        template "config/initializer.rb.erb", "config/initializers/foliate.rb"
        copy_file "config/locales.yml", "config/locales/foliate.yml"
      end

      def copy_view
        copy_file "views/page_input.html.erb", "app/views/pagination/_pagination.html.erb"
        copy_file "stylesheets/page_input.scss", "app/assets/stylesheets/pagination.scss"
      end
    end
  end
end
