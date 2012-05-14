module Homebrew extend self

  def tap
    if ARGV.empty?
      tapd = HOMEBREW_LIBRARY/"Taps"
      tapd.children.each do |tap|
        puts tap.basename.sub('-', '/') if (tap/'.git').directory?
      end if tapd.directory?
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
    tapped = link_tap_formula(files)
    puts "Tapped #{tapped} formula"
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
    when %r{^#{HOMEBREW_LIBRARY}/Taps/(\w+)-(\w+)/(.+)}
      "#$1/#$2/#{File.basename($3, '.rb')}"
    when %r{^#{HOMEBREW_LIBRARY}/Formula/(.+)}
      "mxcl/master/#{File.basename($1, '.rb')}"
    else
      nil
    end
  end
end
