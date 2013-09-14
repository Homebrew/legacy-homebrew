require 'testing_env'
require 'software_spec'
require 'bottles'

class SoftwareSpecTests < Test::Unit::TestCase
  include VersionAssertions

  def setup
    @spec = SoftwareSpec.new
  end

  def test_url
    @spec.url('foo')
    assert_equal 'foo', @spec.url
  end

  def test_url_with_specs
    @spec.url('foo', :branch => 'master')
    assert_equal 'foo', @spec.url
    assert_equal({ :branch => 'master' }, @spec.specs)
  end

  def test_url_with_custom_download_strategy_class
    strategy = Class.new(AbstractDownloadStrategy)
    @spec.url('foo', :using => strategy)
    assert_equal 'foo', @spec.url
    assert_equal strategy, @spec.download_strategy
  end

  def test_url_with_specs_and_download_strategy
    strategy = Class.new(AbstractDownloadStrategy)
    @spec.url('foo', :using => strategy, :branch => 'master')
    assert_equal 'foo', @spec.url
    assert_equal({ :branch => 'master' }, @spec.specs)
    assert_equal strategy, @spec.download_strategy
  end

  def test_url_with_custom_download_strategy_symbol
    @spec.url('foo', :using => :git)
    assert_equal 'foo', @spec.url
    assert_equal GitDownloadStrategy, @spec.download_strategy
  end

  def test_version
    @spec.version('1.0')
    assert_version_equal '1.0', @spec.version
    assert !@spec.version.detected_from_url?
  end

  def test_version_from_url
    @spec.url('http://foo.com/bar-1.0.tar.gz')
    assert_version_equal '1.0', @spec.version
    assert @spec.version.detected_from_url?
  end

  def test_version_with_scheme
    scheme = Class.new(Version)
    @spec.version('1.0' => scheme)
    assert_version_equal '1.0', @spec.version
    assert_instance_of scheme, @spec.version
  end

  def test_version_from_tag
    @spec.url('http://foo.com/bar-1.0.tar.gz', :tag => 'v1.0.2')
    assert_version_equal '1.0.2', @spec.version
    assert @spec.version.detected_from_url?
  end

  def test_rejects_non_string_versions
    assert_raises(TypeError) { @spec.version(1) }
    assert_raises(TypeError) { @spec.version(2.0) }
    assert_raises(TypeError) { @spec.version(Object.new) }
  end

  def test_mirrors
    assert_empty @spec.mirrors
    @spec.mirror('foo')
    @spec.mirror('bar')
    assert_equal 'foo', @spec.mirrors.shift
    assert_equal 'bar', @spec.mirrors.shift
  end

  def test_checksum_setters
    assert_nil @spec.checksum
    @spec.sha1('baadidea'*5)
    assert_equal Checksum.new(:sha1, 'baadidea'*5), @spec.checksum
    @spec.sha256('baadidea'*8)
    assert_equal Checksum.new(:sha256, 'baadidea'*8), @spec.checksum
  end

  def test_download_strategy
    strategy = Object.new
    DownloadStrategyDetector.
      expects(:detect).with("foo", nil).returns(strategy)
    @spec.url("foo")
    assert_equal strategy, @spec.download_strategy
  end

  def test_verify_download_integrity_missing
    fn = Object.new
    checksum = @spec.sha1('baadidea'*5)

    fn.expects(:verify_checksum).
      with(checksum).raises(ChecksumMissingError)
    fn.expects(:sha1)

    shutup { @spec.verify_download_integrity(fn) }
  end

  def test_verify_download_integrity_mismatch
    fn = Object.new
    checksum = @spec.sha1('baadidea'*5)

    fn.expects(:verify_checksum).with(checksum).
      raises(ChecksumMismatchError.new(checksum, Object.new))

    shutup do
      assert_raises(ChecksumMismatchError) do
        @spec.verify_download_integrity(fn)
      end
    end
  end
end

class HeadSoftwareSpecTests < Test::Unit::TestCase
  include VersionAssertions

  def setup
    @spec = HeadSoftwareSpec.new
  end

  def test_version
    assert_version_equal 'HEAD', @spec.version
  end

  def test_verify_download_integrity
    assert_nil @spec.verify_download_integrity(Object.new)
  end
end

class BottleTests < Test::Unit::TestCase
  def setup
    @spec = Bottle.new
  end

  def test_checksum_setters
    checksums = {
      :snow_leopard_32 => 'deadbeef'*5,
      :snow_leopard    => 'faceb00c'*5,
      :lion            => 'baadf00d'*5,
      :mountain_lion   => '8badf00d'*5,
    }

    checksums.each_pair do |cat, sha1|
      @spec.sha1(sha1 => cat)
    end

    checksums.each_pair do |cat, sha1|
      assert_equal Checksum.new(:sha1, sha1),
        @spec.instance_variable_get(:@sha1)[cat]
    end
  end

  def test_other_setters
    double = Object.new
    %w{root_url prefix cellar revision}.each do |method|
      @spec.send(method, double)
      assert_equal double, @spec.send(method)
    end
  end
end
