require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/tanakh/cless"
  url "https://hackage.haskell.org/package/cless-0.3.0.0/cless-0.3.0.0.tar.gz"
  sha256 "0f06437973de1c36c1ac2472091a69c2684db40ba12f881592f1f08e8584629b"

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
