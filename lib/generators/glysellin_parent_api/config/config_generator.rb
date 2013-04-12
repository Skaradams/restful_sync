module GlysellinParentApi
  class ConfigGenerator < Rails::Generators::Base
    include GlysellinParentApi::ApplicationHelper
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "ParentApi config generator"

    def welcome
      say "Configuring ParentApi dependencies and files !"
    end

    def copy_initializer_file
      say "Installing default initializer template"
      copy_file "initializer.rb", "config/initializers/parent_api.rb"
    end

    def mount_engine
      mount_path = ask("Where would you like to mount the API ? [/api]").presence || '/api'
      route "mount GlysellinParentApi::Engine => '#{ mount_path.match(/^\//) ? mount_path : "/#{mount_path}" }', :as => '#{ mount_path.gsub(/^\//, '') }' "
    end
  end
end