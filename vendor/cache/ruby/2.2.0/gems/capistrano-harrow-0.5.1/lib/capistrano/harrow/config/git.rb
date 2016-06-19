require 'shellwords'

module Capistrano
  module Harrow
    module Config
      class Git
        def initialize(config_file)
          @config_file = config_file
        end

        def disabled?
          case get :'harrow.disabled'
          when 'true' then true
          when 'false' then false
          else
            false
          end
        end

        def installed?
          not session_uuid.to_s.empty?
        end

        def session_uuid=(value)
          set :'harrow.session.uuid', value
        end

        def session_uuid
          get :'harrow.session.uuid'
        end

        def organization_uuid=(value)
          set :'harrow.organization.uuid', value
        end

        def organization_uuid
          get :'harrow.organization.uuid'
        end

        def project_uuid=(value)
          set :'harrow.project.uuid', value
        end

        def project_uuid
          get :'harrow.organization.uuid'
        end

        def repository_url
          get :'remote.origin.url'
        end

        def username
          get :'user.name'
        end

        def email
          get :'user.email'
        end

        private

        def get(key)
          begin
            value = `git config --file #{@config_file.shellescape} #{key.to_s.shellescape}`.chop
            if value.empty?
              value = `git config --file ~/.gitconfig #{key.to_s.shellescape}`.chop
            end

            value
          rescue Errno::ENOENT
            raise BackendError.new('git not installed')
          end
        end

        def set(key, value)
          return unless File.exists? @config_file

          begin
            `git config --file #{@config_file.shellescape} #{key.to_s.shellescape} #{value.to_s.shellescape}`
          rescue Errno::ENOENT
            raise BackendError.new('git not installed')
          end
        end
      end
    end
  end
end
