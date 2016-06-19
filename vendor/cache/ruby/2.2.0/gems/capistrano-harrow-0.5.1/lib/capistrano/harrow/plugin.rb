require "capistrano/plugin"

module Capistrano
  module Harrow
    class Plugin < Capistrano::Plugin
      def define_tasks
        namespace :harrow do
          task :install do
            harrow_url        = ENV.fetch('_CAPISTRANO_HARROW_URL', 'https://www.app.harrow.io/api/')
            participation_url = ENV.fetch('_CAPISTRANO_PARTICIPATION_URL', API::PARTICIPATION_URL)
            git_config        = ENV.fetch('GIT_CONFIG', ENV.fetch('_CAPISTRANO_HARROW_CONFIG', '.git/config'))
            timeout           = ENV.fetch('_CAPISTRANO_HARROW_TIMEOUT', 30).to_i

            api = Capistrano::Harrow::API.new(
              url: harrow_url,
              client: Capistrano::Harrow::HTTP.new,
              participation_url: participation_url,
            )

            config    = Capistrano::Harrow::Config::Git.new(git_config)
            ui        = Capistrano::Harrow::UI::TTY.new(timeout: timeout)
            installer = Capistrano::Harrow::Installer.new(ui: ui, config: config, api: api)

            installer.install!
          end
        end
      end

      def register_hooks
        after "install", "harrow:install"
      end
    end
  end
end
