require 'deface'

module ForemanThemify
  class Engine < ::Rails::Engine
    engine_name 'foreman_themify'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer "foreman_themify.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanThemify::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_themify.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_themify do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_themify do
          permission :view_foreman_themify, {:'foreman_themify/hosts' => [:new_action] }
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role "ForemanThemify", [:view_foreman_themify]

        #add menu entry
        menu :top_menu, :template,
             :url_hash => {:controller => :'foreman_themify/hosts', :action => :new_action },
             :caption  => 'ForemanThemify',
             :parent   => :hosts_menu,
             :after    => :hosts

        # add dashboard widget
        widget 'foreman_themify_widget', :name=>N_('Foreman plugin template widget'), :sizex => 4, :sizey =>1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_themify.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_themify.configure_assets', :group => :assets do
      SETTINGS[:foreman_themify] = {:assets => {:precompile => assets_to_precompile}}

      assets_to_override =
        Dir.chdir(root) do
          Dir['app/assets/**/*'].map do |f|
            f.split(File::SEPARATOR, 4).last
          end
        end
      Rails.application.assets.prepend_path assets_to_override
    end

    initializer 'foreman_themify.override_assets' do |app|
      assets_to_override =
        Dir.chdir(Gem.loaded_specs['foreman_themify'].full_gem_path) do
          Dir['app/assets/**'].map { |d| File.absolute_path d }
        end
      assets_to_override.each { |path| app.assets.prepend_path path }
    end


    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanThemify::HostExtensions)
        HostsHelper.send(:include, ForemanThemify::HostsHelperExtensions)
      rescue => e
        puts "ForemanThemify: skipping engine hook (#{e.to_s})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanThemify::Engine.load_seed
      end
    end

    initializer 'foreman_themify.register_gettext', :after => :load_config_initializers do |app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_themify'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

  end
end
