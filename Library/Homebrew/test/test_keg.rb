require 'testing_env'
require 'keg'
require 'stringio'

class LinkTests < Homebrew::TestCase
  include FileUtils

  def setup
    keg = HOMEBREW_CELLAR.join("foo", "1.0")
    keg.join("bin").mkpath

    %w{hiworld helloworld goodbye_cruel_world}.each do |file|
      touch keg.join("bin", file)
    end

    @keg = Keg.new(keg)
    @dst = HOMEBREW_PREFIX.join("bin", "helloworld")

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
    assert_raises(Keg::AlreadyLinkedError) { @keg.link }
  end

  def test_linking_fails_when_files_exist
    touch @dst
    assert_raises(Keg::ConflictError) { @keg.link }
  end

  def test_link_ignores_broken_symlinks_at_target
    src = @keg.join("bin", "helloworld")
    ln_s "/some/nonexistent/path", @dst
    @keg.link
    assert_equal src.relative_path_from(@dst.dirname), @dst.readlink
  end

  def test_link_overwrite
    touch @dst
    @mode.overwrite = true
    assert_equal 3, @keg.link(@mode)
    assert_predicate @keg, :linked?
  end

  def test_link_overwrite_broken_symlinks
    cd HOMEBREW_PREFIX/"bin" do
      ln_s "nowhere", "helloworld"
    end
    @mode.overwrite = true
    assert_equal 3, @keg.link(@mode)
    assert_predicate @keg, :linked?
  end

  def test_link_overwrite_dryrun
    touch @dst
    @mode.overwrite = true
    @mode.dry_run = true

    assert_equal 0, @keg.link(@mode)
    refute_predicate @keg, :linked?

    assert_equal "#{@dst}\n", $stdout.string
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

  def test_linking_creates_opt_link
    refute_predicate @keg, :optlinked?
    @keg.link
    assert_predicate @keg, :optlinked?
  end

  def test_unlinking_does_not_remove_opt_link
    @keg.link
    @keg.unlink
    assert_predicate @keg, :optlinked?
  end

  def test_existing_opt_link
    @keg.opt_record.make_relative_symlink Pathname.new(@keg)
    @keg.optlink
    assert_predicate @keg, :optlinked?
  end

  def test_existing_opt_link_directory
    @keg.opt_record.mkpath
    @keg.optlink
    assert_predicate @keg, :optlinked?
  end

  def test_existing_opt_link_file
    @keg.opt_record.parent.mkpath
    @keg.opt_record.write("foo")
    @keg.optlink
    assert_predicate @keg, :optlinked?
  end

  def test_linked_keg
    refute_predicate @keg, :linked?
    @keg.link
    assert_predicate @keg, :linked?
    @keg.unlink
    refute_predicate @keg, :linked?
  end
end
