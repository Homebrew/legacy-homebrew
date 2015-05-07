require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.7.tar.gz"
  sha256 "9f421052bc07047b65854544bfe32c5503cdad09f00d7a63a2f28b09b03a08f6"

  bottle do
    sha256 "10b7f52f1bd4224ef1bb45faa45e59b3f0b022746a20d90be1e231bfcc5ee4c0" => :yosemite
    sha256 "04b58769d3ec3048f97d3fff1d211e0bb7fe6c461c262c328c8dfeb20a38cb60" => :mavericks
    sha256 "3f741ed31ccbee9bceb405d0e6369971477118a80d60f8f856302676804f30b3" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build
  depends_on "gmp"

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
    assert `shellcheck -f gcc #{sh}`.include? "[SC2045]"
  end
end
