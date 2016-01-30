require "testing_env"
require "migrator"
require "testball"
require "formula_resolver"
require "tab"
require "tap"
require "keg"

class Formula
  def set_tap(tap)
    @tap = tap
  end
end

class MigratorErrorsTests < Homebrew::TestCase
  def setup
    @new_f = Testball.new("newname")
    @old_f = Testball.new("oldname")
  end

  # TODO test MigratorDifferentFormulaeError

  def test_no_oldpath
    assert_raises(Migrator::MigratorNoOldpathError) { Migrator.new(@new_f, "oldname") }
  end

  def test_different_taps
    keg = HOMEBREW_CELLAR/"oldname/0.1"
    keg.mkpath
    tab = Tab.empty
    tab.tabfile = HOMEBREW_CELLAR/"oldname/0.1/INSTALL_RECEIPT.json"
    tab.source["tap"] = "Homebrew/homebrew"
    tab.write
    assert_raises(Migrator::MigratorDifferentTapsError) { Migrator.new(@new_f, "oldname") }
  ensure
    keg.parent.rmtree
  end
end

class MigratorTests < Homebrew::TestCase
  include FileUtils

  def setup
    @new_f = Testball.new("newname")
    @old_f = Testball.new("oldname")

    @old_keg_record = HOMEBREW_CELLAR/"oldname/0.1"
    @old_keg_record.join("bin").mkpath
    @new_keg_record = HOMEBREW_CELLAR/"newname/0.1"

    %w[inside bindir].each { |file| touch @old_keg_record.join("bin", file) }

    @old_tab = Tab.empty
    @old_tab.tabfile = HOMEBREW_CELLAR/"oldname/0.1/INSTALL_RECEIPT.json"
    @old_tab.source["path"] = "/oldname"
    @old_tab.write

    @keg = Keg.new(@old_keg_record)
    @keg.link
    @keg.optlink

    @old_pin = HOMEBREW_LIBRARY/"PinnedKegs/oldname"
    @old_pin.make_relative_symlink @old_keg_record

    @migrator = Migrator.new(@new_f, "oldname")

    mkpath HOMEBREW_PREFIX/"bin"
  end

  def teardown
    @old_pin.unlink if @old_pin.symlink?

    if @old_keg_record.parent.symlink?
      @old_keg_record.parent.unlink
    elsif @old_keg_record.directory?
      @keg.unlink
      @keg.uninstall
    end

    if @new_keg_record.directory?
      new_keg = Keg.new(@new_keg_record)
      new_keg.unlink
      new_keg.uninstall
    end

    @old_keg_record.parent.rmtree if @old_keg_record.parent.directory?
    @new_keg_record.parent.rmtree if @new_keg_record.parent.directory?

    rmtree HOMEBREW_PREFIX/"bin"
    rmtree HOMEBREW_PREFIX/"opt" if (HOMEBREW_PREFIX/"opt").directory?
    rmtree HOMEBREW_LIBRARY/"LinkedKegs"
    # What to do with pin?
    @new_f.unpin

    FormulaLock::LOCKDIR.children.each(&:unlink)
  end

  def test_move_cellar
    @keg.unlink
    shutup { @migrator.move_to_new_directory }
    assert_predicate @new_keg_record, :directory?
    assert_predicate @new_keg_record/"bin", :directory?
    assert_predicate @new_keg_record/"bin/inside", :file?
    assert_predicate @new_keg_record/"bin/bindir", :file?
    refute_predicate @old_keg_record, :directory?
    refute_predicate @old_keg_record.parent, :directory?
  end

  # oldname and newname are the same packages and both of them installed
  def test_merge_cellar
    @keg.unlink
    (new_keg_record_not_moved = HOMEBREW_CELLAR.join("newname/0.2")).mkpath
    shutup { @migrator.move_to_new_directory }

    assert_predicate @new_keg_record, :directory?
    assert_predicate @new_keg_record/"bin", :directory?
    assert_predicate @new_keg_record/"bin/inside", :file?
    assert_predicate @new_keg_record/"bin/bindir", :file?
    refute_predicate @old_keg_record, :directory?
    assert_predicate new_keg_record_not_moved, :directory?
    refute_predicate @old_keg_record, :directory?
    refute_predicate @old_keg_record.parent, :directory?
  end

  # test backup after merging the following kegs:
  #   Cellar/oldname/0.0
  #   Cellar/oldname/0.1
  #   Cellar/newname/0.1
  #   Cellar/newname/0.2
  def test_backup_merge_cellar
    (new_keg_record_a = HOMEBREW_CELLAR.join("newname/0.0")).mkpath
    (new_keg_record_b = HOMEBREW_CELLAR.join("newname/0.1")).mkpath
    (new_keg_record_c = HOMEBREW_CELLAR.join("newname/0.2")).mkpath
    touch new_keg_record_a.join("testfile")
    HOMEBREW_CELLAR.join("oldname/0.0/bin").mkpath

    old_cellar_subdirs_upd = @migrator.old_cellar_subdirs + [HOMEBREW_CELLAR.join("oldname/0.0")]

    @migrator.instance_variable_set(:@old_cellar_subdirs, old_cellar_subdirs_upd)
    @migrator.instance_variable_set(:@unique_old_cellar_subdirs, [HOMEBREW_CELLAR.join("oldname/0.0")])

    @old_keg_record.parent.rmtree
    @migrator.backup_oldname_cellar

    assert_predicate @old_keg_record, :directory?
    assert_predicate HOMEBREW_CELLAR.join("oldname/0.0/testfile"), :file?
    assert_predicate new_keg_record_b, :directory?
    refute_predicate new_keg_record_a, :directory?
    refute_predicate HOMEBREW_CELLAR.join("oldname/0.2"), :exist?
  end

  def test_backup_cellar
    @old_keg_record.parent.rmtree
    @new_keg_record.join("bin").mkpath

    @migrator.backup_oldname_cellar

    assert_predicate @old_keg_record, :directory?
    assert_predicate @old_keg_record/"bin", :directory?
  end

  def test_repin
    @new_keg_record.join("bin").mkpath
    expected_relative = @new_keg_record.relative_path_from HOMEBREW_LIBRARY/"PinnedKegs"

    @migrator.repin

    assert_predicate @migrator.new_pin_record, :symlink?
    assert_equal expected_relative, @migrator.new_pin_record.readlink
    refute_predicate @migrator.old_pin_record, :exist?
  end

  def test_repin_newname_pinned
    @new_keg_record.join("bin").mkpath
    @new_f.pin
    expected_relative = @new_keg_record.relative_path_from HOMEBREW_LIBRARY/"PinnedKegs"

    @migrator.repin

    assert_predicate @migrator.new_pin_record, :symlink?
    assert_equal expected_relative, @migrator.new_pin_record.readlink
    refute_predicate @migrator.old_pin_record, :exist?
  end

  def test_unlink_oldname
    assert_equal 1, HOMEBREW_LIBRARY.join("LinkedKegs").children.size
    assert_equal 1, HOMEBREW_PREFIX.join("opt").children.size

    shutup { @migrator.unlink_oldname }

    refute_predicate HOMEBREW_LIBRARY.join("LinkedKegs"), :exist?
    refute_predicate HOMEBREW_LIBRARY.join("bin"), :exist?
  end

  def test_link_newname
    @keg.unlink
    @keg.uninstall
    @new_keg_record.join("bin").mkpath
    %w[inside bindir].each { |file| touch @new_keg_record.join("bin", file) }

    shutup { @migrator.link_newname }

    assert_equal 1, HOMEBREW_LIBRARY.join("LinkedKegs").children.size
    assert_equal 1, HOMEBREW_PREFIX.join("opt").children.size
  end

  def test_link_newname_newname_optlinked
    new_keg_record = HOMEBREW_CELLAR.join("newname/0.2")
    new_keg_record.join("bin").mkpath
    touch new_keg_record.join("bin", "file")
    new_keg = Keg.new(new_keg_record)
    new_keg.optlink

    tab = Tab.empty
    tab.tabfile = new_keg_record.join("INSTALL_RECEIPT.json")
    tab.source["path"] = @new_f.path.to_s
    tab.write

    migrator = Migrator.new(@new_f, "oldname")
    @keg.unlink
    @keg.uninstall

    shutup { migrator.link_newname }

    assert_equal 1, HOMEBREW_LIBRARY.join("LinkedKegs").children.size
    assert_equal 1, HOMEBREW_PREFIX.join("opt").children.size
    assert_equal new_keg_record.realpath, HOMEBREW_PREFIX.join("opt/newname").realpath
  end

  def test_link_oldname_opt
    @new_keg_record.mkpath
    @migrator.link_oldname_opt
    assert_equal @new_keg_record.realpath, (HOMEBREW_PREFIX/"opt/oldname").realpath
  end

  def test_link_oldname_cellar
    @new_keg_record.join("bin").mkpath
    @keg.unlink
    @keg.uninstall
    @migrator.link_oldname_cellar
    assert_equal @new_keg_record.parent.realpath, (HOMEBREW_CELLAR/"oldname").realpath
  end

  def test_update_tabs
    @new_keg_record.join("bin").mkpath
    tab = Tab.empty
    tab.tabfile = HOMEBREW_CELLAR/"newname/0.1/INSTALL_RECEIPT.json"
    tab.source["path"] = "/path/that/must/be/changed/by/update_tabs"
    tab.write
    @migrator.update_tabs
    assert_equal @new_f.path.to_s, Tab.for_keg(@new_keg_record).source["path"]
  end

  def test_migrate
    tab = Tab.empty
    tab.tabfile = HOMEBREW_CELLAR/"oldname/0.1/INSTALL_RECEIPT.json"
    tab.source["path"] = @old_f.path.to_s
    tab.write
    shutup { @migrator.migrate }

    assert_predicate @new_keg_record, :exist?
    assert_predicate @old_keg_record.parent, :symlink?
    refute_predicate HOMEBREW_LIBRARY/"LinkedKegs/oldname", :exist?
    assert_equal @new_keg_record.realpath, (HOMEBREW_LIBRARY/"LinkedKegs/newname").realpath
    assert_equal @new_keg_record.realpath, @old_keg_record.realpath
    assert_equal @new_keg_record.realpath, (HOMEBREW_PREFIX/"opt/oldname").realpath
    assert_equal @new_keg_record.parent.realpath, (HOMEBREW_CELLAR/"oldname").realpath
    assert_equal @new_keg_record.realpath, (HOMEBREW_LIBRARY/"PinnedKegs/newname").realpath
    assert_equal @new_f.path.to_s, Tab.for_keg(@new_keg_record).source["path"]
  end

  # oldname and newname are the same packages and both linked
  # TODO PinnedKegs
  def test_migrate_merge_both_linked
    old_cellar = HOMEBREW_CELLAR.join("oldname")
    new_cellar = HOMEBREW_CELLAR.join("newname")
    new_keg_record = new_cellar.join("0.3")

    old_cellar.join("0.2").mkpath
    new_cellar.join("0.2").mkpath
    new_cellar.join("0.3/bin").mkpath

    (old_cellar.subdirs + new_cellar.subdirs).uniq.each do |subdir|
      tab = Tab.empty
      tab.tabfile = subdir.join("INSTALL_RECEIPT.json")
      tab.source["tap"] = "Homebrew/homebrew"
      tab.source["path"] = if File.basename(subdir.parent) == "oldname"
        @old_f.path.to_s
      else
        @new_f.path.to_s
      end
      tab.write
    end

    new_keg = Keg.new(new_keg_record)
    new_keg.link
    new_keg.optlink

    @new_f.set_tap(CoreFormulaRepository.instance)
    migrator = Migrator.new(@new_f, "oldname")

    shutup { migrator.migrate }

    assert_predicate new_keg_record, :exist?
    assert_equal new_cellar.subdirs.size, 3
    assert_predicate @old_keg_record.parent, :symlink?
    refute_predicate HOMEBREW_LIBRARY/"LinkedKegs/oldname", :exist?
    assert_equal new_keg_record.realpath, (HOMEBREW_LIBRARY/"LinkedKegs/newname").realpath
    assert_equal new_keg_record.realpath, (HOMEBREW_PREFIX/"opt/oldname").realpath
    assert_equal new_keg_record.parent.realpath, (HOMEBREW_CELLAR/"oldname").realpath
    new_cellar.subdirs.each do |subdir|
      assert_equal @new_f.path.to_s, Tab.for_keg(subdir).source["path"]
    end
  end

  def test_unlinik_oldname_opt
    @new_keg_record.mkpath
    old_opt_record = HOMEBREW_PREFIX/"opt/oldname"
    old_opt_record.unlink if old_opt_record.symlink?
    old_opt_record.make_relative_symlink(@new_keg_record)
    @migrator.unlink_oldname_opt
    refute_predicate old_opt_record, :symlink?
  end

  def test_unlink_oldname_cellar
    @new_keg_record.mkpath
    @keg.unlink
    @keg.uninstall
    @old_keg_record.parent.make_relative_symlink(@new_keg_record.parent)
    @migrator.unlink_oldname_cellar
    refute_predicate @old_keg_record.parent, :symlink?
  end

  def test_backup_oldname_cellar
    @new_keg_record.join("bin").mkpath
    @keg.unlink
    @keg.uninstall
    @migrator.backup_oldname_cellar
    refute_predicate @old_keg_record.subdirs, :empty?
  end

  def test_backup_old_tabs
    tab = Tab.empty
    tab.tabfile = HOMEBREW_CELLAR/"oldname/0.1/INSTALL_RECEIPT.json"
    tab.source["path"] = "/should/be/the/same"
    tab.write
    migrator = Migrator.new(@new_f, "oldname")
    tab.tabfile.delete
    migrator.backup_old_tabs
    assert_equal "/should/be/the/same", Tab.for_keg(@old_keg_record).source["path"]
  end

  # Backup tests are divided into three groups: when oldname Cellar is deleted
  # and when it still exists and when it's a symlink

  def check_after_backup
    assert_predicate @old_keg_record.parent, :directory?
    refute_predicate @old_keg_record.parent.subdirs, :empty?
    assert_predicate HOMEBREW_LIBRARY/"LinkedKegs/oldname", :exist?
    assert_predicate HOMEBREW_PREFIX/"opt/oldname", :exist?
    assert_predicate HOMEBREW_LIBRARY/"PinnedKegs/oldname", :symlink?
    assert_predicate @keg, :linked?
  end

  def test_backup_cellar_exist
    @migrator.backup_oldname
    check_after_backup
  end

  def test_backup_cellar_removed
    @new_keg_record.join("bin").mkpath
    @keg.unlink
    @keg.uninstall
    @migrator.backup_oldname
    check_after_backup
  end

  def test_backup_cellar_removed_newname_pinned
    @new_keg_record.join("bin").mkpath
    @new_f.pin
    @keg.unlink
    @keg.uninstall
    @migrator.backup_oldname
    check_after_backup
    assert_predicate HOMEBREW_LIBRARY/"PinnedKegs/newname", :symlink?
  end

  def test_backup_cellar_linked
    @new_keg_record.join("bin").mkpath
    @keg.unlink
    @keg.uninstall
    @old_keg_record.parent.make_relative_symlink(@new_keg_record.parent)
    @migrator.backup_oldname
    check_after_backup
  end
end
