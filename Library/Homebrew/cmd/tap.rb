module Homebrew
  def tap
    if ARGV.empty?
      each_tap do |user, repo|
        puts "#{user.basename}/#{repo.basename.sub("homebrew-", "")}" if (repo/".git").directory?
      end
    elsif ARGV.first == "--repair"
      migrate_taps :autoskip => false
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

  def migrate_taps(options={:autoskip => true})
    # migrate taps from symlink based to directories based.
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    if ignore.exist?
      File.delete ignore
    else
      return if options[:autoskip]
    end
    Pathname.glob("#{HOMEBREW_LIBRARY}/Formula/*.rb") do |f|
      next unless f.symlink?
      if f.exist?
        File.delete f if f.resolved_path.to_s.start_with? "#{HOMEBREW_LIBRARY}/Taps"
      else
        File.delete f
      end
    end
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

  def tap_args(tap_name=ARGV.first)
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
end
