require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.13.2.1/pandoc-1.13.2.1.tar.gz"
  sha256 "66da6eb690b8de41eccf05620e165630854d74c08cf69dbfb68d0ea84589785f"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha1 "b4d98399c366b63faed06a6184bb2a9d3c7bacf2" => :yosemite
    sha1 "f8c3ba25bc44c7e8da1bf14d1fdeef04e2793926" => :mavericks
    sha1 "592f4c65d534317172ce377a0d4524340e7177a8" => :mountain_lion
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
