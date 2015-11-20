require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "http://darcs.net/releases/darcs-2.10.2.tar.gz"
  sha256 "6337d3fac04711fa2ef5813558b409c59166c5599b0c9d68c418d21cdccfb327"

  bottle do
    revision 1
    sha256 "9d74025903200c81265bd5f1e84177d7e484e292c444a9b06cbdc132450026f0" => :el_capitan
    sha256 "9e94fb88352257fb53f31457d6cb39097856c6547a60113142653d23f8d96295" => :yosemite
    sha256 "14e911f97decc70ccf9f83741663f0571f4b1ad5cb907c343480aa115bfe7276" => :mavericks
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
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
