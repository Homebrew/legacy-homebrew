require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13.1/pandoc-1.13.1.tar.gz"
  sha1 "8f3df1977cf9daa848640754515b733c13fd934a"

  bottle do
    sha1 "a2caf52195e88b36d0fb16f1b931c5630cc6ea57" => :yosemite
    sha1 "cb797a12020892b2eee7131d448692309b184d99" => :mavericks
    sha1 "0795ad1fdea3a1d47219753ebce5d34f7311ad5b" => :mountain_lion
    sha1 "c9c2e4e7e74b4850bcbba148d8efc6af7da47605" => :lion
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
