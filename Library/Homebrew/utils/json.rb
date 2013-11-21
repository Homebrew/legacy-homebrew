require 'vendor/okjson'

module Utils
  module JSON
    extend self

    Error = Class.new(StandardError)

    def load(str)
      Vendor::OkJson.decode(str)
    rescue Vendor::OkJson::Error => e
      raise Error, e.message
    end

    def dump(obj)
      Vendor::OkJson.encode(stringify_keys(obj))
    end

    def stringify_keys(obj)
      case obj
      when Array
        obj.map { |val| stringify_keys(val) }
      when Hash
        obj.inject({}) do |result, (key, val)|
          key = key.respond_to?(:to_s) ? key.to_s : key
          val = stringify_keys(val)
          result.merge!(key => val)
        end
      else
        obj
      end
    end
  end
end
