require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.0.2.tar.gz"
  sha256 "611e96aab0df2a2ad717cfbfe6018e67a90ecb1fb478c9e3c6d90478125986f0"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "56c7bb47a4a0f3014c734fd65c7b44b060313bfef54a5c06462b56ee000df970" => :el_capitan
    sha256 "ecfa1ad7312544f079496d428fb7c3a16bed77206a218e98bce0ade2fe5ffa9e" => :yosemite
    sha256 "ef597e53f05f99f84309b300ccf573d339cf0809537bcd665c5e980c3ad2f88a" => :mavericks
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
