HOMEBREW_LIBRARY = HOMEBREW_REPOSITORY/"Library"

module Homebrew extend self

  def tap
    if ARGV.empty?
      (HOMEBREW_LIBRARY/"Taps").children.each do |tap|
        puts tap.basename.sub('-', '/') if (tap/'.git').directory?
      end
    else
      install_tap(*tap_args)
    end
  end

  def install_tap user, repo
    raise "brew install git" unless system "/usr/bin/which -s git"

    tapd = HOMEBREW_LIBRARY/"Taps/#{user}-#{repo}"
    raise "Already tapped!" if tapd.directory?
    abort unless system "git clone https://github.com/#{user}/homebrew-#{repo} #{tapd}"

    cd HOMEBREW_LIBRARY/"Formula"
    tapd.find_formula do |relative_pathname|
      # using the system ln is the only way to get relative symlinks
      system "ln -s ../Taps/#{user}-#{repo}/#{relative_pathname} 2>/dev/null"
      opoo "#{relative_pathname.basename(".rb")} conflicts" unless $?.success?
    end
  end

  private

  def tap_args
    ARGV.first =~ %r{^(\w+)/(homebrew-)?(\w+)$}
    raise "Invalid usage" unless $1 and $3
    [$1, $3]
  end

end
