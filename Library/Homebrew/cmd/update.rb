require 'cmd/tap'
require 'cmd/untap'

module Homebrew
  def update
    unless ARGV.named.empty?
      abort <<-EOS.undent
        This command updates brew itself, and does not take formula names.
        Use `brew upgrade <formula>`.
      EOS
    end
    abort "Please `brew install git' first." unless which "git"

    # ensure GIT_CONFIG is unset as we need to operate on .git/config
    ENV.delete('GIT_CONFIG')

    cd HOMEBREW_REPOSITORY
    git_init_if_necessary

    tapped_formulae = []
    HOMEBREW_LIBRARY.join("Formula").children.each do |path|
      next unless path.symlink?
      tapped_formulae << path.resolved_path
    end
    unlink_tap_formula(tapped_formulae)

    report = Report.new
    master_updater = Updater.new(HOMEBREW_REPOSITORY)
    begin
      master_updater.pull!
    ensure
      link_tap_formula(tapped_formulae)
    end
    report.merge!(master_updater.report)

    # rename Taps directories
    # this procedure will be removed in the future if it seems unnecessasry
    rename_taps_dir_if_necessary

    each_tap do |user, repo|
      repo.cd do
        updater = Updater.new(repo)

        begin
          updater.pull!
        rescue
          onoe "Failed to update tap: #{user.basename}/#{repo.basename.sub("homebrew-", "")}"
        else
          report.merge!(updater.report) do |key, oldval, newval|
            oldval.concat(newval)
          end
        end
      end
    end

    # we unlink first in case the formula has moved to another tap
    Homebrew.unlink_tap_formula(report.removed_tapped_formula)
    Homebrew.link_tap_formula(report.new_tapped_formula)

    # automatically tap any migrated formulae's new tap
    report.select_formula(:D).each do |f|
      next unless (HOMEBREW_CELLAR/f).exist?
      migration = TAP_MIGRATIONS[f]
      next unless migration
      tap_user, tap_repo = migration.split '/'
      install_tap tap_user, tap_repo
    end if load_tap_migrations

    if report.empty?
      puts "Already up-to-date."
    else
      puts "Updated Homebrew from #{master_updater.initial_revision[0,8]} to #{master_updater.current_revision[0,8]}."
      report.dump
    end
  end

  private

  def git_init_if_necessary
    if Dir[".git/*"].empty?
      safe_system "git", "init"
      safe_system "git", "config", "core.autocrlf", "false"
      safe_system "git", "remote", "add", "origin", "https://github.com/Homebrew/homebrew.git"
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
    need_repair_taps = false
    Dir.glob("#{HOMEBREW_LIBRARY}/Taps/*/") do |tapd|
      begin
        tapd_basename = File.basename(tapd)

        if File.directory?(tapd + "/.git")
          if tapd_basename.include?("-")
            # only replace the *last* dash: yes, tap filenames suck
            user, repo = tapd_basename.reverse.sub("-", "/").reverse.split("/")

            FileUtils.mkdir_p("#{HOMEBREW_LIBRARY}/Taps/#{user.downcase}")
            FileUtils.mv(tapd, "#{HOMEBREW_LIBRARY}/Taps/#{user.downcase}/homebrew-#{repo.downcase}")
            need_repair_taps = true

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

    repair_taps if need_repair_taps
  end

  def load_tap_migrations
    require 'tap_migrations'
  rescue LoadError
    false
  end
end

class Updater
  attr_reader :initial_revision, :current_revision, :repository

  def initialize(repository)
    @repository = repository
  end

  def pull!
    safe_system "git", "checkout", "-q", "master"

    @initial_revision = read_current_revision

    # ensure we don't munge line endings on checkout
    safe_system "git", "config", "core.autocrlf", "false"

    args = ["pull"]
    args << "--rebase" if ARGV.include? "--rebase"
    args << "-q" unless ARGV.verbose?
    args << "origin"
    # the refspec ensures that 'origin/master' gets updated
    args << "refs/heads/master:refs/remotes/origin/master"

    reset_on_interrupt { safe_system "git", *args }

    @current_revision = read_current_revision
  end

  def reset_on_interrupt
    ignore_interrupts { yield }
  ensure
    if $?.signaled? && $?.termsig == 2 # SIGINT
      safe_system "git", "reset", "--hard", @initial_revision
    end
  end

  # Matches raw git diff format (see `man git-diff-tree`)
  DIFFTREE_RX = /^:[0-7]{6} [0-7]{6} [0-9a-fA-F]{40} [0-9a-fA-F]{40} ([ACDMRTUX])\d{0,3}\t(.+?)(?:\t(.+))?$/

  def report
    map = Hash.new{ |h,k| h[k] = [] }

    if initial_revision && initial_revision != current_revision
      `git diff-tree -r --raw -M85% #{initial_revision} #{current_revision}`.each_line do |line|
        DIFFTREE_RX.match line
        path = case status = $1.to_sym
          when :R then $3
          else $2
          end
        map[status] << repository.join(path)
      end
    end

    map
  end

  private

  def read_current_revision
    `git rev-parse -q --verify HEAD`.chomp
  end

  def `(cmd)
    out = super
    if $? && !$?.success?
      $stderr.puts out
      raise ErrorDuringExecution, "Failure while executing: #{cmd}"
    end
    ohai(cmd, out) if ARGV.verbose?
    out
  end
end


class Report < Hash

  def dump
    # Key Legend: Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)

    dump_formula_report :A, "New Formulae"
    dump_formula_report :M, "Updated Formulae"
    dump_formula_report :D, "Deleted Formulae"
    dump_formula_report :R, "Renamed Formulae"
#    dump_new_commands
#    dump_deleted_commands
  end

  def tapped_formula_for key
    fetch(key, []).select do |path|
      case path.to_s
      when HOMEBREW_TAP_PATH_REGEX
        valid_formula_location?("#{$1}/#{$2}/#{$3}")
      else
        false
      end
    end.compact
  end

  def valid_formula_location?(relative_path)
    ruby_file = /\A.*\.rb\Z/
    parts = relative_path.split('/')[2..-1]
    [
      parts.length == 1 && parts.first =~ ruby_file,
      parts.length == 2 && parts.first == 'Formula' && parts.last =~ ruby_file,
      parts.length == 2 && parts.first == 'HomebrewFormula' && parts.last =~ ruby_file,
    ].any?
  end

  def new_tapped_formula
    tapped_formula_for :A
  end

  def removed_tapped_formula
    tapped_formula_for :D
  end

  def select_formula key
    fetch(key, []).map do |path|
      case path.to_s
      when Regexp.new(HOMEBREW_LIBRARY + "/Formula")
        path.basename(".rb").to_s
      when HOMEBREW_TAP_PATH_REGEX
        "#$1/#{$2.sub("homebrew-", "")}/#{path.basename(".rb")}"
      end
    end.compact.sort
  end

  def dump_formula_report key, title
    formula = select_formula(key)
    unless formula.empty?
      ohai title
      puts_columns formula.uniq
    end
  end

end
