require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'test/testball'
require 'utils'


class ChecksumTests < Test::Unit::TestCase
  def good_checksum f
    assert_nothing_raised { nostdout { f.new.brew {} } }
  end
  
  def bad_checksum f
    assert_raises RuntimeError do
      nostdout { f.new.brew {} }
    end
  end
  
  def test_md5
    valid_md5 = Class.new(TestBall) do
      @md5='71aa838a9e4050d1876a295a9e62cbe6'
    end
    
    good_checksum valid_md5
  end
  
  def test_badmd5
    invalid_md5 = Class.new(TestBall) do
      @md5='61aa838a9e4050d1876a295a9e62cbe6'
    end
    
    bad_checksum invalid_md5
  end

  def test_sha1
    valid_sha1 = Class.new(TestBall) do
      @sha1='6ea8a98acb8f918df723c2ae73fe67d5664bfd7e'
    end
    
    good_checksum valid_sha1
  end

  def test_badsha1
    invalid_sha1 = Class.new(TestBall) do
      @sha1='7ea8a98acb8f918df723c2ae73fe67d5664bfd7e'
    end
    
    bad_checksum invalid_sha1
  end

  def test_sha256
    valid_sha256 = Class.new(TestBall) do
      @sha256='ccbf5f44743b74add648c7e35e414076632fa3b24463d68d1f6afc5be77024f8'
    end
    
    good_checksum valid_sha256
  end

  def test_badsha256
    invalid_sha256 = Class.new(TestBall) do
      @sha256='dcbf5f44743b74add648c7e35e414076632fa3b24463d68d1f6afc5be77024f8'
    end
    
    bad_checksum invalid_sha256
  end
end
