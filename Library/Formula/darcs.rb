require "formula"
require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.8.5.tar.gz"
  sha1 "74dd74896d3334696d24fdd783c69459b91d5c7f"

  bottle do
    cellar :any
    sha1 "a73d24ee0ea59f94f02535eb4505e3cb35aa090c" => :mavericks
    sha1 "8c317286607ebbd8217522422e21b4a01c042b79" => :mountain_lion
    sha1 "a3d88d3493b5f2ea12beb412878a12419ef79327" => :lion
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
      assert (Pathname.pwd/"foo").read.include?  "hello homebrew!"
    end
  end
end
