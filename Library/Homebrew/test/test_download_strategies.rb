require 'testing_env'
require 'download_strategy'
require 'bottles' # XXX: hoist these regexps into constants in Pathname?

class DownloadStrategyDetectorTests < Test::Unit::TestCase
  def setup
    @d = DownloadStrategyDetector.new
  end

  def test_detect_git_download_startegy
    @d = DownloadStrategyDetector.detect("git://foo.com/bar.git")
    assert_equal GitDownloadStrategy, @d
  end

  def test_default_to_curl_strategy
    @d = DownloadStrategyDetector.detect(Object.new)
    assert_equal CurlDownloadStrategy, @d
  end
end
