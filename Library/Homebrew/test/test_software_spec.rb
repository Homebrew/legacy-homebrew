require 'testing_env'
require 'software_spec'

class SoftwareSpecTests < Homebrew::TestCase
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

  def test_set_owner
    owner = stub(:name => 'some_name')
    @spec.owner = owner
    assert_equal owner, @spec.owner
  end

  def test_resource_owner
    @spec.resource('foo') { url 'foo-1.0' }
    @spec.owner = stub(:name => 'some_name')
    assert_equal 'some_name', @spec.name
    @spec.resources.each_value { |r| assert_equal @spec, r.owner }
  end

  def test_resource_without_version_receives_owners_version
    @spec.url('foo-42')
    @spec.resource('bar') { url 'bar' }
    @spec.owner = stub(:name => 'some_name')
    assert_version_equal '42', @spec.resource('bar').version
  end

  def test_option
    @spec.option('foo')
    assert @spec.build.has_option? 'foo'
  end

  def test_option_raises_when_begins_with_dashes
    assert_raises(RuntimeError) { @spec.option('--foo') }
  end

  def test_option_raises_when_name_empty
    assert_raises(RuntimeError) { @spec.option('') }
  end

  def test_option_accepts_symbols
    @spec.option(:foo)
    assert @spec.build.has_option? 'foo'
  end

  def test_depends_on
    @spec.depends_on('foo')
    assert_equal 'foo', @spec.deps.first.name
  end

  def test_dependency_option_integration
    @spec.depends_on 'foo' => :optional
    @spec.depends_on 'bar' => :recommended
    assert @spec.build.has_option?('with-foo')
    assert @spec.build.has_option?('without-bar')
  end

  def test_explicit_options_override_default_dep_option_description
    @spec.option('with-foo', 'blah')
    @spec.depends_on('foo' => :optional)
    assert_equal 'blah', @spec.build.first.description
  end

  def test_patch
    @spec.patch :p1, :DATA
    assert_equal 1, @spec.patches.length
    assert_equal :p1, @spec.patches.first.strip
  end
end

class HeadSoftwareSpecTests < Homebrew::TestCase
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

class BottleSpecificationTests < Homebrew::TestCase
  def setup
    @spec = BottleSpecification.new
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
      hsh, _ = @spec.collector.fetch_bottle_for(cat)
      assert_equal Checksum.new(:sha1, sha1), hsh
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
