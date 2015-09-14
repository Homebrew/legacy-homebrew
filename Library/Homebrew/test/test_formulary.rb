require "testing_env"

class FormularyTest < Homebrew::TestCase
  def test_class_naming
    assert_equal "ShellFm", Formulary.class_s("shell.fm")
    assert_equal "Fooxx", Formulary.class_s("foo++")
    assert_equal "SLang", Formulary.class_s("s-lang")
    assert_equal "PkgConfig", Formulary.class_s("pkg-config")
    assert_equal "FooBar", Formulary.class_s("foo_bar")
  end
end

class FormularyFactoryTest < Homebrew::TestCase
  def setup
    @name = "testball_bottle"
    @path = HOMEBREW_PREFIX/"Library/Formula/#{@name}.rb"
    @bottle_dir = Pathname.new("#{File.expand_path("..", __FILE__)}/bottles")
    @bottle = @bottle_dir/"testball_bottle-0.1.#{bottle_tag}.bottle.tar.gz"
    @path.write <<-EOS.undent
      class #{Formulary.class_s(@name)} < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
        sha256 "1dfb13ce0f6143fe675b525fc9e168adb2215c5d5965c9f57306bb993170914f"

        bottle do
          cellar :any_skip_relocation
          root_url "file://#{@bottle_dir}"
          sha256 "9abc8ce779067e26556002c4ca6b9427b9874d25f0cafa7028e05b5c5c410cb4" => :#{bottle_tag}
        end

        def install
          prefix.install "bin"
          prefix.install "libexec"
        end
      end
    EOS
  end

  def teardown
    @path.unlink
  end

  def test_factory
    assert_kind_of Formula, Formulary.factory(@name)
  end

  def test_factory_with_fully_qualified_name
    assert_kind_of Formula, Formulary.factory("homebrew/homebrew/#{@name}")
  end

  def test_formula_unavailable_error
    assert_raises(FormulaUnavailableError) { Formulary.factory("not_existed_formula") }
  end

  def test_factory_from_path
    assert_kind_of Formula, Formulary.factory(@path)
  end

  def test_factory_from_url
    formula = shutup { Formulary.factory("file://#{@path}") }
    assert_kind_of Formula, formula
  ensure
    formula.path.unlink
  end

  def test_factory_from_bottle
    formula = Formulary.factory(@bottle)
    assert_kind_of Formula, formula
    assert_equal @bottle.realpath, formula.local_bottle_path
  end

  def test_factory_from_alias
    alias_dir = HOMEBREW_LIBRARY/"Aliases"
    alias_dir.mkpath
    FileUtils.ln_s @path, alias_dir/"foo"
    assert_kind_of Formula, Formulary.factory("foo")
  ensure
    alias_dir.rmtree
  end

  def test_factory_from_rack
    formula = Formulary.factory(@path)
    installer = FormulaInstaller.new(formula)
    shutup { installer.install }
    keg = Keg.new(formula.prefix)
    assert_kind_of Formula, Formulary.from_rack(formula.rack)
  ensure
    keg.unlink
    keg.uninstall
    formula.clear_cache
    formula.bottle.clear_cache
  end

  def test_load_from_contents
    assert_kind_of Formula, Formulary.from_contents(@name, @path, @path.read)
  end
end

class FormularyTapFactoryTest < Homebrew::TestCase
  def setup
    @name = "foo"
    @tap = Tap.new "homebrew", "foo"
    @path = @tap.path/"#{@name}.rb"
    @code = <<-EOS.undent
      class #{Formulary.class_s(@name)} < Formula
        url "foo-1.0"
      end
    EOS
    @path.write @code
  end

  def teardown
    @tap.path.parent.parent.rmtree
  end

  def test_factory_tap_formula
    assert_kind_of Formula, Formulary.factory("#{@name}")
  end

  def test_factory_tap_alias
    alias_dir = @tap.path/"Aliases"
    alias_dir.mkpath
    FileUtils.ln_s @path, alias_dir/"bar"
    assert_kind_of Formula, Formulary.factory("bar")
  end

  def test_tap_formula_unavailable_error
    assert_raises(TapFormulaUnavailableError) { Formulary.factory("#{@tap}/not_existed_formula") }
  end

  def test_factory_tap_formula_with_fully_qualified_name
    assert_kind_of Formula, Formulary.factory("#{@tap}/#{@name}")
  end

  def test_factory_ambiguity_tap_formulae
    another_tap = Tap.new "homebrew", "bar"
    (another_tap.path/"#{@name}.rb").write @code
    assert_raises(TapFormulaAmbiguityError) { Formulary.factory(@name) }
  end
end

class FormularyTapPriorityTest < Homebrew::TestCase
  def setup
    @name = "foo"
    @core_path = HOMEBREW_PREFIX/"Library/Formula/#{@name}.rb"
    @tap = Tap.new "homebrew", "foo"
    @tap_path = @tap.path/"#{@name}.rb"
    code = <<-EOS.undent
      class #{Formulary.class_s(@name)} < Formula
        url "foo-1.0"
      end
    EOS
    @core_path.write code
    @tap_path.write code
  end

  def teardown
    @core_path.unlink
    @tap.path.parent.parent.rmtree
  end

  def test_find_with_priority_core_formula
    formula = Formulary.find_with_priority(@name)
    assert_kind_of Formula, formula
    assert_equal @core_path, formula.path
  end

  def test_find_with_priority_tap_formula
    @tap.pin
    formula = shutup { Formulary.find_with_priority(@name) }
    assert_kind_of Formula, formula
    assert_equal @tap_path.realpath, formula.path
  ensure
    @tap.pinned_symlink_path.parent.parent.rmtree
  end
end
