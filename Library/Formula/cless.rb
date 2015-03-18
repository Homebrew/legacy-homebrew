require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/tanakh/cless"
  url "https://hackage.haskell.org/package/cless-0.2.0.0/cless-0.2.0.0.tar.gz"
  sha256 "d6cbeef102f908109c1434dadf7adfda8adbec0d6de6d2f04db3ff8274460683"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
