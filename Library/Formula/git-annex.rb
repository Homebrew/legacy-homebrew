require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20151218/git-annex-5.20151218.tar.gz"
  sha256 "d8aed73cbc1d1eefcbe6de7790c83f1d6458b4ac1e910d9a34b22782d16142ca"
  revision 1

  head "git://git-annex.branchable.com/"

  bottle do
    sha256 "58ef006e4281a2568bcecd8fe94f1089b5e24e3aec0c4eac9571c2f229ff33b6" => :el_capitan
    sha256 "86890f5859ff91d808f5525318684216d86520664981df41be87b3e90fa2fa6d" => :yosemite
    sha256 "ad9bb74370d9aba151d60549b27b81c4509de573e5c483a1581c6e8bfe1f08eb" => :mavericks
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
