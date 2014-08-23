require "formula"
require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  homepage "http://mew.org/~kazu/proj/mighttpd/en/"
  url "http://hackage.haskell.org/package/mighttpd2-3.2.0/mighttpd2-3.2.0.tar.gz"
  sha1 "878a9e03ad3a62221dab22cb6412ae446368e1bd"

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
