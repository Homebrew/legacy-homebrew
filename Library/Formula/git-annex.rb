require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20160126/git-annex-6.20160126.tar.gz"
  sha256 "dc59f670a3d0bdb90db8fc6cadba8003708219bb0dc3d56867a9246d825c0d11"

  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "81e4037f30a0e4d087f401c228fe727f47764f9d981cbc56d8f7df2268988ba1" => :el_capitan
    sha256 "dd93fb0a3958e2b757f7465c1c72462057a90995ddf0b4df022625eded820e87" => :yosemite
    sha256 "a1848964b1239644d917d250dbbda42d73100ec5a1b5e69e66e27e0a4f179f61" => :mavericks
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "quvi"

  def install
    install_cabal_package :using => ["alex", "happy", "c2hs"] do
      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
