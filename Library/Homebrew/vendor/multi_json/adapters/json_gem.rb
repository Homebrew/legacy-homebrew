require 'json' unless defined?(::JSON)
require 'multi_json/adapters/json_common'

module MultiJson
  module Adapters
    # Use the JSON gem to dump/load.
    class JsonGem
      ParseError = ::JSON::ParserError
      extend JsonCommon
    end
  end
end
