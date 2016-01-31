require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.10.3.tar.gz"
  sha256 "ca00c40d08276f94868c7c1bbc6dbd9b6b41a15c1907c34947aaa51d4dbbf642"

  bottle do
    sha256 "7233b3d0fd8fbae5c3dd6f8229fd2755ce047961c6692eaeeb63064f7184fd29" => :el_capitan
    sha256 "62a0c990b8585130d6c8955d2884ec07030dd1b3c5b0f711126a9dd9b5762d02" => :yosemite
    sha256 "edd6a36b7146e20cf5a6a3bbe70737f6013f855bbb881523bdf460e416d9626a" => :mavericks
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
