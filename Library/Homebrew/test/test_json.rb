require 'testing_env'
require 'vendor/multi_json'

class JsonSmokeTest < Test::Unit::TestCase
  def test_encode
    hash = { "foo" => ["bar", "baz"] }
    json = %q|{"foo":["bar","baz"]}|
    assert_equal json, MultiJson.encode(hash)
  end

  def test_decode
    hash = { "foo" => ["bar", "baz"], "qux" => 1 }
    json = %q|{"foo":["bar","baz"],"qux":1}|
    assert_equal hash, MultiJson.decode(json)
  end
end
