require "testing_env"
require "formula"

class ChecksumVerificationTests < Homebrew::TestCase
  def assert_checksum_good
    assert_nothing_raised { shutup { @_f.brew {} } }
  end

  def assert_checksum_bad
    assert_raises(ChecksumMismatchError) { shutup { @_f.brew {} } }
  end

  def formula(&block)
    super do
      url "file://#{TEST_DIRECTORY}/tarballs/testball-0.1.tbz"
      instance_eval(&block)
    end
  end

  def teardown
    @_f.clear_cache
  end

  def test_good_sha256
    formula do
      sha256 TESTBALL_SHA256
    end

    assert_checksum_good
  end

  def test_bad_sha256
    formula do
      sha256 "dcbf5f44743b74add648c7e35e414076632fa3b24463d68d1f6afc5be77024f8"
    end

    assert_checksum_bad
  end
end
