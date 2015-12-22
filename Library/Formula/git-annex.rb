require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20151218/git-annex-5.20151218.tar.gz"
  sha256 "d8aed73cbc1d1eefcbe6de7790c83f1d6458b4ac1e910d9a34b22782d16142ca"
  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "61cfad528a34d70d26273ee822e9767da1c53595a8a13eb0bf2590960c5ddb56" => :el_capitan
    sha256 "0886b9cb09ffcfe21ed10aa8e2a9176551b657407c2896a77edb3a623d93fe84" => :yosemite
    sha256 "96d1b6703db1c201063c0fa423c6854fe582bdb5167cf0055909bacd212c0f4c" => :mavericks
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
