require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.10.0.tar.gz"
  sha256 "52b3db3f7b64a4306585b96af7b5887f62ba54f6e9c3bdbed9b6a18d97f16b36"

  bottle do
    sha256 "95b48710e4648e22b0eb9cff6ef7088cda52012a0c3d426273368f5b2f1c4885" => :el_capitan
    sha256 "66086e078cdb111cf517313997a29044d8f3c16e45bdcdc06ad438a37d6d0c32" => :yosemite
    sha256 "6c1161e09c005bab52e63faec61610076c3c4393e850229e2117c94a0e78f4d4" => :mavericks
    sha256 "c97c89b0b0d04e067476a807d308ef3ee24296a420d13a0be16b8822b919d8ab" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

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
