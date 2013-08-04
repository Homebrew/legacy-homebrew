require 'testing_env'
require 'bottle_version'

class BottleVersionParsingTests < Test::Unit::TestCase
  def assert_version_detected expected, path
    assert_equal expected, BottleVersion.parse(path).to_s
  end
end
