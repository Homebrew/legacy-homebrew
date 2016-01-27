require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20160126/git-annex-6.20160126.tar.gz"
  sha256 "dc59f670a3d0bdb90db8fc6cadba8003708219bb0dc3d56867a9246d825c0d11"

  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "fc72bb7797ef9255bc4ef2adb0b3a7c671970616975110effcbc3376a34285aa" => :el_capitan
    sha256 "b95279374ca667e4df00832ac98b141f4e2f7a5a4f291376c8c81b9c120f245d" => :yosemite
    sha256 "fbe1d8cdb78da0487a39d207af270756af9c6da102cc70b8dfc76a284c520247" => :mavericks
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
