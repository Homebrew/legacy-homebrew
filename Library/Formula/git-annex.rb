require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150617/git-annex-5.20150617.tar.gz"
  sha256 "2d37c49866880803886fe77be17ac154c84acc0c344e4fefea577a59e55f8d54"

  bottle do
    sha256 "d05ef041e724fb7018b002a60cbd932b69ac0d1c83f1e97b6aae73cc8c56a390" => :yosemite
    sha256 "6d548a77aff5b8381abdf680179c5e133b0e9da576d43d61aa6603b81236147c" => :mavericks
    sha256 "8a7770cb138043f2c060afb2b69f0e64a72c17ea55ac0f994af7a3d0ec7f7b89" => :mountain_lion
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "quvi"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "c2hs"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"

      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end

      system "make", "install-docs", "PREFIX=#{prefix}"
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
    cabal_clean_lib
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
