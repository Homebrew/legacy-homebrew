require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.3.tar.gz"
  sha256 "229a3bd5e38c4da2ce7ddf43c06ca388454e0406f3dbfc44865208b6b334109e"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "daf97f6a1ff883a55039074774c30a049635207d2c9af573c2cacd2d700a09a7" => :el_capitan
    sha256 "a3ba4ae51b06d96ef1275938a0183f7590a437dce5f015011d1a104aaa092274" => :yosemite
    sha256 "62e937dccd8b7f49c3e5f15b49b8fa26f3a71e51ae04af41a6dd5d83721b055e" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<-EOS.undent
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("shellcheck -f gcc #{sh}", 1)
  end
end
