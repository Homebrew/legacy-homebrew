require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.0.4/pandoc-1.15.0.4.tar.gz"
  sha256 "5660c534f78f6baeb54a041108efe664452d6fc7da0b4181062a1ed559db07d7"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "a5a85c50479a45b4f239df1ae74d18c3deb77fb8dc580e1a39687af595ac9f56" => :yosemite
    sha256 "6c3dbb79f141f082bbffae47d835ab620711912a6b3c51130db055e3c3acd9c3" => :mavericks
    sha256 "4d336eb06cc8750974997b433be4262874aadbb170824021e1791eb226762e5e" => :mountain_lion
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
