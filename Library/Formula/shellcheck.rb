require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.6.tar.gz"
  sha256 "e63314f3d40042897a9ac92f9ca2b0bd263b9d524f8491daf73a25a9e75ebc98"

  bottle do
    sha256 "f1bdb1d529d7c4ebf5a2bbeef321d0a2abb0ff2261974b7f5f16fec1b7791d72" => :yosemite
    sha256 "7e691db07b6f8fc35e9524c1416673f52341ae71d2635898ad9cfafaa3425e3f" => :mavericks
    sha256 "e71a5e5d2df172cabb1d7ae5f5fe5ee44a8ad7eceab44df96c239dcee1f9e099" => :mountain_lion
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
