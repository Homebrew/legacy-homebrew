require "cmd/tap"
require "diagnostic"
require "formula_versions"
require "migrator"
require "formulary"
require "descriptions"

module Homebrew
  def update_ruby
    unless ARGV.named.empty?
      abort <<-EOS.undent
        This command updates brew itself, and does not take formula names.
        Use `brew upgrade <formula>`.
      EOS
    end

    # check permissions
    checks = Diagnostic::Checks.new
    %w[
      check_access_usr_local
      check_access_homebrew_repository
    ].each do |check|
      out = checks.send(check)
      odie out unless out.nil?
    end

    # ensure git is installed
    Utils.ensure_git_installed!

    # ensure GIT_CONFIG is unset as we need to operate on .git/config
    ENV.delete("GIT_CONFIG")

    cd HOMEBREW_REPOSITORY
    git_init_if_necessary

    # migrate to new directories based tap structure
    migrate_taps

    report = Report.new
    master_updater = Updater.new(HOMEBREW_REPOSITORY)
    master_updater.pull!
    master_updated = master_updater.updated?
    if master_updated
      initial_short = shorten_revision(master_updater.initial_revision)
      current_short = shorten_revision(master_updater.current_revision)
      puts "Updated Homebrew from #{initial_short} to #{current_short}."
    end
    report.update(master_updater.report)

    # rename Taps directories
    # this procedure will be removed in the future if it seems unnecessasry
    rename_taps_dir_if_necessary

    updated_taps = []
    Tap.each do |tap|
      next unless tap.git?

      tap.path.cd do
        updater = Updater.new(tap.path)

        begin
          updater.pull!
        rescue
          onoe "Failed to update tap: #{tap}"
        else
          updated_taps << tap.name if updater.updated?
          report.update(updater.report) do |_key, oldval, newval|
            oldval.concat(newval)
          end
        end
      end
    end
    unless updated_taps.empty?
      puts "Updated #{updated_taps.size} tap#{plural(updated_taps.size)} " \
           "(#{updated_taps.join(", ")})."
    end
    puts "Already up-to-date." unless master_updated || !updated_taps.empty?

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

  def git_init_if_necessary
    if Dir[".git/*"].empty?
      safe_system "git", "init"
      safe_system "git", "config", "core.autocrlf", "false"
      safe_system "git", "config", "remote.origin.url", "https://github.com/Homebrew/homebrew.git"
      safe_system "git", "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*"
      safe_system "git", "fetch", "origin"
      safe_system "git", "reset", "--hard", "origin/master"
    end

    if `git remote show origin -n` =~ /Fetch URL: \S+mxcl\/homebrew/
      safe_system "git", "remote", "set-url", "origin", "https://github.com/Homebrew/homebrew.git"
      safe_system "git", "remote", "set-url", "--delete", "origin", ".*mxcl\/homebrew.*"
    end
  rescue Exception
    FileUtils.rm_rf ".git"
    raise
  end

  def rename_taps_dir_if_necessary
    Dir.glob("#{HOMEBREW_LIBRARY}/Taps/*/") do |tapd|
      begin
        if File.directory?(tapd + "/.git")
          tapd_basename = File.basename(tapd)
          if tapd_basename.include?("-")
            # only replace the *last* dash: yes, tap filenames suck
            user, repo = tapd_basename.reverse.sub("-", "/").reverse.split("/")

            FileUtils.mkdir_p("#{HOMEBREW_LIBRARY}/Taps/#{user.downcase}")
            FileUtils.mv(tapd, "#{HOMEBREW_LIBRARY}/Taps/#{user.downcase}/homebrew-#{repo.downcase}")

            if tapd_basename.count("-") >= 2
              opoo "Homebrew changed the structure of Taps like <someuser>/<sometap>. "\
                + "So you may need to rename #{HOMEBREW_LIBRARY}/Taps/#{user.downcase}/homebrew-#{repo.downcase} manually."
            end
          else
            opoo "Homebrew changed the structure of Taps like <someuser>/<sometap>. "\
              "#{tapd} is incorrect name format. You may need to rename it like <someuser>/<sometap> manually."
          end
        end
      rescue => ex
        onoe ex.message
        next # next tap directory
      end
    end
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

