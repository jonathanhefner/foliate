require "foliate/config"
require "rails/generators/base"

module Foliate
  # @!visibility private
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      class_option :bootstrap, type: :boolean, default: false,
        desc: "Generate Bootstrap-based stylesheet"

      def copy_config
        template "config/initializer.rb.erb", "config/initializers/foliate.rb"
        copy_file "config/locales.yml", "config/locales/foliate.en.yml"
      end

      def copy_view
        copy_file "views/page_input.html.erb", "app/views/application/_pagination.html.erb"
        template "stylesheets/page_input.scss.erb", "app/assets/stylesheets/pagination.scss"
      end
    end
  end
end
