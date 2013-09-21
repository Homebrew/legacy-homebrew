require 'testing_env'
require 'software_spec'
require 'bottles'

class SoftwareSpecTests < Test::Unit::TestCase
  def setup
    @spec = SoftwareSpec.new
  end

  def test_resource
    @spec.resource('foo') { url 'foo-1.0' }
    assert @spec.resource?('foo')
  end

  def test_raises_when_duplicate_resources_are_defined
    @spec.resource('foo') { url 'foo-1.0' }
    assert_raises(DuplicateResourceError) do
      @spec.resource('foo') { url 'foo-1.0' }
    end
  end

  def test_raises_when_accessing_missing_resources
    assert_raises(ResourceMissingError) { @spec.resource('foo') }
  end

  def test_resource_owner
    owner = Object.new
    @spec.resource('foo') { url 'foo-1.0' }
    @spec.owner = owner
    @spec.resources.each_value { |r| assert_equal owner, r.owner }
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
