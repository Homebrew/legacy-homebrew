require "testing_env"
require "resource"

class ResourceTests < Homebrew::TestCase
  def setup
    @resource = Resource.new("test")
  end

  def test_url
    @resource.url("foo")
    assert_equal "foo", @resource.url
  end

  def test_url_with_specs
    @resource.url("foo", :branch => "master")
    assert_equal "foo", @resource.url
    assert_equal({ :branch => "master" }, @resource.specs)
  end

  def test_url_with_custom_download_strategy_class
    strategy = Class.new(AbstractDownloadStrategy)
    @resource.url("foo", :using => strategy)
    assert_equal "foo", @resource.url
    assert_equal strategy, @resource.download_strategy
  end

  def test_url_with_specs_and_download_strategy
    strategy = Class.new(AbstractDownloadStrategy)
    @resource.url("foo", :using => strategy, :branch => "master")
    assert_equal "foo", @resource.url
    assert_equal({ :branch => "master" }, @resource.specs)
    assert_equal strategy, @resource.download_strategy
  end

  def test_url_with_custom_download_strategy_symbol
    @resource.url("foo", :using => :git)
    assert_equal "foo", @resource.url
    assert_equal GitDownloadStrategy, @resource.download_strategy
  end

  def test_raises_for_unknown_download_strategy_class
    assert_raises(TypeError) { @resource.url("foo", :using => Class.new) }
  end

  def test_does_not_mutate_specs_hash
    specs = { :using => :git, :branch => "master" }
    @resource.url("foo", specs)
    assert_equal({ :branch => "master" }, @resource.specs)
    assert_equal(:git, @resource.using)
    assert_equal({ :using => :git, :branch => "master" }, specs)
  end

  def test_version
    @resource.version("1.0")
    assert_version_equal "1.0", @resource.version
    refute_predicate @resource.version, :detected_from_url?
  end

  def test_version_from_url
    @resource.url("http://example.com/foo-1.0.tar.gz")
    assert_version_equal "1.0", @resource.version
    assert_predicate @resource.version, :detected_from_url?
  end

  def test_version_with_scheme
    klass = Class.new(Version)
    @resource.version klass.new("1.0")
    assert_version_equal "1.0", @resource.version
    assert_instance_of klass, @resource.version
  end

  def test_version_from_tag
    @resource.url("http://example.com/foo-1.0.tar.gz", :tag => "v1.0.2")
    assert_version_equal "1.0.2", @resource.version
    assert_predicate @resource.version, :detected_from_url?
  end

  def test_rejects_non_string_versions
    assert_raises(TypeError) { @resource.version(1) }
    assert_raises(TypeError) { @resource.version(2.0) }
    assert_raises(TypeError) { @resource.version(Object.new) }
  end

  def test_version_when_url_is_not_set
    assert_nil @resource.version
  end

  def test_mirrors
    assert_empty @resource.mirrors
    @resource.mirror("foo")
    @resource.mirror("bar")
    assert_equal %w[foo bar], @resource.mirrors
  end

  def test_checksum_setters
    assert_nil @resource.checksum
    @resource.sha1(TEST_SHA1)
    assert_equal Checksum.new(:sha1, TEST_SHA1), @resource.checksum
    @resource.sha256(TEST_SHA256)
    assert_equal Checksum.new(:sha256, TEST_SHA256), @resource.checksum
  end

  def test_download_strategy
    strategy = Object.new
    DownloadStrategyDetector.
      expects(:detect).with("foo", nil).returns(strategy)
    @resource.url("foo")
    assert_equal strategy, @resource.download_strategy
  end

  def test_verify_download_integrity_missing
    fn = Pathname.new("test")

    fn.stubs(:file? => true)
    fn.expects(:verify_checksum).raises(ChecksumMissingError)
    fn.expects(:sha256)

    shutup { @resource.verify_download_integrity(fn) }
  end

  def test_verify_download_integrity_mismatch
    fn = stub(:file? => true)
    checksum = @resource.sha1(TEST_SHA1)

    fn.expects(:verify_checksum).with(checksum).
      raises(ChecksumMismatchError.new(fn, checksum, Object.new))

    shutup do
      assert_raises(ChecksumMismatchError) do
        @resource.verify_download_integrity(fn)
      end
    end
  end
end
