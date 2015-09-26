require "tap"
require "descriptions"

module Homebrew
  def tap
    if ARGV.empty?
      puts Tap.names
    elsif ARGV.first == "--repair"
      migrate_taps :force => true
    elsif ARGV.first == "--list-official"
      require "official_taps"
      puts OFFICIAL_TAPS.map { |t| "homebrew/#{t}" }
    elsif ARGV.first == "--list-pinned"
      puts Tap.select(&:pinned?).map(&:name)
    else
      user, repo = tap_args
      clone_target = ARGV.named[1]
      opoo "Already tapped!" unless install_tap(user, repo, clone_target)
    end
  end

  def install_tap(user, repo, clone_target = nil)
    # ensure git is installed
    Utils.ensure_git_installed!

    tap = Tap.new user, repo
    return false if tap.installed?
    ohai "Tapping #{tap}"
    remote = clone_target || "https://github.com/#{tap.user}/homebrew-#{tap.repo}"
    args = %W[clone #{remote} #{tap.path}]
    args << "--depth=1" unless ARGV.include?("--full")

    begin
      safe_system "git", *args
    rescue Interrupt, ErrorDuringExecution
      ignore_interrupts do
        sleep 0.1 # wait for git to cleanup the top directory when interrupt happens.
        tap.path.parent.rmdir_if_possible
      end
      raise
    end

    formula_count = tap.formula_files.size
    puts "Tapped #{formula_count} formula#{plural(formula_count, "e")} (#{tap.path.abv})"
    Descriptions.cache_formulae(tap.formula_names)

    if !clone_target && tap.private?
      puts <<-EOS.undent
        It looks like you tapped a private repository. To avoid entering your
        credentials each time you update, you can use git HTTP credential
        caching or issue the following command:

          cd #{tap.path}
          git remote set-url origin git@github.com:#{tap.user}/homebrew-#{tap.repo}.git
      EOS
    end

    true
  end

  # Migrate tapped formulae from symlink-based to directory-based structure.
  def migrate_taps(options = {})
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    return unless ignore.exist? || options.fetch(:force, false)
    (HOMEBREW_LIBRARY/"Formula").children.each { |c| c.unlink if c.symlink? }
    ignore.unlink if ignore.exist?
  end

  private

  def tap_args(tap_name = ARGV.named.first)
    tap_name =~ HOMEBREW_TAP_ARGS_REGEX
    raise "Invalid tap name" unless $1 && $3
    [$1, $3]
  end
end
