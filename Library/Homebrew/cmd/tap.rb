module Homebrew extend self

  def tap
    if ARGV.empty?
      tapd = HOMEBREW_LIBRARY/"Taps"
      tapd.children.each do |tap|
        # only replace the *last* dash: yes, tap filenames suck
        puts tap.basename.to_s.reverse.sub('-', '/').reverse if (tap/'.git').directory?
      end if tapd.directory?
    elsif ARGV.first == "--repair"
      repair_taps
    else
      install_tap(*tap_args)
    end
  end

  def install_tap user, repo
    raise "brew install git" unless which 'git'

    # we special case homebrew so users don't have to shift in a terminal
    repouser = if user == "homebrew" then "Homebrew" else user end
    user = "homebrew" if user == "Homebrew"

    # we downcase to avoid case-insensitive filesystem issues
    tapd = HOMEBREW_LIBRARY/"Taps/#{user.downcase}-#{repo.downcase}"
    raise "Already tapped!" if tapd.directory?
    abort unless system "git clone https://github.com/#{repouser}/homebrew-#{repo} #{tapd}"

    files = []
    tapd.find_formula{ |file| files << tapd.basename.join(file) }
    link_tap_formula(files)
    puts "Tapped #{files.count} formula"

    # Figure out if this repo is private
    # curl will throw an exception if the repo is private (Github returns a 404)
    begin
      curl('-Ifso', '/dev/null', "https://api.github.com/repos/#{repouser}/homebrew-#{repo}")
    rescue
      puts
      puts "It looks like you tapped a private repository"
      puts "In order to not input your credentials every time"
      puts "you can use git HTTP credential caching or issue the"
      puts "following command:"
      puts
      puts "   cd #{tapd}"
      puts "   git remote set-url origin git@github.com:#{repouser}/homebrew-#{repo}.git"
      puts
    end
  end

  def link_tap_formula formulae
    ignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []
    tapped = 0

    cd HOMEBREW_LIBRARY/"Formula" do
      formulae.each do |formula|
        from = HOMEBREW_LIBRARY.join("Taps/#{formula}")
        to = HOMEBREW_LIBRARY.join("Formula/#{formula.basename}")

        # Unexpected, but possible, lets proceed as if nothing happened
        to.delete if to.symlink? and to.realpath == from

        # using the system ln is the only way to get relative symlinks
        system "ln -s ../Taps/#{formula} 2>/dev/null"
        if $?.success?
          ignores << formula.basename.to_s
          tapped += 1
        else
          to = to.realpath if to.exist?
          opoo "Could not tap #{Tty.white}#{from.tap_ref}#{Tty.reset} over #{Tty.white}#{to.tap_ref}#{Tty.reset}"
        end
      end
    end

    HOMEBREW_LIBRARY.join("Formula/.gitignore").atomic_write(ignores.uniq.join("\n"))

    tapped
  end

  def repair_taps
    count = 0
    # prune dead symlinks in Formula
    Dir["#{HOMEBREW_REPOSITORY}/Library/Formula/*.rb"].each do |fn|
      if not File.exist? fn
        File.delete fn
        count += 1
      end
    end
    puts "Pruned #{count} dead formula"

    count = 0
    # check symlinks are all set in each tap
    HOMEBREW_REPOSITORY.join("Library/Taps").children.each do |tap|
      files = []
      tap.find_formula{ |file| files << tap.basename.join(file) } if tap.directory?
      count += link_tap_formula(files)
    end

    puts "Tapped #{count} formula"
  end

  private

  def tap_args
    ARGV.first =~ %r{^(\S+)/(homebrew-)?(\w+)$}
    raise "Invalid usage" unless $1 and $3
    [$1, $3]
  end

end


class Pathname
  def tap_ref
    case self.to_s
    when %r{^#{HOMEBREW_LIBRARY}/Taps/([a-z\-_]+)-(\w+)/(.+)}
      "#$1/#$2/#{File.basename($3, '.rb')}"
    when %r{^#{HOMEBREW_LIBRARY}/Formula/(.+)}
      "mxcl/master/#{File.basename($1, '.rb')}"
    else
      nil
    end
  end
end
