require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/tanakh/cless"
  url "https://hackage.haskell.org/package/cless-0.3.0.0/cless-0.3.0.0.tar.gz"
  sha256 "0f06437973de1c36c1ac2472091a69c2684db40ba12f881592f1f08e8584629b"

  bottle do
    sha256 "76b8d84196408e6e9a8600cb1a35240e75206db8d006ef8bfe38e7a171bb1b2c" => :yosemite
    sha256 "4027a2a344f157df664b878d74a5912cc75b55ecb8c9f76395ce4c178aa57839" => :mavericks
    sha256 "b370de61dbd0e438f5910ba5d98755b561a08cf151ecdc03c96bc2c2053fd1a5" => :mountain_lion
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
