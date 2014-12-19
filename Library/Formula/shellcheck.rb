require "formula"
require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.5.tar.gz"
  sha1 "e2907df9a28b955bde122c4ddf144c6039c0b85d"

  bottle do
    sha1 "487e94b0a1efe6953b4eb8163fbe3431f80f526b" => :yosemite
    sha1 "1aa013ebd2eeb72e61f9cde87e41271abe13511e" => :mavericks
    sha1 "af81f345a1ad58bdf1c7a742a945aba9eb3819ed" => :mountain_lion
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
