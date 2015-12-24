require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.0.0.tar.gz"
  sha256 "72f1874fa709b5c6dd3bc281b691064256963019f8c3747dd138baf3dc345fca"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "b7f28fe00752795b45c979f53d01e1bc53e2b7cd276e4f950467062630822bcb" => :el_capitan
    sha256 "138f11fba4ee1ef707680d33846106f182d86d98b7ad0beec57c622c5e171f07" => :yosemite
    sha256 "b4436cdd657f1035585c750ddd270313ae25c66fcaa45e4c9264b03edeb26b07" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
