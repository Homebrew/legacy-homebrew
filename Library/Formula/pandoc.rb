require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13.2/pandoc-1.13.2.tar.gz"
  sha1 "20f6e4c8d17748979efd011ef870dbfd1fb6dbb3"

  bottle do
    sha1 "b4d98399c366b63faed06a6184bb2a9d3c7bacf2" => :yosemite
    sha1 "f8c3ba25bc44c7e8da1bf14d1fdeef04e2793926" => :mavericks
    sha1 "592f4c65d534317172ce377a0d4524340e7177a8" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", "output.html", prefix/"README"
    assert (Pathname.pwd/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
