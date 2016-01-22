class Plenv < Formula
  desc "Perl binary manager"
  homepage "https://github.com/tokuhirom/plenv"
  url "https://github.com/tokuhirom/plenv/archive/2.2.0.tar.gz"
  sha256 "248c5d8196077d217f98d566bd235cbe3332583851737782852bb2fccf840111"
  head "https://github.com/tokuhirom/plenv.git"

  bottle :unneeded

  def install
    prefix.install "bin", "plenv.d", "completions", "libexec"

    # Run rehash after installing.
    system "#{bin}/plenv", "rehash"
  end

  def caveats; <<-EOS.undent
    To enable shims add to your profile:
      if which plenv > /dev/null; then eval "$(plenv init -)"; fi
    With zsh, add to your .zshrc:
      if which plenv > /dev/null; then eval "$(plenv init - zsh)"; fi
    With fish, add to your config.fish
      if plenv > /dev/null; plenv init - | source ; end
    EOS
  end
end
