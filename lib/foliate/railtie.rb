module Foliate
  # @!visibility private
  class Railtie < Rails::Railtie
    initializer "foliate" do |app|
      ActiveSupport.on_load :action_controller do
        include Foliate::Controller
      end
    end
  end
end
