# config/initializers/monkey_patches.rb
require 'active_resource/formats'

module ActiveResource
  module Formats
    def self.remove_root(data)
      if data.is_a?(Array) && data.size == 1
        return data.first
      else
        return data
      end
    end
  end
end
