require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org"
  url "https://hackage.haskell.org/package/stack-0.1.6.0/stack-0.1.6.0.tar.gz"
  sha256 "a47ffc204b9caef8281d1e5daebc21bc9d4d2414ed695dc10d32fcca4d81978d"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "f88994664bf4e531ad21e357284b6a1de625a89569f052a5610ee03c3834a5b8" => :el_capitan
    sha256 "fe8b28f83bb4fdd65747facd8ff5cebb003f52e0555b589c32d2292289016e30" => :yosemite
    sha256 "18024f16de2ad120501833eac1b2fe13047c9a713c4222584fbbf2bfb76cccd5" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

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
