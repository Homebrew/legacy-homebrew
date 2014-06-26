require 'testing_env'
require 'keg'
require 'stringio'

class LinkTests < Homebrew::TestCase
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
    mkpath HOMEBREW_PREFIX/"lib"
  end

  def teardown
    @keg.unlink
    @keg.uninstall

    $stdout = @old_stdout

    rmtree HOMEBREW_PREFIX/"bin"
    rmtree HOMEBREW_PREFIX/"lib"
  end

  def test_linking_keg
    assert_equal 3, @keg.link
    (HOMEBREW_PREFIX/"bin").children.each { |c| assert_predicate c.readlink, :relative? }
  end

  def test_unlinking_keg
    @keg.link
    assert_equal 4, @keg.unlink
  end

  def test_link_dry_run
    @mode.dry_run = true

    assert_equal 0, @keg.link(@mode)
    refute_predicate @keg, :linked?

    ['hiworld', 'helloworld', 'goodbye_cruel_world'].each do |file|
      assert_match "#{HOMEBREW_PREFIX}/bin/#{file}", $stdout.string
    end
    assert_equal 3, $stdout.string.lines.count
  end

  def test_linking_fails_when_already_linked
    @keg.link
    assert_raises Keg::AlreadyLinkedError do
      shutup { @keg.link }
    end
  end

  def test_linking_fails_when_files_exist
    touch HOMEBREW_PREFIX/"bin/helloworld"
    assert_raises Keg::ConflictError do
      shutup { @keg.link }
    end
  end

  def test_link_ignores_broken_symlinks_at_target
    dst = HOMEBREW_PREFIX/"bin/helloworld"
    src = @keg/"bin/helloworld"
    ln_s "/some/nonexistent/path", dst
    shutup { @keg.link }
    assert_equal src.relative_path_from(dst.dirname), dst.readlink
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
    refute_predicate @keg, :linked?

    assert_equal "#{HOMEBREW_PREFIX}/bin/helloworld\n", $stdout.string
  end

  def test_unlink_prunes_empty_toplevel_directories
    mkpath HOMEBREW_PREFIX/"lib/foo/bar"
    mkpath @keg/"lib/foo/bar"
    touch @keg/"lib/foo/bar/file1"

    @keg.unlink

    refute_predicate HOMEBREW_PREFIX/"lib/foo", :directory?
  end

  def test_unlink_ignores_DS_Store_when_pruning_empty_dirs
    mkpath HOMEBREW_PREFIX/"lib/foo/bar"
    touch HOMEBREW_PREFIX/"lib/foo/.DS_Store"
    mkpath @keg/"lib/foo/bar"
    touch @keg/"lib/foo/bar/file1"

    @keg.unlink

    refute_predicate HOMEBREW_PREFIX/"lib/foo", :directory?
    refute_predicate HOMEBREW_PREFIX/"lib/foo/.DS_Store", :exist?
  end
end
