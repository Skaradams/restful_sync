module RestfulSync
  class ConfigGenerator < Rails::Generators::Base
    include RestfulSync::ApplicationHelper
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "RestfulSync config generator"

    def welcome
      say "Configuring RestfulSync dependencies and files !"
    end

    def copy_initializer_file
      say "Installing default initializer template"
      copy_file "initializer.rb", "config/initializers/restful_sync.rb"
    end

    def mount_engine
      mount_path = ask("Where would you like to mount the API ? [/api]").presence || '/api'
      route "mount RestfulSync::Engine => '#{ mount_path.match(/^\//) ? mount_path : "/#{mount_path}" }', :as => '#{ mount_path.gsub(/^\//, '') }' "
    end

    def migrate
      if yes?('Would you like to install migrations ?')
        rake 'restful_sync:install:migrations'
      end
    end
  end
end