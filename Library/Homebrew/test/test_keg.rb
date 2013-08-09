require 'testing_env'
require 'keg'
require 'stringio'

class LinkTests < Test::Unit::TestCase
  include FileUtils

  def setup
    @keg = HOMEBREW_CELLAR/"foo/1.0"
    @keg.mkpath
    (@keg/"bin").mkpath

    %w{hiworld helloworld goodbye_cruel_world}.each do |file|
      touch @keg/"bin/#{file}"
    end

    @keg = Keg.new(@keg)

    @mode = OpenStruct.new

    @old_stdout = $stdout
    $stdout = StringIO.new

    mkpath HOMEBREW_PREFIX/"bin"
  end

  def test_linking_keg
    assert_equal 3, @keg.link
  end

  def test_unlinking_keg
    @keg.link
    assert_equal 3, @keg.unlink
  end

  def test_link_dry_run
    @mode.dry_run = true

    assert_equal 0, @keg.link(@mode)
    assert !@keg.linked?

    ['hiworld', 'helloworld', 'goodbye_cruel_world'].each do |file|
      assert_match "/private/tmp/testbrew/prefix/bin/#{file}", $stdout.string
    end
    assert_equal 3, $stdout.string.lines.count
  end

  def test_linking_fails_when_already_linked
    @keg.link
    assert_raise RuntimeError do
      shutup { @keg.link }
    end
  end

  def test_linking_fails_when_files_exist
    touch HOMEBREW_PREFIX/"bin/helloworld"
    assert_raise RuntimeError do
      shutup { @keg.link }
    end
  end

  def test_link_overwrite
    touch HOMEBREW_PREFIX/"bin/helloworld"
    @mode.overwrite = true
    assert_equal 3, @keg.link(@mode)
  end

  def test_link_overwrite_broken_symlinks
    cd HOMEBREW_PREFIX/"bin" do
      ln_s "nowhere", "helloworld"
    end
    @mode.overwrite = true
    assert_equal 3, @keg.link(@mode)
  end

  def test_link_overwrite_dryrun
    touch HOMEBREW_PREFIX/"bin/helloworld"
    @mode.overwrite = true
    @mode.dry_run = true

    assert_equal 0, @keg.link(@mode)
    assert !@keg.linked?

    assert_equal "/private/tmp/testbrew/prefix/bin/helloworld\n", $stdout.string
  end

  def teardown
    @keg.unlink
    @keg.rmtree

    $stdout = @old_stdout

    rmtree HOMEBREW_PREFIX/"bin"
  end
end
