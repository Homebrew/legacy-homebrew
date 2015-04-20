require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.10.0.tar.gz"
  sha256 "52b3db3f7b64a4306585b96af7b5887f62ba54f6e9c3bdbed9b6a18d97f16b36"

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
      assert (Pathname.pwd/"foo").read.include? "hello homebrew!"
    end
  end
end
