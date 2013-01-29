require 'yajl' unless defined?(::Yajl)

module MultiJson
  module Adapters
    # Use the Yajl-Ruby library to dump/load.
    class Yajl
      ParseError = ::Yajl::ParseError

      def self.load(string, options={}) #:nodoc:
        ::Yajl::Parser.new(:symbolize_keys => options[:symbolize_keys]).parse(string)
      end

      def self.dump(object, options={}) #:nodoc:
        ::Yajl::Encoder.encode(object, options)
      end
    end
  end
end
