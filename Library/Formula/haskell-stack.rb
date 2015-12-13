require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://hackage.haskell.org/package/stack-0.1.10.1/stack-0.1.10.1.tar.gz"
  sha256 "03d3f1cd03cbb70364f013aa6ccaefa07397a76984bc8b7ce51376e0bdc51a7c"

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
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
