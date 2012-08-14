require 'yajl' unless defined?(Yajl)

module MultiJson
  module Engines
    # Use the Yajl-Ruby library to encode/decode.
    class Yajl
      ParseError = ::Yajl::ParseError

      def self.decode(string, options = {}) #:nodoc:
        ::Yajl::Parser.new(:symbolize_keys => options[:symbolize_keys]).parse(string)
      end

      def self.encode(object) #:nodoc:
        ::Yajl::Encoder.new.encode(object)
      end
    end
  end
end
