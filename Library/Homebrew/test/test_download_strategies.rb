require 'testing_env'
require 'download_strategy'
require 'bottles' # XXX: hoist these regexps into constants in Pathname?
require 'hardware' # XXX: wat. fix this require mess!

class SoftwareSpecDouble
  attr_reader :url, :specs

  def initialize(url="http://foo.com/bar.tar.gz", specs={})
    @url = url
    @specs = specs
  end
end

class AbstractDownloadStrategyTests < Test::Unit::TestCase
  def setup
    @name = "foo"
    @package = SoftwareSpecDouble.new
    @strategy = AbstractDownloadStrategy.new(@name, @package)
    @args = %w{foo bar baz}
  end

  def test_expand_safe_system_args_with_explicit_quiet_flag
    @args << { :quiet_flag => '--flag' }
    expanded_args = @strategy.expand_safe_system_args(@args)
    assert_equal %w{foo bar baz --flag}, expanded_args
  end

  def test_expand_safe_system_args_with_implicit_quiet_flag
    expanded_args = @strategy.expand_safe_system_args(@args)
    assert_equal %w{foo bar -q baz}, expanded_args
  end

  def test_expand_safe_system_args_does_not_mutate_argument
    result = @strategy.expand_safe_system_args(@args)
    assert_equal %w{foo bar baz}, @args
    assert_not_same @args, result
  end
end

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
