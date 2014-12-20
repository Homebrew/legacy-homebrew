require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13.2/pandoc-1.13.2.tar.gz"
  sha1 "20f6e4c8d17748979efd011ef870dbfd1fb6dbb3"

  bottle do
    revision 1
    sha1 "acceca6830120f47cc7b1ee9d05988dadc2b5f99" => :yosemite
    sha1 "5e268465b7024f5241b6a6c88db849b78580d7cf" => :mavericks
    sha1 "ff4aa7be2a28afb3d404c15a17b266bb4ef8f14b" => :mountain_lion
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
