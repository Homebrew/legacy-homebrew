class ZshLovers < Formula
  desc "Tips, tricks, and examples for zsh"
  homepage "https://grml.org/zsh/#zshlovers"
  url "https://grml.org/zsh/zsh-lovers.1"
  version "0.9.0"
  sha256 "b40802dd83f1f2eded9823776ae90af8e0b91488e97f98b3a0629f8d11953e81"

  bottle :unneeded

  def install
    man1.install "zsh-lovers.1"
  end
end
