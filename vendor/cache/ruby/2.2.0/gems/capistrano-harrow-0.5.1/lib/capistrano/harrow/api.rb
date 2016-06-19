require 'json'
require 'digest/sha1'

module Capistrano
  module Harrow
    class API
      PARTICIPATION_URL = 'http://harrow.capistranorb.com/participating'

      class NetworkError < StandardError; end
      class ProtocolError < StandardError; end
      class FatalError < StandardError; end

      def initialize(params={url: 'https://www.app.harrow.io/api/',
                             client: HTTP,
                             participation_url: PARTICIPATION_URL,
                            })
        @url = URI(params.fetch(:url))
        @client = params.fetch(:client)
        @participation_url = URI(params.fetch(:participation_url, PARTICIPATION_URL))
      end

      def participating?(params={})
        name = params.delete(:name)
        email = params.delete(:email)
        repository_url = params.delete(:repository_url)

        params[:name_present] = !name.to_s.empty?
        params[:email_present] = !email.to_s.empty?
        params[:repository_id] = Digest::SHA1.new.hexdigest(repository_url.to_s)
        response = @client.get(
          @participation_url,
          {'User-Agent' => user_agent},
          params,
        )

        case response
        when Net::HTTPSuccess
          parsed_body = ::JSON.parse(response.body, symbolize_names: true)
          is_participating = parsed_body.delete(:participating)
          return false unless is_participating

          return parsed_body
        end

        false
      rescue
        false
      end

      def sign_up(data)
        begin
          response = @client.post(
            @url.merge(@url.path + '/capistrano/sign-up'),
            {'Content-Type' => 'application/json',
             'User-Agent' => user_agent,
            },
            data.to_json,
          )
        rescue StandardError => e
          raise FatalError.new(e)
        end

        response_code = response.code.to_i
        if response_code >= 200 && response_code < 300
          JSON.parse(response.body, symbolize_names: true)
        elsif response_code == 422
          data = JSON.parse(response.body, symbolize_names: true)
          if data.fetch(:reason, 'ok') == 'invalid'
            data
          else
            raise ProtocolError.new(response)
          end
        else
          raise ProtocolError.new(response)
        end
      end

      private

      def user_agent
        begin
          git_version = `git version`.split(' ').last
        rescue Errno::ENOENT
          git_version = 'none'
        end

        result = "capistrano-harrow=#{Capistrano::Harrow::VERSION}"
        result << " capistrano=#{Capistrano::VERSION}" if defined? Capistrano::VERSION
        result << " ruby=#{RUBY_VERSION}"
        result << " git=#{git_version}"
        result
      end

    end
  end
end
