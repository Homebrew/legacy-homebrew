require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://hackage.haskell.org/package/cless-0.3.0.0/cless-0.3.0.0.tar.gz"
  sha256 "0f06437973de1c36c1ac2472091a69c2684db40ba12f881592f1f08e8584629b"

  revision 1

  bottle do
    sha256 "49b15946ec65f85e5b94333485ba8a8eee1b7ec6d2f53c4619d894c9aaf3e6a8" => :yosemite
    sha256 "aaa095676d987a4cdfb613ddf4be28fd8ae1eaf4788f85b045fa5711cfecdffb" => :mavericks
    sha256 "8dcb4a2e9c72d22ab96eee8f18ce4f63bd5f28dea6ef586de82865c94cb2fd8a" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    # The "--allow-newer" is a hack for GHC 7.10.1, remove when possible.
    install_cabal_package "--allow-newer"
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end
