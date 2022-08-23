# frozen_string_literal: true

module Prius
  class Railtie < Rails::Railtie
    config.before_configuration do
      if ::Rails.root.join("config", "prius.rb").exist?
        require ::Rails.root.join("config", "prius.rb")
      end
    end
  end
end
