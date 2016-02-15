require "cmd/tap"
require "formula_versions"
require "migrator"
require "formulary"
require "descriptions"

module Homebrew
  def update_report
    # migrate to new directories based tap structure
    migrate_taps

    report = Report.new
    master_updater = Reporter.new(HOMEBREW_REPOSITORY)
    master_updated = master_updater.updated?
    if master_updated
      initial_short = shorten_revision(master_updater.initial_revision)
      current_short = shorten_revision(master_updater.current_revision)
      puts "Updated Homebrew from #{initial_short} to #{current_short}."
    end
    report.update(master_updater.report)

    updated_taps = []
    Tap.each do |tap|
      next unless tap.git?
      tap.path.cd do
        updater = Reporter.new(tap.path)
        updated_taps << tap.name if updater.updated?
        report.update(updater.report) do |_key, oldval, newval|
          oldval.concat(newval)
        end
      end
    end
    unless updated_taps.empty?
      puts "Updated #{updated_taps.size} tap#{plural(updated_taps.size)} " \
           "(#{updated_taps.join(", ")})."
    end

    if !master_updated && updated_taps.empty? && !ARGV.verbose?
      puts "Already up-to-date."
    end

    Tap.clear_cache
    Tap.each(&:link_manpages)

    # automatically tap any migrated formulae's new tap
    report.select_formula(:D).each do |f|
      next unless (dir = HOMEBREW_CELLAR/f).exist?
      migration = TAP_MIGRATIONS[f]
      next unless migration
      tap = Tap.fetch(*migration.split("/"))
      tap.install unless tap.installed?

      # update tap for each Tab
      tabs = dir.subdirs.map { |d| Tab.for_keg(Keg.new(d)) }
      next if tabs.first.source["tap"] != "Homebrew/homebrew"
      tabs.each { |tab| tab.source["tap"] = "#{tap.user}/homebrew-#{tap.repo}" }
      tabs.each(&:write)
    end if load_tap_migrations

    load_formula_renames
    report.update_renamed

    # Migrate installed renamed formulae from core and taps.
    report.select_formula(:R).each do |oldname, newname|
      if oldname.include?("/")
        user, repo, oldname = oldname.split("/", 3)
        newname = newname.split("/", 3).last
      else
        user = "homebrew"
        repo = "homebrew"
      end

      next unless (dir = HOMEBREW_CELLAR/oldname).directory? && !dir.subdirs.empty?

      begin
        f = Formulary.factory("#{user}/#{repo}/#{newname}")
      # short term fix to prevent situation like https://github.com/Homebrew/homebrew/issues/45616
      rescue Exception
      end

      next unless f

      begin
        migrator = Migrator.new(f)
        migrator.migrate
      rescue Migrator::MigratorDifferentTapsError
      end
    end

    if report.empty?
      puts "No changes to formulae." if master_updated || !updated_taps.empty?
    else
      report.dump
    end
    Descriptions.update_cache(report)
  end

  private

  def shorten_revision(revision)
    `git rev-parse --short #{revision}`.chomp
  end

  def load_tap_migrations
    load "tap_migrations.rb"
  rescue LoadError
    false
  end

  def load_formula_renames
    load "formula_renames.rb"
  rescue LoadError
    false
  end
end

