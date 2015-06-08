module Homebrew
  def tap
    if ARGV.empty?
      each_tap do |user, repo|
        puts "#{user.basename}/#{repo.basename.sub("homebrew-", "")}" if (repo/".git").directory?
      end
    elsif ARGV.first == "--repair"
      migrate_taps :force => true
    else
      user, repo = tap_args
      clone_target = ARGV.named[1]
      opoo "Already tapped!" unless install_tap(user, repo, clone_target)
    end
  end

  def install_tap user, repo, clone_target=nil
    # we special case homebrew so users don't have to shift in a terminal
    repouser = if user == "homebrew" then "Homebrew" else user end
    user = "homebrew" if user == "Homebrew"

    # we downcase to avoid case-insensitive filesystem issues
    tapd = HOMEBREW_LIBRARY/"Taps/#{user.downcase}/homebrew-#{repo.downcase}"
    return false if tapd.directory?
    ohai "Tapping #{repouser}/#{repo}"
    if clone_target
      args = %W[clone #{clone_target} #{tapd}]
    else
      args = %W[clone https://github.com/#{repouser}/homebrew-#{repo} #{tapd}]
    end
    args << "--depth=1" unless ARGV.include?("--full")
    safe_system "git", *args

    files = []
    tapd.find_formula { |file| files << file }
    puts "Tapped #{files.length} formula#{plural(files.length, 'e')} (#{tapd.abv})"

    if check_private?(clone_target, repouser, repo)
      puts <<-EOS.undent
        It looks like you tapped a private repository. To avoid entering your
        credentials each time you update, you can use git HTTP credential
        caching or issue the following command:

          cd #{tapd}
          git remote set-url origin git@github.com:#{repouser}/homebrew-#{repo}.git
        EOS
    end

    true
  end

  # Migrate tapped formulae from symlink-based to directory-based structure.
  def migrate_taps(options={})
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    return unless ignore.exist? || options.fetch(:force, false)
    (HOMEBREW_LIBRARY/"Formula").children.select(&:symlink?).each(&:unlink)
    ignore.unlink if ignore.exist?
  end

  private

  def each_tap
    taps = HOMEBREW_LIBRARY.join("Taps")

    if taps.directory?
      taps.subdirs.each do |user|
        user.subdirs.each do |repo|
          yield user, repo
        end
      end
    end
  end

  def tap_args(tap_name=ARGV.named.first)
    tap_name =~ HOMEBREW_TAP_ARGS_REGEX
    raise "Invalid tap name" unless $1 && $3
    [$1, $3]
  end

  def private_tap?(user, repo)
    GitHub.private_repo?(user, "homebrew-#{repo}")
  rescue GitHub::HTTPNotFoundError
    true
  rescue GitHub::Error
    false
  end

  def check_private?(clone_target, user, repo)
    !clone_target && private_tap?(user, repo)
  end
end
