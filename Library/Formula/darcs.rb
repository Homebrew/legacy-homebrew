require "formula"
require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.8.4.tar.gz"
  sha1 "36dde7548a9d73f4688296cac72bcda672542e53"

  bottle do
    cellar :any
    sha1 "c11fb41e7e90e6cb524a09134e6a50acc26695f4" => :mavericks
    sha1 "ddb7948bddf9dca7875ccfb039d93e4a60f03f81" => :mountain_lion
    sha1 "40c45ff6023aba8d0b936004c13d1d2fa20078f1" => :lion
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
