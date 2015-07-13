require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150710/git-annex-5.20150710.tar.gz"
  sha256 "970f953a278401863fb1006679d216891ae556f80434b587deb08dfd6644f860"

  bottle do
    sha256 "74197ec0f3b95a8aab19d6c0f9d21fc4c9ef068c3d7ac723c902c339b1fc7605" => :yosemite
    sha256 "84d94234947600a9dd3a4e92a2f0adfcae14fb0a5ad9f86a7e7ee3d38341b6e4" => :mavericks
    sha256 "da5e7bbc35067ba95ed46475ff8e9b0390b80db8f1effa88086e7fd453ebbb90" => :mountain_lion
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
