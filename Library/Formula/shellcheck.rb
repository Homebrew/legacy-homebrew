require "formula"
require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.2.tar.gz"
  sha1 "dd030c63f16e9170eb415176d101bbd2ce66fe00"
  revision 1

  bottle do
    cellar :any
    sha1 "52faa5836a8f4c514c6f4df315397ba6b99ff7e2" => :mavericks
    sha1 "824a0470678e35a069a32cd81776c2f29a2ad84f" => :mountain_lion
    sha1 "73eea51f06e8c17e82c0236961db82798919e8f2" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build
  depends_on "gmp"

  def install
    install_cabal_package
    system "make", "shellcheck.1"
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
    assert `shellcheck -f gcc #{sh}`.include? "Iterate over globs whenever possible"
  end
end
