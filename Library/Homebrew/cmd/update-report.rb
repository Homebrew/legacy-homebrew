require "cmd/tap"
require "formula_versions"
require "migrator"
require "formulary"
require "descriptions"

module Homebrew
  def update_report
    oh1 "Homebrew update report" if ARGV.verbose?

    # migrate to new directories based tap structure
    migrate_taps

    hub = ReporterHub.new

    begin
      master_reporter = Reporter.new(CoreTap.instance)
    rescue Reporter::ReporterRevisionUnsetError => e
      raise e if ARGV.homebrew_developer?
      odie "update-report should not be called directly!"
    end

    if master_reporter.updated?
      initial_short = shorten_revision(master_reporter.initial_revision)
      current_short = shorten_revision(master_reporter.current_revision)
      puts "Updated Homebrew from #{initial_short} to #{current_short}."
      hub.add(master_reporter)
    end

    updated_taps = []
    Tap.each do |tap|
      next unless tap.git?
      begin
        reporter = Reporter.new(tap)
      rescue Reporter::ReporterRevisionUnsetError => e
        onoe e if ARGV.homebrew_developer?
        next
      end
      if reporter.updated?
        updated_taps << tap.name
        hub.add(reporter)
      end
    end
    unless updated_taps.empty?
      puts "Updated #{updated_taps.size} tap#{plural(updated_taps.size)} " \
           "(#{updated_taps.join(", ")})."
    end

    if hub.reporters.empty?
      puts "Already up-to-date."
    elsif hub.empty?
      puts "No changes to formulae."
    else
      hub.dump
      hub.reporters.each(&:migrate_tap_migration)
      hub.reporters.each(&:migrate_formula_rename)
      Descriptions.update_cache(hub)
    end

    Tap.each(&:link_manpages)
  end

  private

  def shorten_revision(revision)
    Utils.popen_read("git", "-C", HOMEBREW_REPOSITORY, "rev-parse", "--short", revision).chomp
  end
end

class Reporter
  class ReporterRevisionUnsetError < RuntimeError
    def initialize(var_name)
      super "#{var_name} is unset!"
    end
  end

  attr_reader :tap, :initial_revision, :current_revision

  def initialize(tap)
    @tap = tap

    initial_revision_var = "HOMEBREW_UPDATE_BEFORE#{repo_var}"
    @initial_revision = ENV[initial_revision_var].to_s
    raise ReporterRevisionUnsetError, initial_revision_var if @initial_revision.empty?

    current_revision_var = "HOMEBREW_UPDATE_AFTER#{repo_var}"
    @current_revision = ENV[current_revision_var].to_s
    raise ReporterRevisionUnsetError, current_revision_var if @current_revision.empty?
  end

  def report
    return @report if @report

    @report = Hash.new { |h, k| h[k] = [] }
    return @report unless updated?

    diff.each_line do |line|
      status, *paths = line.split
      src = Pathname.new paths.first
      dst = Pathname.new paths.last

      next unless dst.extname == ".rb"
      next unless paths.any? { |p| tap.formula_file?(p) }

      case status
      when "A", "D"
        @report[status.to_sym] << tap.formula_file_to_name(src)
      when "M"
        begin
          formula = Formulary.factory(tap.path/src)
          new_version = formula.pkg_version
          old_version = FormulaVersions.new(formula).formula_at_revision(@initial_revision, &:pkg_version)
          next if new_version == old_version
        rescue Exception => e
          onoe e if ARGV.homebrew_developer?
        end
        @report[:M] << tap.formula_file_to_name(src)
      when /^R\d{0,3}/
        @report[:D] << tap.formula_file_to_name(src) if tap.formula_file?(src)
        @report[:A] << tap.formula_file_to_name(dst) if tap.formula_file?(dst)
      end
    end

    renamed_formulae = []
    @report[:D].each do |old_full_name|
      old_name = old_full_name.split("/").last
      new_name = tap.formula_renames[old_name]
      next unless new_name

      if tap.core_tap?
        new_full_name = new_name
      else
        new_full_name = "#{tap}/#{new_name}"
      end

      renamed_formulae << [old_full_name, new_full_name] if @report[:A].include? new_full_name
    end

    unless renamed_formulae.empty?
      @report[:A] -= renamed_formulae.map(&:last)
      @report[:D] -= renamed_formulae.map(&:first)
      @report[:R] = renamed_formulae
    end

    @report
  end

  def updated?
    initial_revision != current_revision
  end

  def migrate_tap_migration
    report[:D].each do |full_name|
      name = full_name.split("/").last
      next unless (dir = HOMEBREW_CELLAR/name).exist? # skip if formula is not installed.
      next unless new_tap_name = tap.tap_migrations[name] # skip if formula is not in tap_migrations list.
      tabs = dir.subdirs.map { |d| Tab.for_keg(Keg.new(d)) }
      next unless tabs.first.tap == tap # skip if installed formula is not from this tap.
      new_tap = Tap.fetch(new_tap_name)
      new_tap.install unless new_tap.installed?
      # update tap for each Tab
      tabs.each { |tab| tab.tap = new_tap }
      tabs.each(&:write)
    end
  end

  def migrate_formula_rename
    report[:R].each do |old_full_name, new_full_name|
      old_name = old_full_name.split("/").last
      next unless (dir = HOMEBREW_CELLAR/old_name).directory? && !dir.subdirs.empty?

      begin
        f = Formulary.factory(new_full_name)
      rescue Exception => e
        onoe e if ARGV.homebrew_developer?
        next
      end

      begin
        migrator = Migrator.new(f)
        migrator.migrate
      rescue Migrator::MigratorDifferentTapsError
      rescue Exception => e
        onoe e
      end
    end
  end

  private

  def repo_var
    @repo_var ||= if tap.path == HOMEBREW_REPOSITORY
      ""
    else
      tap.path.to_s.
        strip_prefix(Tap::TAP_DIRECTORY.to_s).
        tr("^A-Za-z0-9", "_").
        upcase
    end
  end

  def diff
    Utils.popen_read(
      "git", "-C", tap.path, "diff-tree", "-r", "--name-status", "--diff-filter=AMDR",
      "-M85%", initial_revision, current_revision
    )
  end
end

class ReporterHub
  attr_reader :reporters

  def initialize
    @hash = {}
    @reporters = []
  end

  def select_formula(key)
    @hash.fetch(key, [])
  end

  def add(reporter)
    @reporters << reporter
    report = reporter.report.delete_if { |k,v| v.empty? }
    @hash.update(report) { |_key, oldval, newval| oldval.concat(newval) }
  end

  def empty?
    @hash.empty?
  end

  def dump
    # Key Legend: Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)

    dump_formula_report :A, "New Formulae"
    dump_formula_report :M, "Updated Formulae"
    dump_formula_report :R, "Renamed Formulae"
    dump_formula_report :D, "Deleted Formulae"
  end

  private

  def dump_formula_report(key, title)
    formulae = select_formula(key).sort.map do |name, new_name|
      # Format list items of renamed formulae
      if key == :R
        name = pretty_installed(name) if installed?(name)
        new_name = pretty_installed(new_name) if installed?(new_name)
        "#{name} -> #{new_name}"
      else
        installed?(name) ? pretty_installed(name) : name
      end
    end

    unless formulae.empty?
      # Dump formula list.
      ohai title
      puts_columns(formulae)
    end
  end

  def installed?(formula)
    (HOMEBREW_CELLAR/formula.split("/").last).directory?
  end
end
