module Homebrew
  def tap
    if ARGV.empty?
      each_tap do |user, repo|
        puts "#{user.basename}/#{repo.basename.sub("homebrew-", "")}" if (repo/".git").directory?
      end
    elsif ARGV.first == "--repair"
      repair_taps
    else
      opoo "Already tapped!" unless install_tap(*tap_args)
    end
  end

  def install_tap user, repo
    # we special case homebrew so users don't have to shift in a terminal
    repouser = if user == "homebrew" then "Homebrew" else user end
    user = "homebrew" if user == "Homebrew"

    # we downcase to avoid case-insensitive filesystem issues
    tapd = HOMEBREW_LIBRARY/"Taps/#{user.downcase}/homebrew-#{repo.downcase}"
    return false if tapd.directory?
    abort unless system "git", "clone", "https://github.com/#{repouser}/homebrew-#{repo}", tapd.to_s

    files = []
    tapd.find_formula { |file| files << file }
    link_tap_formula(files)
    puts "Tapped #{files.length} formula#{plural(files.length, 'e')}"

    if private_tap?(repouser, repo) then puts <<-EOS.undent
      It looks like you tapped a private repository. To avoid entering your
      credentials each time you update, you can use git HTTP credential caching
      or issue the following command:

        cd #{tapd}
        git remote set-url origin git@github.com:#{repouser}/homebrew-#{repo}.git
      EOS
    end

    true
  end

  def link_tap_formula paths
    ignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []
    tapped = 0

    paths.each do |path|
      to = HOMEBREW_LIBRARY.join("Formula", path.basename)

      # Unexpected, but possible, lets proceed as if nothing happened
      to.delete if to.symlink? && to.resolved_path == path

      begin
        to.make_relative_symlink(path)
      rescue SystemCallError
        to = to.resolved_path if to.symlink?
        opoo "Could not tap #{Tty.white}#{tap_ref(path)}#{Tty.reset} over #{Tty.white}#{tap_ref(to)}#{Tty.reset}"
      else
        ignores << path.basename.to_s
        tapped += 1
      end
    end

    HOMEBREW_LIBRARY.join("Formula/.gitignore").atomic_write(ignores.uniq.join("\n"))

    tapped
  end

  def repair_taps
    count = 0
    # prune dead symlinks in Formula
    Dir.glob("#{HOMEBREW_LIBRARY}/Formula/*.rb") do |fn|
      if not File.exist? fn
        File.delete fn
        count += 1
      end
    end
    puts "Pruned #{count} dead formula#{plural(count, 'e')}"

    return unless HOMEBREW_REPOSITORY.join("Library/Taps").exist?

    count = 0
    # check symlinks are all set in each tap
    each_tap do |user, repo|
      files = []
      repo.find_formula { |file| files << file }
      count += link_tap_formula(files)
    end

    puts "Tapped #{count} formula#{plural(count, 'e')}"
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

  def tap_args
    ARGV.first =~ HOMEBREW_TAP_ARGS_REGEX
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

  def tap_ref(path)
    case path.to_s
    when %r{^#{Regexp.escape(HOMEBREW_LIBRARY.to_s)}/Formula}o
      "Homebrew/homebrew/#{path.basename(".rb")}"
    when HOMEBREW_TAP_PATH_REGEX
      "#{$1}/#{$2.sub("homebrew-", "")}/#{path.basename(".rb")}"
    end
  end
end
