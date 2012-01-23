require 'json' unless defined?(::JSON)

module MultiJson
  module Engines
    # Use the JSON gem to encode/decode.
    class JsonGem
      ParseError = ::JSON::ParserError

      def self.decode(string, options = {}) #:nodoc:
        opts = {}
        opts[:symbolize_names] = options[:symbolize_keys]
        string = string.read if string.respond_to?(:read)
        ::JSON.parse(string, opts)
      end

      def self.encode(object) #:nodoc:
        object.to_json
      end
    end
  end
end
