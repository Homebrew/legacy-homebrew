require 'testing_env'
require 'test/testball'

# All other tests so far -- feel free to break them out into
# separate TestCase classes.

class BeerTasting < Test::Unit::TestCase
  include VersionAssertions

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
          url ''
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
    zip = HOMEBREW_CACHE.parent + 'test-0.1.zip'
    Kernel.system '/usr/bin/zip', '-q', '-0', zip, ABS__FILE__

    shutup do
      assert_nothing_raised do
        Class.new(Formula) do
          url "file://#{zip}"
        end.new("test_zip").brew {}
      end
    end
  ensure
    zip.unlink if zip.exist?
  end

  def test_brew_h
    require 'cmd/info'
    require 'cmd/prune'
    require 'cleaner'

    shutup do
      assert_nothing_raised do
        f = Class.new(TestBall) do
          def initialize(*)
            super
            @path = Pathname.new(__FILE__)
          end
        end.new
        Homebrew.info_formula f
        Homebrew.prune
        #TODO test diy function too
      end
    end
  end

  def test_brew_cleanup
    require 'cmd/cleanup'

    f1 = Class.new(TestBall) { version '0.1' }.new
    f2 = Class.new(TestBall) { version '0.2' }.new
    f3 = Class.new(TestBall) { version '0.3' }.new

    shutup do
      f1.brew { f1.install }
      f2.brew { f2.install }
      f3.brew { f3.install }
    end

    assert f1.installed?
    assert f2.installed?
    assert f3.installed?

    shutup { Homebrew.cleanup_formula(f3) }

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
end
