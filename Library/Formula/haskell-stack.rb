require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.0.4.tar.gz"
  sha256 "60df5eaeccd9db7fdb535f056815c9ec196731231d4754d2e294f74bef3f4547"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "3b026b3737caada5e3b04bc28935318d5a048185d04fb7c496d8ed8b5e87c5d8" => :el_capitan
    sha256 "d61702c6861d6ed19008b4145e87206d50fd4a70d2057efb1046a7d48b8c96f3" => :yosemite
    sha256 "9e29d00d2b038887101366a6374bdef88b33d5cb8429a68b73aec5c65643d925" => :mavericks
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
