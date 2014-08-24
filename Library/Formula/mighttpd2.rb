require "formula"
require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  homepage "http://mew.org/~kazu/proj/mighttpd/en/"
  url "http://hackage.haskell.org/package/mighttpd2-3.2.0/mighttpd2-3.2.0.tar.gz"
  sha1 "878a9e03ad3a62221dab22cb6412ae446368e1bd"

  bottle do
    sha1 "3bcfd785e9a7d222a12902e962862813593364c5" => :mavericks
    sha1 "cdf75e3f624eb5434e481cd1687adee204fcd8d4" => :mountain_lion
    sha1 "7ed2f8494dd3acc179b63572d2a9df104ee915f8" => :lion
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
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
