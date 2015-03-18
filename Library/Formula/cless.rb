require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/tanakh/cless"
  url "https://hackage.haskell.org/package/cless-0.2.0.0/cless-0.2.0.0.tar.gz"
  sha256 "d6cbeef102f908109c1434dadf7adfda8adbec0d6de6d2f04db3ff8274460683"

  bottle do
    cellar :any
    sha256 "bddfbbaaafa58c953f4724829c64f84d8f0b3afb1c0e31dae14f6fa45d9a07c3" => :yosemite
    sha256 "1611af00bd755a49e9109a17d847491b455af9333e9d140ddfbf1b4a1bd25ea3" => :mavericks
    sha256 "dee0b7d120b98b0107c8f480bb775e036a3411bb2cc9394a706c0f4ce193c112" => :mountain_lion
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
