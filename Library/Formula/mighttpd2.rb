require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  homepage "http://www.mew.org/~kazu/proj/mighttpd/en/"
  url "http://hackage.haskell.org/package/mighttpd2-3.2.7/mighttpd2-3.2.7.tar.gz"
  sha256 "57974d96b4dc5d8414ae61bcc45df4a0f07a855764a3baa57bdd39d0173c2dd0"

  bottle do
    sha256 "221b886d90788df97537c4786a55380c220ddb8ec2bce045fad00276db7f5217" => :yosemite
    sha256 "0bc66b81501ddf5dd0cad73fd1f3aa44515d94dc0f0759bbe703cb5ceb98992d" => :mavericks
    sha256 "949c366d77155dd01228d4f977b9a022a6151c65ab49f10a48c4436989d7d20d" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
