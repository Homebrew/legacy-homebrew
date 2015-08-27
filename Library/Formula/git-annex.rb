require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150824/git-annex-5.20150824.tar.gz"
  sha256 "45088dd5ff5a63ca38965e60843e42c1b8424b3437b58af68929cf61ef0819e4"

  bottle do
    sha256 "3ee70b905cb836c18469d48b4e9b4114b07ce084867d776517b081a4676a0427" => :yosemite
    sha256 "570ca4cbc6558ea5cc179827e2813979aeb215513b9bb3815653988a67a80916" => :mavericks
    sha256 "6a953a69d1cdfa8307ce9e9b13521cb17ba0f22da0f1325b226b7bd6d35a57c9" => :mountain_lion
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
