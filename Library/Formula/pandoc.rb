require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.0.3/pandoc-1.15.0.3.tar.gz"
  sha256 "e9759e50263b803a40b339534444ff0bd1371dbe299927d113544d746570dcaf"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "a7470327540c74e9c5e05a7b6b6240faa82e521147439f8bfb3fc100e12b3cfa" => :yosemite
    sha256 "7e803fffac74ac594caf39cdd194983083c2a7eaf3d86b358c9d41b59addcb1a" => :mavericks
    sha256 "09efd70cef2bfdfa2b43dd80abd51faa276ff600703cd16928f06f45fc2eb8d6" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

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
