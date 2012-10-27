require 'testing_env'
require 'test/testball'
require 'keg'
require 'stringio'

class LinkTests < Test::Unit::TestCase
  def setup
    @formula = TestBall.new
    shutup do
      @formula.brew { @formula.install }
    end
    @keg = Keg.for @formula.prefix
    @keg.unlink

    @old_stdout = $stdout
    $stdout = StringIO.new

    FileUtils.mkpath HOMEBREW_PREFIX/"bin"
  end

  def test_linking_keg
    assert_equal 3, @keg.link
  end

  def test_unlinking_keg
    @keg.link
    assert_equal 3, @keg.unlink
  end

  def test_link_dry_run
    mode = OpenStruct.new
    mode.dry_run = true

    assert_equal 0, @keg.link(mode)
    assert !@keg.linked?

    ['hiworld', 'helloworld', 'goodbye_cruel_world'].each do |file|
      assert_match "/private/tmp/testbrew/prefix/bin/#{file}", $stdout.string
    end
    assert_equal 3, $stdout.string.lines.count
  end

  def test_linking_fails_when_already_linked
    @keg.link
    assert_raise RuntimeError, "Cannot link testball" do
      @keg.link
    end
  end

  def test_linking_fails_when_files_exist
    FileUtils.touch HOMEBREW_PREFIX/"bin/helloworld"
    assert_raise RuntimeError do
      @keg.link
    end
  end

  def test_link_overwrite
    FileUtils.touch HOMEBREW_PREFIX/"bin/helloworld"
    mode = OpenStruct.new
    mode.overwrite = true
    assert_equal 3, @keg.link(mode)
  end

  def test_link_overwrite_dryrun
    FileUtils.touch HOMEBREW_PREFIX/"bin/helloworld"
    mode = OpenStruct.new
    mode.overwrite = true
    mode.dry_run = true

    assert_equal 0, @keg.link(mode)
    assert !@keg.linked?

    assert_equal "/private/tmp/testbrew/prefix/bin/helloworld\n", $stdout.string
  end

  def teardown
    @keg.unlink
    @keg.rmtree

    $stdout = @old_stdout

    FileUtils.rmtree HOMEBREW_PREFIX/"bin"
  end
end
