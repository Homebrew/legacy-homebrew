require "testing_env"

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

  def test_good_sha1
    formula do
      sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
    end

    assert_checksum_good
  end

  def test_bad_sha1
    formula do
      sha1 "7ea8a98acb8f918df723c2ae73fe67d5664bfd7e"
    end

    assert_checksum_bad
  end

  def test_good_sha256
    formula do
      sha256 "1dfb13ce0f6143fe675b525fc9e168adb2215c5d5965c9f57306bb993170914f"
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
