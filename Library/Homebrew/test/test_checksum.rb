require 'testing_env'
require 'checksum'

class ChecksumTests < Test::Unit::TestCase
  def test_empty?
    assert_empty Checksum.new(:sha1, '')
  end

  def test_equality
    a = Checksum.new(:sha1, 'deadbeef'*5)
    b = Checksum.new(:sha1, 'deadbeef'*5)
    assert_equal a, b

    a = Checksum.new(:sha1, 'deadbeef'*5)
    b = Checksum.new(:sha1, 'feedface'*5)
    assert_not_equal a, b

    a = Checksum.new(:sha1, 'deadbeef'*5)
    b = Checksum.new(:sha256, 'deadbeef'*5)
    assert_not_equal a, b
  end
end

