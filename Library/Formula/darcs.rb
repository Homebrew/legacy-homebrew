require "formula"
require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.8.4.tar.gz"
  sha1 "36dde7548a9d73f4688296cac72bcda672542e53"

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
      assert (Pathname.pwd/"foo").read.include?  "hello homebrew!"
    end
  end
end
