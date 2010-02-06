# All other tests so far -- feel free to break them out into
# separate TestCase classes.

class BeerTasting < Test::Unit::TestCase
  def test_put_columns_empty
    assert_nothing_raised do
      # Issue #217 put columns with new results fails.
      puts_columns []
    end
  end

  def test_supported_compressed_types
    assert_nothing_raised do
      MockFormula.new 'test-0.1.tar.gz'
      MockFormula.new 'test-0.1.tar.bz2'
      MockFormula.new 'test-0.1.tgz'
      MockFormula.new 'test-0.1.bgz'
      MockFormula.new 'test-0.1.zip'
    end
  end

  def test_prefix
    nostdout do
      TestBall.new.brew do |f|
        assert_equal File.expand_path(f.prefix), (HOMEBREW_CELLAR+f.name+'0.1').to_s
        assert_kind_of Pathname, f.prefix
      end
    end
  end
  
  def test_no_version
    assert_nil Pathname.new("http://example.com/blah.tar").version
    assert_nil Pathname.new("arse").version
  end
  
  def test_bad_version
    assert_raises(RuntimeError) {f=TestBadVersion.new}
  end
  
  def test_install
    f=TestBall.new
    
    assert_equal Formula.path(f.name), f.path
    assert !f.installed?
    
    nostdout do
      f.brew do
        f.install
      end
    end
    
    assert_match Regexp.new("^#{HOMEBREW_CELLAR}/"), f.prefix.to_s
    
    assert f.bin.directory?
    assert_equal 3, f.bin.children.length
    libexec=f.prefix+'libexec'
    assert libexec.directory?
    assert_equal 1, libexec.children.length
    assert !(f.prefix+'main.c').exist?
    assert f.installed?
    
    keg=Keg.new f.prefix
    keg.link
    assert_equal 2, HOMEBREW_PREFIX.children.length
    assert (HOMEBREW_PREFIX+'bin').directory?
    assert_equal 3, (HOMEBREW_PREFIX+'bin').children.length
    
    keg.uninstall
    assert !keg.exist?
    assert !f.installed?
  end
  
  def test_script_install
    f=TestScriptFileFormula.new
    
    nostdout do
      f.brew do
        f.install
      end
    end
    
    assert_equal 1, f.bin.children.length
  end

  FOOBAR='foo-bar'
  def test_formula_funcs
    classname=Formula.class_s(FOOBAR)
    path=Formula.path(FOOBAR)
    
    assert_equal "FooBar", classname
    assert_match Regexp.new("^#{HOMEBREW_PREFIX}/Library/Formula"), path.to_s

    path=HOMEBREW_PREFIX+'Library'+'Formula'+"#{FOOBAR}.rb"
    path.dirname.mkpath
    File.open(path, 'w') do |f|
      f << %{
        require 'formula'
        class #{classname} < Formula
          @url=''
          def initialize(*args)
            @homepage = 'http://example.com/'
            super
          end
        end
      }
    end
    
    assert_not_nil Formula.factory(FOOBAR)
  end
  
  def test_cant_override_brew
    assert_raises(RuntimeError) { TestBallOverrideBrew.new }
  end
  
  def test_abstract_formula
    f=MostlyAbstractFormula.new
    assert_equal '__UNKNOWN__', f.name
    assert_raises(RuntimeError) { f.prefix }
    nostdout { assert_raises(RuntimeError) { f.brew } }
  end

  def test_zip
    nostdout { assert_nothing_raised { TestZip.new.brew {} } }
  end
  
  # needs resurrecting
  # def test_no_ARGV_dupes
  #   ARGV.reset
  #   ARGV << 'foo' << 'foo'
  #   n=0
  #   ARGV.named.each{|f| n+=1 if f == 'foo'}
  #   assert_equal 1, n
  # end
  
  def test_ARGV
    assert_raises(FormulaUnspecifiedError) { ARGV.formulae }
    assert_raises(KegUnspecifiedError) { ARGV.kegs }
    assert ARGV.named.empty?
    
    (HOMEBREW_CELLAR+'mxcl'+'10.0').mkpath
    
    ARGV.reset
    ARGV.unshift 'mxcl'
    assert_equal 1, ARGV.named.length
    assert_equal 1, ARGV.kegs.length
    assert_raises(FormulaUnavailableError) { ARGV.formulae }
  end
  
  # these will raise if we don't recognise your mac, but that prolly 
  # indicates something went wrong rather than we don't know
  def test_hardware_cpu_type
    assert [:intel, :ppc].include?(Hardware.cpu_type)
  end
  
  def test_hardware_intel_family
    if Hardware.cpu_type == :intel
      assert [:core, :core2, :penryn, :nehalem].include?(Hardware.intel_family)
    end
  end
  
  def test_brew_h
    nostdout do
      assert_nothing_raised do
        f=TestBall.new
        make f.url
        info f.name
        clean f
        prune
        #TODO test diy function too
      end
    end
  end

  def test_brew_cleanup
    f1=TestBall.new
    f1.instance_eval { @version = "0.1" }
    f2=TestBall.new
    f2.instance_eval { @version = "0.2" }
    f3=TestBall.new
    f3.instance_eval { @version = "0.3" }

    nostdout do
      f1.brew { f1.install }
      f2.brew { f2.install }
      f3.brew { f3.install }
    end

    assert f1.installed?
    assert f2.installed?
    assert f3.installed?

    nostdout do
      cleanup f3
    end

    assert !f1.installed?
    assert !f2.installed?
    assert f3.installed?
  end

  def test_my_float_assumptions
    # this may look ridiculous but honestly there's code in brewit that depends on 
    # this behaviour so I wanted to be certain Ruby floating points are behaving
    f='10.6'.to_f
    assert_equal 10.6, f
    assert f >= 10.6
    assert f <= 10.6
    assert_equal 10.5, f-0.1
    assert_equal 10.7, f+0.1
  end

  def test_arch_for_command
    arches=archs_for_command '/usr/bin/svn'
    if `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i >= 6
      assert_equal 3, arches.length
      assert arches.include?(:x86_64)
    else
      assert_equal 2, arches.length
    end
    assert arches.include?(:i386)
    assert arches.include?(:ppc7400)
  end

  def test_pathname_version
    d=HOMEBREW_CELLAR+'foo-0.1.9'
    d.mkpath
    assert_equal '0.1.9', d.version
  end
  
  def test_pathname_plus_yeast
    nostdout do
      assert_nothing_raised do
        assert !Pathname.getwd.rmdir_if_possible
        assert !Pathname.getwd.abv.empty?
        
        abcd=orig_abcd=HOMEBREW_CACHE+'abcd'
        FileUtils.cp ABS__FILE__, abcd
        abcd=HOMEBREW_PREFIX.install abcd
        assert (HOMEBREW_PREFIX+orig_abcd.basename).exist?
        assert abcd.exist?
        assert_equal HOMEBREW_PREFIX+'abcd', abcd

        assert_raises(RuntimeError) {abcd.write 'CONTENT'}
        abcd.unlink
        abcd.write 'HELLOWORLD'
        assert_equal 'HELLOWORLD', File.read(abcd)
        
        assert !orig_abcd.exist?
        rv=abcd.cp orig_abcd
        assert orig_abcd.exist?
        assert_equal rv, orig_abcd

        orig_abcd.unlink
        assert !orig_abcd.exist?
        abcd.cp HOMEBREW_CACHE
        assert orig_abcd.exist?

        foo1=HOMEBREW_CACHE+'foo-0.1.tar.gz'
        FileUtils.cp ABS__FILE__, foo1
        assert foo1.file?
        
        assert_equal '.tar.gz', foo1.extname
        assert_equal 'foo-0.1', foo1.stem
        assert_equal '0.1', foo1.version
        
        HOMEBREW_CACHE.chmod_R 0777
      end
    end
    
    assert_raises(RuntimeError) {Pathname.getwd.install 'non_existant_file'}
  end
  
  def test_formula_class_func
    assert_equal Formula.class_s('s-lang'), 'SLang'
    assert_equal Formula.class_s('pkg-config'), 'PkgConfig'
    assert_equal Formula.class_s('foo_bar'), 'FooBar'
  end
  
  def test_class_names
    assert_equal 'ShellFm', Formula.class_s('shell.fm')
    assert_equal 'Fooxx', Formula.class_s('foo++')
  end
      
  def test_ENV_options
    require 'extend/ENV'
    ENV.extend(HomebrewEnvExtension)

    ENV.gcc_4_0
    ENV.gcc_4_2
    ENV.O3
    ENV.minimal_optimization
    ENV.no_optimization
    ENV.libxml2
    ENV.x11
    ENV.enable_warnings
    assert !ENV.cc.empty?
    assert !ENV.cxx.empty?
  end
end
