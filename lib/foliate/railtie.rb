require "rails/railtie"
require "foliate/controller"

module Foliate
  class Railtie < Rails::Railtie
    initializer :foliate do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, Foliate::Controller
      end
    end
  end
end