class Updater
  attr_reader :initial_revision, :current_revision, :repository

  def initialize(repository)
    @repository = repository
    @stashed = false
    @quiet_args = []
    @quiet_args << "--quiet" unless ARGV.verbose?
  end

  def pull!(options = {})
    # The upstream repository's default branch may not be master;
    # check refs/remotes/origin/HEAD to see what the default
    # origin branch name is, and use that. If not set, fall back to "master".
    begin
      @upstream_branch = `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null`
      @upstream_branch = @upstream_branch.chomp.sub('refs/remotes/origin/', '')
    rescue ErrorDuringExecution
      @upstream_branch = "master"
    end

    begin
      @initial_branch = `git symbolic-ref --short HEAD 2>/dev/null`.chomp
    rescue ErrorDuringExecution
      @initial_branch = ""
    end

    unless `git status --untracked-files=all --porcelain 2>/dev/null`.chomp.empty?
      if ARGV.verbose?
        puts "Stashing uncommitted changes to #{repository}."
        system "git", "status", "--short", "--untracked-files=all"
      end
      safe_system "git", "-c", "user.email=brew-update@localhost",
                         "-c", "user.name=brew update",
                         "stash", "save", "--include-untracked", *@quiet_args
      safe_system "git", "reset", "--hard", *@quiet_args
      @stashed = true
    end

    # Used for testing purposes, e.g., for testing formula migration after
    # renaming it in the currently checked-out branch. To test run
    # "brew update --simulate-from-current-branch"
    if ARGV.include?("--simulate-from-current-branch")
      @initial_revision = `git rev-parse -q --verify #{@upstream_branch}`.chomp
      @current_revision = read_current_revision
      begin
        safe_system "git", "merge-base", "--is-ancestor", @initial_revision, @current_revision
      rescue ErrorDuringExecution
        odie "Your HEAD is not a descendant of '#{@upstream_branch}'."
      end
      return
    end

    if @initial_branch != @upstream_branch && !@initial_branch.empty?
      # Recreate and check out `#{upstream_branch}` if unable to fast-forward
      # it to `origin/#{@upstream_branch}`. Otherwise, just check it out.
      if system("git", "merge-base", "--is-ancestor", @upstream_branch, "origin/#{@upstream_branch}")
        safe_system "git", "checkout", "--force", @upstream_branch, *@quiet_args
      else
        safe_system "git", "checkout", "--force", "-B", @upstream_branch, "origin/#{@upstream_branch}", *@quiet_args
      end
    end

    @initial_revision = read_current_revision

    # ensure we don't munge line endings on checkout
    safe_system "git", "config", "core.autocrlf", "false"

    args = ["pull"]
    args << "--ff"
    args << ((ARGV.include? "--rebase") ? "--rebase" : "--no-rebase")
    args += @quiet_args
    args << "origin"
    # the refspec ensures that the default upstream branch gets updated
    args << "refs/heads/#{@upstream_branch}:refs/remotes/origin/#{@upstream_branch}"

    reset_on_interrupt { safe_system "git", *args }

    @current_revision = read_current_revision

    if @initial_branch != @upstream_branch && !@initial_branch.empty?
      safe_system "git", "checkout", @initial_branch, *@quiet_args
      pop_stash
    else
      pop_stash_message
    end
  end

  def pop_stash
    return unless @stashed
    safe_system "git", "stash", "pop", *@quiet_args
    if ARGV.verbose?
      puts "Restoring your stashed changes to #{repository}:"
      system "git", "status", "--short", "--untracked-files"
    end
    @stashed = false
  end

  def pop_stash_message
    return unless @stashed
    puts "To restore the stashed changes to #{repository} run:"
    puts "  `cd #{repository} && git stash pop`"
    @stashed = false
  end

  def reset_on_interrupt
    ignore_interrupts { yield }
  ensure
    if $?.signaled? && $?.termsig == 2 # SIGINT
      safe_system "git", "checkout", @initial_branch unless @initial_branch.empty?
      safe_system "git", "reset", "--hard", @initial_revision, *@quiet_args
      if @initial_branch
        pop_stash
      else
        pop_stash_message
      end
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
