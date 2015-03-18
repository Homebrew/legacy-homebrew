require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "http://hackage.haskell.org/package/mighttpd2-3.2.4/mighttpd2-3.2.4.tar.gz"
  sha256 "3b99ac25a07b8329f6111611a8fa0278d021323d28a4489d0f3ef4fd79042568"

  bottle do
    sha1 "3bcfd785e9a7d222a12902e962862813593364c5" => :mavericks
    sha1 "cdf75e3f624eb5434e481cd1687adee204fcd8d4" => :mountain_lion
    sha1 "7ed2f8494dd3acc179b63572d2a9df104ee915f8" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
