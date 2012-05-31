require 'json/pure' unless defined?(::JSON)

module MultiJson
  module Engines
    # Use JSON pure to encode/decode.
    class JsonPure
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
