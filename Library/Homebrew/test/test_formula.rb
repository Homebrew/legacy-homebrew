require "testing_env"
require "testball"
require "formula"

class FormulaTests < Homebrew::TestCase
  def test_formula_instantiation
    klass = Class.new(Formula) { url "http://example.com/foo-1.0.tar.gz" }
    name = "formula_name"
    path = Formulary.core_path(name)
    spec = :stable

    f = klass.new(name, path, spec)
    assert_equal name, f.name
    assert_equal path, f.path
    assert_raises(ArgumentError) { klass.new }
  end

  def test_prefix
    f = Testball.new
    assert_equal HOMEBREW_CELLAR/f.name/"0.1", f.prefix
    assert_kind_of Pathname, f.prefix
  end

  def test_revised_prefix
    f = Class.new(Testball) { revision 1 }.new
    assert_equal HOMEBREW_CELLAR/f.name/"0.1_1", f.prefix
  end

  def test_any_version_installed?
    f = formula do
      url "foo"
      version "1.0"
    end
    refute_predicate f, :any_version_installed?
    prefix = HOMEBREW_CELLAR+f.name+"0.1"
    prefix.mkpath
    FileUtils.touch prefix+Tab::FILENAME
    assert_predicate f, :any_version_installed?
  ensure
    f.rack.rmtree
  end

  def test_installed?
    f = Testball.new
    f.stubs(:installed_prefix).returns(stub(:directory? => false))
    refute_predicate f, :installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [])
    )
    refute_predicate f, :installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [stub])
    )
    assert_predicate f, :installed?
  end

  def test_installed_prefix
    f = Testball.new
    assert_equal f.prefix, f.installed_prefix
  end

  def test_installed_prefix_head_installed
    f = formula do
      head "foo"
      devel do
        url "foo"
        version "1.0"
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.head.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_devel_installed
    f = formula do
      head "foo"
      devel do
        url "foo"
        version "1.0"
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.devel.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_stable_installed
    f = formula do
      head "foo"
      devel do
        url "foo"
        version "1.0-devel"
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_head
    f = formula("test", Pathname.new(__FILE__).expand_path, :head) do
      head "foo"
      devel do
        url "foo"
        version "1.0-devel"
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.head.version
    assert_equal prefix, f.installed_prefix
  end

  def test_installed_prefix_devel
    f = formula("test", Pathname.new(__FILE__).expand_path, :devel) do
      head "foo"
      devel do
        url "foo"
        version "1.0-devel"
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.devel.version
    assert_equal prefix, f.installed_prefix
  end

  def test_equality
    x = Testball.new
    y = Testball.new
    assert_equal x, y
    assert_eql x, y
    assert_equal x.hash, y.hash
  end

  def test_inequality
    x = Testball.new("foo")
    y = Testball.new("bar")
    refute_equal x, y
    refute_eql x, y
    refute_equal x.hash, y.hash
  end

  def test_comparison_with_non_formula_objects_does_not_raise
    refute_equal Testball.new, Object.new
  end

  def test_sort_operator
    assert_nil Testball.new <=> Object.new
  end

  def test_formula_spec_integration
    f = formula do
      homepage "http://example.com"
      url "http://example.com/test-0.1.tbz"
      mirror "http://example.org/test-0.1.tbz"
      sha1 TEST_SHA1

      head "http://example.com/test.git", :tag => "foo"

      devel do
        url "http://example.com/test-0.2.tbz"
        mirror "http://example.org/test-0.2.tbz"
        sha256 TEST_SHA256
      end
    end

    assert_equal "http://example.com", f.homepage
    assert_version_equal "0.1", f.version
    assert_predicate f, :stable?

    assert_version_equal "0.1", f.stable.version
    assert_version_equal "0.2", f.devel.version
    assert_version_equal "HEAD", f.head.version
  end

  def test_formula_set_active_spec
    f = formula do
      url "foo"
      version "1.0"
      revision 1

      devel do
        url "foo"
        version "1.0beta"
      end
    end
    assert_equal :stable, f.active_spec_sym
    assert_equal f.stable, f.send(:active_spec)
    assert_equal "1.0_1", f.pkg_version.to_s
    f.set_active_spec(:devel)
    assert_equal :devel, f.active_spec_sym
    assert_equal f.devel, f.send(:active_spec)
    assert_equal "1.0beta_1", f.pkg_version.to_s
    assert_raises(FormulaSpecificationError) { f.set_active_spec(:head) }
  end

  def test_path
    name = "foo-bar"
    assert_equal Pathname.new("#{HOMEBREW_LIBRARY}/Formula/#{name}.rb"), Formulary.core_path(name)
  end

  def test_class_specs_are_always_initialized
    f = formula { url "foo-1.0" }

    %w[stable devel head].each do |spec|
      assert_kind_of SoftwareSpec, f.class.send(spec)
    end
  end

  def test_incomplete_instance_specs_are_not_accessible
    f = formula { url "foo-1.0" }

    %w[devel head].each { |spec| assert_nil f.send(spec) }
  end

  def test_honors_attributes_declared_before_specs
    f = formula do
      url "foo-1.0"
      depends_on "foo"
      devel { url "foo-1.1" }
    end

    %w[stable devel head].each do |spec|
      assert_equal "foo", f.class.send(spec).deps.first.name
    end
  end

  def test_simple_version
    assert_equal PkgVersion.parse("1.0"), formula { url "foo-1.0.bar" }.pkg_version
  end

  def test_version_with_revision
    f = formula do
      url "foo-1.0.bar"
      revision 1
    end

    assert_equal PkgVersion.parse("1.0_1"), f.pkg_version
  end

  def test_head_ignores_revisions
    f = formula("test", Pathname.new(__FILE__).expand_path, :head) do
      url "foo-1.0.bar"
      revision 1
      head "foo"
    end

    assert_equal PkgVersion.parse("HEAD"), f.pkg_version
  end

  def test_legacy_options
    f = formula do
      url "foo-1.0"

      def options
        [["--foo", "desc"], ["--bar", "desc"]]
      end

      option "baz"
    end

    assert f.option_defined?("foo")
    assert f.option_defined?("bar")
    assert f.option_defined?("baz")
  end

  def test_desc
    f = formula do
      desc "a formula"
      url "foo-1.0"
    end

    assert_equal "a formula", f.desc
  end

  def test_post_install_defined
    f1 = formula do
      url "foo-1.0"

      def post_install; end
    end

    f2 = formula do
      url "foo-1.0"
    end

    assert f1.post_install_defined?
    refute f2.post_install_defined?
  end

  def test_test_defined
    f1 = formula do
      url "foo-1.0"

      def test; end
    end

    f2 = formula do
      url "foo-1.0"
    end

    assert f1.test_defined?
    refute f2.test_defined?
  end

  def test_test_fixtures
    f1 = formula do
      url "foo-1.0"
    end

    assert_equal Pathname.new("#{HOMEBREW_LIBRARY}/Homebrew/test/fixtures/foo"),
      f1.test_fixtures("foo")
  end

  def test_to_hash
    f1 = formula("foo") do
      url "foo-1.0"
    end

    h = f1.to_hash
    assert h.is_a?(Hash), "Formula#to_hash should return a Hash"
    assert_equal "foo", h["name"]
    assert_equal "foo", h["full_name"]
    assert_equal "1.0", h["versions"]["stable"]
  end

  def test_to_hash_bottle
    MacOS.stubs(:version).returns(MacOS::Version.new("10.11"))

    f1 = formula("foo") do
      url "foo-1.0"

      bottle do
        cellar :any
        sha256 TEST_SHA256 => :el_capitan
      end
    end

    h = f1.to_hash
    assert h.is_a?(Hash), "Formula#to_hash should return a Hash"
    assert h["versions"]["bottle"], "The hash should say the formula is bottled"
  end

  def test_eligible_kegs_for_cleanup
    f1 = Class.new(Testball) { version "0.1" }.new
    f2 = Class.new(Testball) { version "0.2" }.new
    f3 = Class.new(Testball) { version "0.3" }.new

    shutup do
      f1.brew { f1.install }
      f2.brew { f2.install }
      f3.brew { f3.install }
    end

    assert_predicate f1, :installed?
    assert_predicate f2, :installed?
    assert_predicate f3, :installed?

    assert_equal f3.installed_kegs[0..1], f3.eligible_kegs_for_cleanup
  ensure
    [f1, f2, f3].each(&:clear_cache)
    f3.rack.rmtree
  end
end
