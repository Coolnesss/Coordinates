require 'net/http'

module Capistrano
  module Harrow
    class HTTP
      def get(url, headers, params)
        params = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(url.merge('?'+params).to_s)
        headers.each do |header, value|
          request[header.to_s] = value
        end

        make_request URI(url), request
      end

      def post(url, headers, data)
        request = Net::HTTP::Post.new(url.path)
        headers.each do |header, value|
          request[header.to_s] = value
        end
        request.body = data

        make_request URI(url), request
      end

      private

      def make_request(url, request)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == 'https'
        http.request(request)
      end
    end
  end
end
