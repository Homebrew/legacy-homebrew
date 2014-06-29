require "testing_env"
require "tab"

class TabTests < Homebrew::TestCase
  def setup
    @used, @unused = Options.new, Options.new
    @used << Option.new("with-foo") << Option.new("without-bar")
    @unused << Option.new("with-baz") << Option.new("without-qux")

    @tab = Tab.new({
      :used_options       => @used,
      :unused_options     => @unused,
      :build_as_bottle    => false,
      :poured_from_bottle => true,
      :tapped_from        => "Homebrew/homebrew",
      :time               => nil,
      :HEAD               => TEST_SHA1,
      :compiler           => :clang,
      :stdlib             => :libcxx,
    })
  end

  def test_defaults
    tab = Tab.dummy_tab
    assert_empty tab.unused_options
    assert_empty tab.used_options
    assert_empty tab.options
    refute tab.built_as_bottle
    refute tab.poured_from_bottle
    assert_empty tab.tapped_from
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
    refute_predicate @tab, :universal?
    @used << "universal"
    assert_predicate @tab, :universal?
  end

  def test_options
    assert_equal (@used + @unused).to_a, @tab.options.to_a
  end

  def test_cxxstdlib
    assert_equal :clang, @tab.cxxstdlib.compiler
    assert_equal :libcxx, @tab.cxxstdlib.type
  end

  def test_other_attributes
    assert_equal TEST_SHA1, @tab.HEAD
    assert_equal "Homebrew/homebrew", @tab.tapped_from
    assert_nil @tab.time
    refute_predicate @tab, :built_as_bottle
    assert_predicate @tab, :poured_from_bottle
  end

  def test_from_file
    path = Pathname.new(TEST_DIRECTORY).join("fixtures", "receipt.json")
    tab = Tab.from_file(path)

    assert_equal @used.to_a, tab.used_options.to_a
    assert_equal @unused.to_a, tab.unused_options.to_a
    assert_equal (@used + @unused).to_a, tab.options.to_a
    refute_predicate tab, :built_as_bottle
    assert_predicate tab, :poured_from_bottle
    assert_equal "Homebrew/homebrew", tab.tapped_from
    refute_nil tab.time
    assert_equal TEST_SHA1, tab.HEAD
    assert_equal :clang, tab.cxxstdlib.compiler
    assert_equal :libcxx, tab.cxxstdlib.type
  end
end
