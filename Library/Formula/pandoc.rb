require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.13.2.1/pandoc-1.13.2.1.tar.gz"
  sha256 "66da6eb690b8de41eccf05620e165630854d74c08cf69dbfb68d0ea84589785f"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "e9df02321a7129c78dec25d350730cd6e9197d31ef96c800f6462535c9411749" => :yosemite
    sha256 "471cbe82c36664f90d43736c2169048cf2735b21895a6da936cf46620b963444" => :mavericks
    sha256 "0fa5678764cea7319f9f09bca10e2413157f0310ac2067efc9d3d7cd6c02195a" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  fails_with :clang do
    build 425
    cause "clang segfaults on Lion"
  end

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", testpath/"output.html", prefix/"README"
    assert (testpath/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
