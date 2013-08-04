require 'testing_env'
require 'bottle_version'

class BottleVersionParsingTests < Test::Unit::TestCase
  def assert_version_detected expected, path
    assert_equal expected, BottleVersion.parse(path).to_s
  end

  def test_perforce_style
    assert_version_detected '2013.1.610569-x86_64',
      '/usr/local/perforce-2013.1.610569-x86_64.mountain_lion.bottle.tar.gz'
  end
end
