require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.2.10/mighttpd2-3.2.10.tar.gz"
  sha256 "b5d8b8a310598d952f3b4329808ef8211a6a0b224d66fcc18cef4f0a737d25f1"

  bottle do
    sha256 "8afb5d8f59f110843312dda179e3d22117a35cf3655344b6cfd8110323ac9449" => :yosemite
    sha256 "3ea1d214807ca01c3ef08a70f94baef725b7a57daa0bbe750a5adb7535808b97" => :mavericks
    sha256 "e208bc09450183896e38217bf2a8bdc01634d8169454efacc5a03dac57476e77" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
