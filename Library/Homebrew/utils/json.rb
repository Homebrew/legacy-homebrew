require 'vendor/multi_json'

module Utils
  module JSON
    extend self

    Error = Class.new(StandardError)

    def load(str)
      MultiJson.load(str)
    rescue MultiJson::DecodeError => e
      raise Error, e.message
    end

    def dump(obj)
      MultiJson.dump(obj)
    rescue MultiJson::EncodeError => e
      raise Error, e.message
    end
  end
end
