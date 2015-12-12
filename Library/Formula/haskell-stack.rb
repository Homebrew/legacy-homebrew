require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://hackage.haskell.org/package/stack-0.1.10.0/stack-0.1.10.0.tar.gz"
  sha256 "9b730c2b4b7bb87fc70ccbf0bab0e2fe6f0775644b36972b4dea9088cbcab979"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "35d37145f0a51d69b82b9ae1fb59c4bd646ae33e45336bd174cb78903583c3f1" => :el_capitan
    sha256 "e67423e7f33d1a4954197a43680a602e9e1f12ef0ca3c48e0492d8df10e50dd1" => :yosemite
    sha256 "c6a0b29ad6e0287b1ad04d23f8c244585bd6e30e9db6c3b17dfca212d50a790a" => :mavericks
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
