require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.10.3.tar.gz"
  sha256 "ca00c40d08276f94868c7c1bbc6dbd9b6b41a15c1907c34947aaa51d4dbbf642"

  bottle do
    sha256 "a65c9d857fd868ff6768c3076511b6bfe5d11f893b58a3d943ae7b0319db73d3" => :el_capitan
    sha256 "7e76c59e699d4941880fea6986d13d62ceb4d0b60736e54f813f4d79ec4810da" => :yosemite
    sha256 "c7f60a61ab519b61d7ea229e3e67c9d1c75b1c39d49da5b07dfcdf8fe4e11658" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    install_cabal_package
  end

  test do
    mkdir "my_repo" do
      system "darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system "darcs", "add", "foo"
      system "darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system "darcs", "get", "my_repo", "my_repo_clone"
    Dir.chdir "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