class Reporter
  attr_reader :initial_revision, :current_revision, :repository

  def self.repository_variable(repository)
    if repository == HOMEBREW_REPOSITORY
      ""
    else
      repository.to_s.
        strip_prefix(Tap::TAP_DIRECTORY.to_s).
        tr("^A-Za-z0-9", "_").
        upcase
    end
  end

  def initialize(repository)
    @repository = repository

    repo_var = Reporter.repository_variable(@repository)
    initial_revision_var = "HOMEBREW_UPDATE_BEFORE#{repo_var}"
    @initial_revision = ENV[initial_revision_var].to_s
    if @initial_revision.empty?
      raise "#{initial_revision_var} is unset!" if ARGV.homebrew_developer?
      raise "update-report should not be called directly!"
    end

    current_revision_var = "HOMEBREW_UPDATE_AFTER#{repo_var}"
    @current_revision = ENV[current_revision_var].to_s
    if @current_revision.empty?
      raise "#{current_revision_var} is unset!" if ARGV.homebrew_developer?
      raise "update-report should not be called directly!"
    end
  end

  def report
    map = Hash.new { |h, k| h[k] = [] }

    if initial_revision && initial_revision != current_revision
      wc_revision = read_current_revision

      diff.each_line do |line|
        status, *paths = line.split
        src = paths.first
        dst = paths.last

        next unless File.extname(dst) == ".rb"
        next unless paths.any? { |p| File.dirname(p) == formula_directory }

        case status
        when "A", "D"
          map[status.to_sym] << repository.join(src)
        when "M"
          file = repository.join(src)
          begin
            formula = Formulary.factory(file)
            new_version = if wc_revision == current_revision
              formula.pkg_version
            else
              FormulaVersions.new(formula).formula_at_revision(@current_revision, &:pkg_version)
            end
            old_version = FormulaVersions.new(formula).formula_at_revision(@initial_revision, &:pkg_version)
            next if new_version == old_version
          # short term fix to prevent situation like https://github.com/Homebrew/homebrew/issues/45616
          rescue Exception => e
            onoe e if ARGV.homebrew_developer?
          end
          map[:M] << file
        when /^R\d{0,3}/
          map[:D] << repository.join(src) if File.dirname(src) == formula_directory
          map[:A] << repository.join(dst) if File.dirname(dst) == formula_directory
        end
      end
    end

    map
  end

  def updated?
    initial_revision && initial_revision != current_revision
  end

  private

  def formula_directory
    if repository == HOMEBREW_REPOSITORY
      "Library/Formula"
    elsif repository.join("Formula").directory?
      "Formula"
    elsif repository.join("HomebrewFormula").directory?
      "HomebrewFormula"
    else
      "."
    end
  end

  def read_current_revision
    `git rev-parse -q --verify HEAD`.chomp
  end

  def diff
    Utils.popen_read(
      "git", "diff-tree", "-r", "--name-status", "--diff-filter=AMDR",
      "-M85%", initial_revision, current_revision
    )
  end

  def `(cmd)
    out = super
    unless $?.success?
      $stderr.puts(out) unless out.empty?
      raise ErrorDuringExecution.new(cmd)
    end
    ohai(cmd, out) if ARGV.verbose?
    out
  end
end

class Report
  def initialize
    @hash = {}
  end

  def fetch(*args, &block)
    @hash.fetch(*args, &block)
  end

  def update(*args, &block)
    @hash.update(*args, &block)
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

  def update_renamed
    renamed_formulae = []

    fetch(:D, []).each do |path|
      case path.to_s
      when HOMEBREW_TAP_PATH_REGEX
        oldname = path.basename(".rb").to_s
        next unless newname = Tap.fetch($1, $2).formula_renames[oldname]
      else
        oldname = path.basename(".rb").to_s
        next unless newname = CoreFormulaRepository.instance.formula_renames[oldname]
      end

      if fetch(:A, []).include?(newpath = path.dirname.join("#{newname}.rb"))
        renamed_formulae << [path, newpath]
      end
    end

    unless renamed_formulae.empty?
      @hash[:A] -= renamed_formulae.map(&:last) if @hash[:A]
      @hash[:D] -= renamed_formulae.map(&:first) if @hash[:D]
      @hash[:R] = renamed_formulae
    end
  end

  def select_formula(key)
    fetch(key, []).map do |path, newpath|
      if path.to_s =~ HOMEBREW_TAP_PATH_REGEX
        tap = Tap.fetch($1, $2)
        if newpath
          ["#{tap}/#{path.basename(".rb")}", "#{tap}/#{newpath.basename(".rb")}"]
        else
          "#{tap}/#{path.basename(".rb")}"
        end
      elsif newpath
        ["#{path.basename(".rb")}", "#{newpath.basename(".rb")}"]
      else
        path.basename(".rb").to_s
      end
    end.sort
  end

  def dump_formula_report(key, title)
    formula = select_formula(key).map do |name, new_name|
      # Format list items of renamed formulae
      if key == :R
        new_name = pretty_installed(new_name) if installed?(name)
        "#{name} -> #{new_name}"
      else
        installed?(name) ? pretty_installed(name) : name
      end
    end

    unless formula.empty?
      # Dump formula list.
      ohai title
      puts_columns(formula)
    end
  end

  def installed?(formula)
    (HOMEBREW_CELLAR/formula.split("/").last).directory?
  end
end
