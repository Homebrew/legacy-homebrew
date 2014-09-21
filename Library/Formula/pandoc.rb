require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13.1/pandoc-1.13.1.tar.gz"
  sha1 "8f3df1977cf9daa848640754515b733c13fd934a"

  bottle do
    sha1 "14516b086a7728dad03ff9b5a84c336da1947ee8" => :mavericks
    sha1 "bde68b3e353899706868f82f20907b57e4582576" => :mountain_lion
    sha1 "ff8d605afbe6eb914986a9fab729f569dcb35b8e" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

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
