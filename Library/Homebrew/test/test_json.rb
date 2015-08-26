require "testing_env"
require "utils/json"

class JsonSmokeTest < Homebrew::TestCase
  def test_encode
    hash = { "foo" => ["bar", "baz"] }
    json = '{"foo":["bar","baz"]}'
    assert_equal json, Utils::JSON.dump(hash)
  end

  def test_decode
    hash = { "foo" => ["bar", "baz"], "qux" => 1 }
    json = '{"foo":["bar","baz"],"qux":1}'
    assert_equal hash, Utils::JSON.load(json)
  end
end
