require "testing_env"
require "keg"
require "stringio"

class LinkTests < Homebrew::TestCase
  include FileUtils

  def setup
    keg = HOMEBREW_CELLAR.join("foo", "1.0")
    keg.join("bin").mkpath

    %w[hiworld helloworld goodbye_cruel_world].each do |file|
      touch keg.join("bin", file)
    end

    @keg = Keg.new(keg)
    @dst = HOMEBREW_PREFIX.join("bin", "helloworld")
    @nonexistent = Pathname.new("/some/nonexistent/path")

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

  def test_empty_installation
    %w[.DS_Store INSTALL_RECEIPT.json LICENSE.txt].each do |file|
      touch @keg/file
    end
    assert_predicate @keg, :exist?
    assert_predicate @keg, :directory?
    refute_predicate @keg, :empty_installation?

    (@keg/"bin").rmtree
    assert_predicate @keg, :empty_installation?
  end

  def test_linking_keg
    assert_equal 3, @keg.link
    (HOMEBREW_PREFIX/"bin").children.each { |c| assert_predicate c.readlink, :relative? }
  end

  def test_unlinking_keg
    @keg.link
    assert_predicate @dst, :symlink?
    assert_equal 4, @keg.unlink
    refute_predicate @dst, :symlink?
  end

  def test_oldname_opt_record
    assert_nil @keg.oldname_opt_record
    oldname_opt_record = HOMEBREW_PREFIX/"opt/oldfoo"
    oldname_opt_record.make_relative_symlink(HOMEBREW_CELLAR/"foo/1.0")
    assert_equal oldname_opt_record, @keg.oldname_opt_record
  end

  def test_optlink_relink
    oldname_opt_record = HOMEBREW_PREFIX/"opt/oldfoo"
    oldname_opt_record.make_relative_symlink(HOMEBREW_CELLAR/"foo/1.0")
    keg_record = HOMEBREW_CELLAR.join("foo", "2.0")
    keg_record.join("bin").mkpath
    keg = Keg.new(keg_record)
    keg.optlink
    assert_equal keg_record, oldname_opt_record.resolved_path
    keg.uninstall
    refute_predicate oldname_opt_record, :symlink?
  end

  def test_remove_oldname_opt_record
    oldname_opt_record = HOMEBREW_PREFIX/"opt/oldfoo"
    oldname_opt_record.make_relative_symlink(HOMEBREW_CELLAR/"foo/2.0")
    @keg.remove_oldname_opt_record
    assert_predicate oldname_opt_record, :symlink?
    oldname_opt_record.unlink
    oldname_opt_record.make_relative_symlink(HOMEBREW_CELLAR/"foo/1.0")
    @keg.remove_oldname_opt_record
    refute_predicate oldname_opt_record, :symlink?
  end

  def test_link_dry_run
    @mode.dry_run = true

    assert_equal 0, @keg.link(@mode)
    refute_predicate @keg, :linked?

    ["hiworld", "helloworld", "goodbye_cruel_world"].each do |file|
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
    @dst.make_symlink(@nonexistent)
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
    @dst.make_symlink "nowhere"
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

  def test_unlink_preserves_broken_symlink_pointing_outside_the_keg
    @keg.link
    @dst.delete
    @dst.make_symlink(@nonexistent)
    @keg.unlink
    assert_predicate @dst, :symlink?
  end

  def test_unlink_preserves_broken_symlink_pointing_into_the_keg
    @keg.link
    @dst.resolved_path.delete
    @keg.unlink
    assert_predicate @dst, :symlink?
  end

  def test_unlink_preserves_symlink_pointing_outside_of_keg
    @keg.link
    @dst.delete
    @dst.make_symlink(Pathname.new("/bin/sh"))
    @keg.unlink
    assert_predicate @dst, :symlink?
  end

  def test_unlink_preserves_real_file
    @keg.link
    @dst.delete
    touch @dst
    @keg.unlink
    assert_predicate @dst, :file?
  end

  def test_unlink_ignores_nonexistent_file
    @keg.link
    @dst.delete
    assert_equal 3, @keg.unlink
  end

  def test_pkgconfig_is_mkpathed
    link = HOMEBREW_PREFIX.join("lib", "pkgconfig")
    @keg.join("lib", "pkgconfig").mkpath
    @keg.link
    assert_predicate link.lstat, :directory?
  end

  def test_cmake_is_mkpathed
    link = HOMEBREW_PREFIX.join("lib", "cmake")
    @keg.join("lib", "cmake").mkpath
    @keg.link
    assert_predicate link.lstat, :directory?
  end

  def test_symlinks_are_linked_directly
    link = HOMEBREW_PREFIX.join("lib", "pkgconfig")

    @keg.join("lib", "example").mkpath
    @keg.join("lib", "pkgconfig").make_symlink "example"
    @keg.link

    assert_predicate link.resolved_path, :symlink?
    assert_predicate link.lstat, :symlink?
  end

  def test_links_to_symlinks_are_not_removed
    a = HOMEBREW_CELLAR.join("a", "1.0")
    b = HOMEBREW_CELLAR.join("b", "1.0")

    a.join("lib", "example").mkpath
    a.join("lib", "example2").make_symlink "example"
    b.join("lib", "example2").mkpath

    a = Keg.new(a)
    b = Keg.new(b)
    a.link

    lib = HOMEBREW_PREFIX.join("lib")
    assert_equal 2, lib.children.length
    assert_raises(Keg::ConflictError) { b.link }
    assert_equal 2, lib.children.length
  ensure
    a.unlink
    a.uninstall
    b.uninstall
  end

  def test_removes_broken_symlinks_that_conflict_with_directories
    a = HOMEBREW_CELLAR.join("a", "1.0")
    a.join("lib", "foo").mkpath

    keg = Keg.new(a)

    link = HOMEBREW_PREFIX.join("lib", "foo")
    link.parent.mkpath
    link.make_symlink(@nonexistent)

    keg.link
  ensure
    keg.unlink
    keg.uninstall
  end
end
