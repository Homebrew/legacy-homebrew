module Homebrew extend self

  def tap
    if ARGV.empty?
      tapd = HOMEBREW_LIBRARY/"Taps"
      tapd.children.each do |user|
        next unless user.directory?
        user.children.each do |repo|
          puts "#{user.basename}/#{repo.basename.sub("homebrew-", "")}" if (repo/".git").directory?
        end
      end if tapd.directory?
    elsif ARGV.first == "--repair"
      repair_taps
    else
      opoo "Already tapped!" unless install_tap(*tap_args)
    end
  end

  def install_tap user, repo
    raise "brew install git" unless which 'git'

    # we special case homebrew so users don't have to shift in a terminal
    repouser = if user == "homebrew" then "Homebrew" else user end
    user = "homebrew" if user == "Homebrew"

    # we downcase to avoid case-insensitive filesystem issues
    tapd = HOMEBREW_LIBRARY/"Taps/#{user.downcase}/homebrew-#{repo.downcase}"
    return false if tapd.directory?
    abort unless system "git clone https://github.com/#{repouser}/homebrew-#{repo} #{tapd}"

    files = []
    tapd.find_formula{ |file| files << tapd.dirname.basename.join(tapd.basename, file) }
    link_tap_formula(files)
    puts "Tapped #{files.length} formula"

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

  def link_tap_formula formulae
    ignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []
    tapped = 0

    formulae.each do |formula|
      from = HOMEBREW_LIBRARY.join("Taps/#{formula}")
      to = HOMEBREW_LIBRARY.join("Formula/#{formula.basename}")

      # Unexpected, but possible, lets proceed as if nothing happened
      to.delete if to.symlink? and to.realpath == from

      begin
        to.make_relative_symlink(from)
      rescue SystemCallError
        to = to.realpath if to.exist?
        opoo "Could not tap #{Tty.white}#{tap_ref(from)}#{Tty.reset} over #{Tty.white}#{tap_ref(to)}#{Tty.reset}"
      else
        ignores << formula.basename.to_s
        tapped += 1
      end
    end

    HOMEBREW_LIBRARY.join("Formula/.gitignore").atomic_write(ignores.uniq.join("\n"))

    tapped
  end

  def repair_taps
    count = 0
    # prune dead symlinks in Formula
    Dir["#{HOMEBREW_LIBRARY}/Formula/*.rb"].each do |fn|
      if not File.exist? fn
        File.delete fn
        count += 1
      end
    end
    puts "Pruned #{count} dead formula"

    return unless HOMEBREW_REPOSITORY.join("Library/Taps").exist?

    count = 0
    # check symlinks are all set in each tap
    HOMEBREW_REPOSITORY.join("Library/Taps").children.each do |user|
      next unless user.directory?
      user.children.each do |repo|
        files = []
        repo.find_formula{ |file| files << user.basename.join(repo.basename, file) } if repo.directory?
        count += link_tap_formula(files)
      end
    end

    puts "Tapped #{count} formula"
  end

  private

  def tap_args
    ARGV.first =~ %r{^([\w_-]+)/(homebrew-)?([\w_-]+)$}
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
    when %r{^#{HOMEBREW_LIBRARY}/Taps/([\w_-]+)/([\w_-]+)/(.+)}
      "#$1/#$2/#{File.basename($3, '.rb')}"
    when %r{^#{HOMEBREW_LIBRARY}/Formula/(.+)}
      "Homebrew/homebrew/#{File.basename($1, '.rb')}"
    else
      nil
    end
  end
end
