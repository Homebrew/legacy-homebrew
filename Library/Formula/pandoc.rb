require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13/pandoc-1.13.tar.gz"
  sha1 "de70d27f0357c873da2c59c13f0414736c45791d"

  bottle do
    sha1 "fb93514850f6bb8dfb1c5d0eab8a911dc741fc07" => :mavericks
    sha1 "2db6d096a37d2f06909669a5be38d0b8e3eae035" => :mountain_lion
    sha1 "c1c385ad031503c1540ec515f3a1552e51783569" => :lion
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
