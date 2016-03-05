require "testing_env"
require "tab"
require "formula"

class TabTests < Homebrew::TestCase
  def setup
    @used = Options.create(%w[--with-foo --without-bar])
    @unused = Options.create(%w[--with-baz --without-qux])

    @tab = Tab.new("used_options"         => @used.as_flags,
                   "unused_options"       => @unused.as_flags,
                   "built_as_bottle"      => false,
                   "poured_from_bottle"   => true,
                   "time"                 => nil,
                   "source_modified_time" => 0,
                   "HEAD"                 => TEST_SHA1,
                   "compiler"             => "clang",
                   "stdlib"               => "libcxx",
                   "source"               => {
                     "tap" => "homebrew/core",
                     "path" => nil,
                     "spec" => "stable"
                   })
  end

  def test_defaults
    tab = Tab.empty
    assert_empty tab.unused_options
    assert_empty tab.used_options
    refute_predicate tab, :built_as_bottle
    refute_predicate tab, :poured_from_bottle
    assert_nil tab.tap
    assert_nil tab.time
    assert_nil tab.HEAD
    assert_equal MacOS.default_compiler, tab.cxxstdlib.compiler
    assert_nil tab.cxxstdlib.type
  end

  def test_include?
    assert_includes @tab, "with-foo"
    assert_includes @tab, "without-bar"
  end

  def test_with?
    assert @tab.with?("foo")
    assert @tab.with?("qux")
    refute @tab.with?("bar")
    refute @tab.with?("baz")
  end

  def test_universal?
    tab = Tab.new(:used_options => %w[--universal])
    assert_predicate tab, :universal?
  end

  def test_cxxstdlib
    assert_equal :clang, @tab.cxxstdlib.compiler
    assert_equal :libcxx, @tab.cxxstdlib.type
  end

  def test_other_attributes
    assert_equal TEST_SHA1, @tab.HEAD
    assert_equal "homebrew/core", @tab.tap.name
    assert_nil @tab.time
    refute_predicate @tab, :built_as_bottle
    assert_predicate @tab, :poured_from_bottle
  end

  def test_from_old_version_file
    path = Pathname.new(TEST_DIRECTORY).join("fixtures", "receipt_old.json")
    tab = Tab.from_file(path)

    assert_equal @used.sort, tab.used_options.sort
    assert_equal @unused.sort, tab.unused_options.sort
    refute_predicate tab, :built_as_bottle
    assert_predicate tab, :poured_from_bottle
    assert_equal "homebrew/core", tab.tap.name
    assert_equal :stable, tab.spec
    refute_nil tab.time
    assert_equal TEST_SHA1, tab.HEAD
    assert_equal :clang, tab.cxxstdlib.compiler
    assert_equal :libcxx, tab.cxxstdlib.type
  end

  def test_from_file
    path = Pathname.new(TEST_DIRECTORY).join("fixtures", "receipt.json")
    tab = Tab.from_file(path)

    assert_equal @used.sort, tab.used_options.sort
    assert_equal @unused.sort, tab.unused_options.sort
    refute_predicate tab, :built_as_bottle
    assert_predicate tab, :poured_from_bottle
    assert_equal "homebrew/core", tab.tap.name
    assert_equal :stable, tab.spec
    refute_nil tab.time
    assert_equal TEST_SHA1, tab.HEAD
    assert_equal :clang, tab.cxxstdlib.compiler
    assert_equal :libcxx, tab.cxxstdlib.type
  end

  def test_to_json
    tab = Tab.new(Utils::JSON.load(@tab.to_json))
    assert_equal @tab.used_options.sort, tab.used_options.sort
    assert_equal @tab.unused_options.sort, tab.unused_options.sort
    assert_equal @tab.built_as_bottle, tab.built_as_bottle
    assert_equal @tab.poured_from_bottle, tab.poured_from_bottle
    assert_equal @tab.tap, tab.tap
    assert_equal @tab.spec, tab.spec
    assert_equal @tab.time, tab.time
    assert_equal @tab.HEAD, tab.HEAD
    assert_equal @tab.compiler, tab.compiler
    assert_equal @tab.stdlib, tab.stdlib
  end

  def test_remap_deprecated_options
    deprecated_options = [DeprecatedOption.new("with-foo", "with-foo-new")]
    remapped_options = Tab.remap_deprecated_options(deprecated_options, @tab.used_options)
    assert_includes remapped_options, Option.new("without-bar")
    assert_includes remapped_options, Option.new("with-foo-new")
  end
end

class TabLoadingTests < Homebrew::TestCase
  def setup
    @f = formula { url "foo-1.0" }
    @f.prefix.mkpath
    @path = @f.prefix.join(Tab::FILENAME)
    @path.write Pathname.new(TEST_DIRECTORY).join("fixtures", "receipt.json").read
  end

  def teardown
    @f.rack.rmtree
  end

  def test_for_keg
    tab = Tab.for_keg(@f.prefix)
    assert_equal @path, tab.tabfile
  end

  def test_for_keg_nonexistent_path
    @path.unlink
    tab = Tab.for_keg(@f.prefix)
    assert_nil tab.tabfile
  end

  def test_for_formula
    tab = Tab.for_formula(@f)
    assert_equal @path, tab.tabfile
  end

  def test_for_formula_nonexistent_path
    @path.unlink
    tab = Tab.for_formula(@f)
    assert_nil tab.tabfile
  end

  def test_for_formula_multiple_kegs
    f2 = formula { url "foo-2.0" }
    f2.prefix.mkpath

    assert_equal @f.rack, f2.rack
    assert_equal 2, @f.installed_prefixes.length

    tab = Tab.for_formula(@f)
    assert_equal @path, tab.tabfile
  end

  def test_for_formula_outdated_keg
    f2 = formula { url "foo-2.0" }

    assert_equal @f.rack, f2.rack
    assert_equal 1, @f.installed_prefixes.length

    tab = Tab.for_formula(f2)
    assert_equal @path, tab.tabfile
  end
end
