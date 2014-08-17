require "formula"
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/pandoc/"
  url "https://hackage.haskell.org/package/pandoc-1.13/pandoc-1.13.tar.gz"
  sha1 "de70d27f0357c873da2c59c13f0414736c45791d"

  bottle do
    sha1 "6a1935f6111a15573fd660c5a3a899d3611bdcf8" => :mavericks
    sha1 "d21b6e50b5be4d12bf3507c8285da96fa56d951d" => :mountain_lion
    sha1 "5689fdf0685fe3bef2fb512de66b38b0d74ad805" => :lion
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
