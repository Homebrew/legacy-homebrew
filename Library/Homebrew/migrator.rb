require "formula"
require "formula_lock"
require "keg"
require "tab"
require "tap_migrations"

# TODO: reimplement according to new renames sturcture
class Migrator
  class MigrationNeededError < RuntimeError
    def initialize(formula)
      # super <<-EOS.undent
      #   #{formula.oldname} was renamed to #{formula.name} and needs to be migrated.
      #   Please run `brew migrate #{formula.oldname}`
      # EOS
    end
  end

  class MigratorNoOldpathError < RuntimeError
    def initialize(oldname)
      super "#{HOMEBREW_CELLAR/oldname} doesn't exist."
    end
  end

  class MigratorDifferentTapsError < RuntimeError
    def initialize(formula, tap, oldname)
      msg = if tap == "Homebrew/homebrew"
        "Please try to use #{oldname} to refer the formula.\n"
      elsif tap
        "Please try to use fully-qualified #{tap}/#{oldname} to refer the formula.\n"
      end

      super <<-EOS.undent
      #{formula.name} from #{formula.tap} is given, but old name #{oldname} was installed from #{tap ? tap : "path or url"}.

      #{msg}To force migrate use `brew migrate --force #{oldname}`.
      EOS
    end
  end

  class MigratorDifferentFormulaeError < RuntimeError
    def initialize(formula, oldname)
      super <<-EOS.undent
      #{oldname} can't be migrated to #{formula.name} because installed version
      of #{formula.name} is a renamed package with the same name.

      Please, migrate #{formula.name} before migrating #{formula.name} and
      try again.
      EOS
    end
  end

  # instance of new name formula
  attr_reader :formula

  # old name of the formula
  attr_reader :oldname

  # path to oldname's cellar
  attr_reader :old_cellar

  # path to oldname pin
  attr_reader :old_pin_record

  # path to oldname opt
  attr_reader :old_opt_record

  # oldname linked keg
  attr_reader :old_linked_keg

  # path to oldname's linked keg
  attr_reader :old_linked_keg_record

  # tabs from oldname kegs
  attr_reader :old_tabs

  # tap of the old name
  attr_reader :old_tap

  # resolved path to oldname pin
  attr_reader :old_pin_link_record

  # old cellar subdirectories to be able to restore old_cellar if error occurs
  attr_reader :old_cellar_subdirs

  # new name of the formula
  attr_reader :newname

  # path to newname cellar according to new name
  attr_reader :new_cellar

  # path to newname pin
  attr_reader :new_pin_record

  # path to newname keg that will be linked if old_linked_keg isn't nil
  attr_reader :new_linked_keg_record

  attr_reader :new_keg_record

  attr_reader :new_linked_keg

  attr_reader :new_opt_record

  attr_reader :unique_old_cellar_subdirs

  def initialize(formula, oldname)
    @oldname = oldname
    @newname = formula.name

    @formula = formula
    @old_cellar = HOMEBREW_CELLAR.join(oldname)
    raise MigratorNoOldpathError.new(oldname) unless old_cellar.exist?

    @old_cellar_subdirs = old_cellar.subdirs

    @old_tabs = old_cellar.subdirs.map { |d| Tab.for_keg(Keg.new(d)) }
    @old_tap = old_tabs.first.tap

    if !ARGV.force? && !from_same_taps?
      raise MigratorDifferentTapsError.new(formula, old_tap, oldname)
    end

    @new_cellar = HOMEBREW_CELLAR.join(newname)

    @unique_old_cellar_subdirs = []

    old_cellar_subdirs.each do |subdir|
      new_subdir = new_cellar.join(subdir.basename)
      @unique_old_cellar_subdirs << subdir unless new_subdir.exist?
    end

    # check whether new_cellar is an installation of @{formula}
    if new_cellar.exist?
      tap = formula.tap
      if FormulaResolver.new("#{tap}/#{newname}").resolved_name != newname
        raise MigratorDifferentFormulaeError.new(formula, oldname)
      end
    end

    if @old_linked_keg = get_old_linked_keg
      @old_linked_keg_record = old_linked_keg.linked_keg_record if old_linked_keg.linked?
      @old_opt_record = old_linked_keg.opt_record if old_linked_keg.optlinked?
      @new_keg_record = HOMEBREW_CELLAR/"#{newname}/#{File.basename(old_linked_keg)}"
    end

    if new_cellar.exist? && @new_linked_keg = get_new_linked_keg
      @new_linked_keg_record = new_linked_keg.linked_keg_record if new_linked_keg.linked?
      @new_opt_record = old_linked_keg.opt_record if old_linked_keg.optlinked?
      @new_keg_record = HOMEBREW_CELLAR/"#{newname}/#{File.basename(new_linked_keg)}"
    end

    @old_pin_record = HOMEBREW_LIBRARY/"PinnedKegs"/oldname
    @new_pin_record = HOMEBREW_LIBRARY/"PinnedKegs"/newname
    @pinned = old_pin_record.symlink?
    @old_pin_link_record = old_pin_record.readlink if @pinned
  end

  # Fix INSTALL_RECEIPTS for tap-migrated formula.
  def fix_tabs
    old_tabs.each do |tab|
      tab.tap = formula.tap
      tab.write
    end
  end

  def from_same_taps?
    if formula.tap == old_tap
      true
    # Homebrew didn't use to update tabs while performing tap-migrations,
    # so there can be INSTALL_RECEIPT's containing wrong information about
    # tap (tap is Homebrew/homebrew if installed formula migrates to a tap), so
    # we check if there is an entry about oldname migrated to tap and if
    # newname's tap is the same as tap to which oldname migrated, then we
    # can perform migrations and the taps for oldname and newname are the same.
    elsif TAP_MIGRATIONS && (rec = TAP_MIGRATIONS[oldname]) \
        && formula.tap == rec && old_tap == "Homebrew/homebrew"
      fix_tabs
      true
    else
      false
    end
  end

  def get_old_linked_keg
    kegs = old_cellar_subdirs.map { |d| Keg.new(d) }
    kegs.detect(&:linked?) || kegs.detect(&:optlinked?)
  end

  def get_new_linked_keg
    kegs = new_cellar.subdirs.map { |d| Keg.new(d) }
    kegs.detect(&:linked?) || kegs.detect(&:optlinked?)
  end

  def pinned?
    @pinned
  end

  def migrate
    begin
      oh1 "Migrating #{Tty.green}#{oldname}#{Tty.white} to #{Tty.green}#{newname}#{Tty.reset}"
      lock
      unlink_oldname
      move_to_new_directory
      repin
      link_oldname_cellar
      link_oldname_opt
      # TODO update for the case when we merge installations
      link_newname unless old_linked_keg.nil?
      update_tabs
    rescue Interrupt
      ignore_interrupts { backup_oldname }
    rescue Exception => e
      onoe "Error occured while migrating."
      puts e
      puts e.backtrace if ARGV.debug?
      puts "Backuping..."
      ignore_interrupts { backup_oldname }
    ensure
      unlock
    end
  end

  # move everything from Cellar/oldname to Cellar/newname
  def move_to_new_directory
    puts "#{new_cellar.exist? ? "Merging with" : "Moving to"} #{new_cellar}"

    new_cellar.mkpath unless new_cellar.exist?

    unique_old_cellar_subdirs.each do |subdir|
      new_subdir = new_cellar.join(subdir.basename)
      FileUtils.mv(subdir, new_subdir)
    end

    old_cellar.rmtree
  end

  def repin
    if pinned?
      # old_pin_record is a relative symlink and when we try to to read it
      # from <dir> we actually try to find file
      # <dir>/../<...>/../Cellar/name/version.
      # To repin formula we need to update the link thus that it points to
      # the right directory.
      # NOTE: old_pin_record.realpath.sub(oldname, newname) is unacceptable
      # here, because it resolves every symlink for old_pin_record and then
      # substitutes oldname with newname. It breaks things like
      # Pathname#make_relative_symlink, where Pathname#relative_path_from
      # is used to find relative path from source to destination parent and
      # it assumes no symlinks.
      unless (formula.pinned?)
        src_oldname = old_pin_record.dirname.join(old_pin_link_record).expand_path
        new_pin_record.make_relative_symlink(src_oldname.sub(oldname, newname))
      end
      old_pin_record.delete
    end
  end

  def unlink_oldname
    oh1 "Unlinking #{Tty.green}#{oldname}#{Tty.reset}"
    old_cellar.subdirs.each do |d|
      keg = Keg.new(d)
      keg.unlink
    end
  end

  # TODO update for the case when we merge installations
  # oldname was linked or optlinked or both linked and optlinked
  def link_newname
    return if new_linked_keg_record && new_opt_record

    oh1 "Linking #{Tty.green}#{newname}#{Tty.reset}"

    new_keg = Keg.new(new_keg_record)

    # * optlink even if there was no optlink before, but either oldname or
    #   newname was linked
    # * if old_keg wasn't linked then we just optlink a keg unless new_keg is optlinked
    # * if old keg wasn't optlinked and linked then this method can't be called
    if ((formula.keg_only? || !old_linked_keg_record) || new_linked_keg_record) \
        && !new_opt_record
      begin
        new_keg.optlink
      rescue Keg::LinkError => e
        onoe "Failed to create #{formula.opt_prefix}"
        raise
      end
      return
    end

    new_keg.remove_linked_keg_record if new_keg.linked?

    begin
      new_keg.link
    rescue Keg::ConflictError => e
      onoe "Error while executing `brew link` step on #{newname}"
      puts e
      puts
      puts "Possible conflicting files are:"
      mode = OpenStruct.new(:dry_run => true, :overwrite => true)
      new_keg.link(mode)
      raise
    rescue Keg::LinkError => e
      onoe "Error while linking"
      puts e
      puts
      puts "You can try again using:"
      puts "  brew link #{formula.name}"
    rescue Exception => e
      onoe "An unexpected error occurred during linking"
      puts e
      puts e.backtrace if ARGV.debug?
      ignore_interrupts { new_keg.unlink }
      raise
    end
  end

  # Link keg to opt if it was linked before migrating.
  def link_oldname_opt
    if old_opt_record
      old_opt_record.delete if old_opt_record.symlink?
      old_opt_record.make_relative_symlink(new_keg_record)
    end
  end

  # After migtaion every INSTALL_RECEIPT.json has wrong path to the formula
  # so we must update INSTALL_RECEIPTs
  # TODO ? update last_commit
  def update_tabs
    unique_old_cellar_subdirs.each do |d|
      d = d.parent.parent.join("#{newname}/#{d.basename}")
      tab = Tab.for_keg(Keg.new(d))
      tab.source["path"] = formula.path.to_s if tab.source["path"]
      tab.write
    end
  end

  # Remove opt/oldname link if it belongs to newname.
  def unlink_oldname_opt
    return unless old_opt_record
    if old_opt_record.symlink? && old_opt_record.exist? \
        && new_keg_record.exist? \
        && new_keg_record.realpath == old_opt_record.realpath
      old_opt_record.unlink
      old_opt_record.parent.rmdir_if_possible
    end
  end

  # Remove old_cellar if it exists
  def link_oldname_cellar
    old_cellar.delete if old_cellar.symlink? || old_cellar.exist?
    old_cellar.make_relative_symlink(formula.rack)
  end

  # Remove Cellar/oldname link if it belongs to newname.
  def unlink_oldname_cellar
    if (old_cellar.symlink? && !old_cellar.exist?) || (old_cellar.symlink? \
          && formula.rack.exist? && formula.rack.realpath == old_cellar.realpath)
      old_cellar.unlink
    end
  end

  # Backup everything if errors occured while migrating.
  def backup_oldname
    unlink_oldname_opt
    unlink_oldname_cellar
    backup_oldname_cellar
    backup_old_tabs

    if pinned? && !old_pin_record.symlink?
      src_oldname = old_pin_record.dirname.join(old_pin_link_record).expand_path
      old_pin_record.make_relative_symlink(src_oldname)
      new_pin_record.delete unless formula.pinned?
    end

    if new_cellar.exist?
      new_cellar.subdirs.each do |d|
        newname_keg = Keg.new(d)
        newname_keg.unlink
        newname_keg.uninstall
      end
    end

    unless old_linked_keg.nil?
      # The keg used to be linked and when we backup everything we restore
      # Cellar/oldname, the target also gets restored, so we are able to
      # create a keg using its old path
      if old_linked_keg_record
        begin
          old_linked_keg.link
        rescue Keg::LinkError
          old_linked_keg.unlink
          raise
        rescue Keg::AlreadyLinkedError
          old_linked_keg.unlink
          retry
        end
      else
        old_linked_keg.optlink
      end
    end
  end

  def backup_oldname_cellar
    unless old_cellar.exist?
      old_cellar.mkpath

      unique_old_cellar_subdirs.each do |subdir|
        new_subdir = new_cellar.join(subdir.basename)
        FileUtils.mv(new_subdir, subdir)
      end

      (old_cellar_subdirs - unique_old_cellar_subdirs).each do |subdir|
        new_subdir = new_cellar.join(subdir.basename)
        FileUtils.cp_r(new_subdir, subdir)
      end
    end
  end

  def backup_old_tabs
    old_tabs.each(&:write)
  end

  def lock
    @newname_lock = FormulaLock.new newname
    @oldname_lock = FormulaLock.new oldname
    @newname_lock.lock
    @oldname_lock.lock
  end

  def unlock
    @newname_lock.unlock
    @oldname_lock.unlock
  end
end
