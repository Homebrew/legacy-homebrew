require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.0.0.tar.gz"
  sha256 "72f1874fa709b5c6dd3bc281b691064256963019f8c3747dd138baf3dc345fca"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "be5897f86a381bc0dff8c675df60bdc6c35f72cc0ca28126de2f7de0faf6b3c7" => :el_capitan
    sha256 "508d1771fcf677b5f33bc25e65955103556d009fc60c932c16b0f0c4ddea76f3" => :yosemite
    sha256 "19b32eb15c78af9ae9510918767f57480c1f0f2cdb8d2933086c41318efd6c18" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
