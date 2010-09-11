require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'test/testball'
require 'utils'

class MockFormula <Formula
  def initialize url
    @url=url
    @homepage = 'http://example.com/'
    super 'test'
  end
end

class TestZip <Formula
  def initialize
    zip=HOMEBREW_CACHE.parent+'test-0.1.zip'
    Kernel.system '/usr/bin/zip', '-0', zip, ABS__FILE__
    @url="file://#{zip}"
    @homepage = 'http://example.com/'
    super 'testzip'
  end
end

# All other tests so far -- feel free to break them out into
# separate TestCase classes.

class BeerTasting < Test::Unit::TestCase
  def test_supported_compressed_types
    assert_nothing_raised do
      MockFormula.new 'test-0.1.tar.gz'
      MockFormula.new 'test-0.1.tar.bz2'
      MockFormula.new 'test-0.1.tgz'
      MockFormula.new 'test-0.1.bgz'
      MockFormula.new 'test-0.1.zip'
    end
  end

  FOOBAR='foo-bar'
  def test_formula_funcs
    classname=Formula.class_s(FOOBAR)
    path=Formula.path(FOOBAR)
    
    assert_equal "FooBar", classname
    assert_match Regexp.new("^#{HOMEBREW_PREFIX}/Library/Formula"), path.to_s

    path=HOMEBREW_PREFIX+"Library/Formula/#{FOOBAR}.rb"
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
  
  def test_brew_h
    require 'cmd/info'
    require 'cmd/prune'
    require 'cleaner'

    nostdout do
      assert_nothing_raised do
        f=TestBall.new
        Homebrew.info_formula f
        Cleaner.new f
        Homebrew.prune
        #TODO test diy function too
      end
    end
  end

  def test_brew_cleanup
    require 'cmd/cleanup'

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
      Homebrew.cleanup_formula f3
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

        HOMEBREW_CACHE.chmod_R 0777
      end
    end
  end
  
  def test_pathname_properties
    foo1=HOMEBREW_CACHE+'foo-0.1.tar.gz'
    
    assert_equal '.tar.gz', foo1.extname
    assert_equal 'foo-0.1', foo1.stem
    assert_equal '0.1', foo1.version
  end

  class MockMockFormula < Struct.new(:name); end

  def test_formula_equality
    f = MockFormula.new('http://example.com/test-0.1.tgz')
    g = MockMockFormula.new('test')

    assert f == f
    assert f == g
    assert f.eql? f
    assert (not (f.eql? g))
  end
end
