require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150916/git-annex-5.20150916.tar.gz"
  sha256 "b6f00d6894eb50b469b1898d19f2e138666c732e8d003598dce85cd804f8fadd"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "61a1d7d3b6144c27cc9dcf4020dfcb0460df6b4241d389e80dbbc33b235050f9" => :el_capitan
    sha256 "32b077c2ed6cce5a555ca396762f698229860be8bd8b7acc830eb72c59c9e29d" => :yosemite
    sha256 "0cbd8722827c153b5011fdcf0a7ba6c5fb94fbd549e51ad2c2471954d33eaca0" => :mavericks
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
