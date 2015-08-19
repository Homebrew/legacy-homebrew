require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150731/git-annex-5.20150731.tar.gz"
  sha256 "a2eefd4c273f5510e8ee384cc4fb512bf10c76cc4b84f6fff5c255223bd853a1"

  bottle do
    sha256 "92367929618a2ff4d355e1c9f0d6d9dda471577839bd0a56211d692fb76e0363" => :yosemite
    sha256 "af1707f80abb9158f37b9c4795031c3eea40ddab34e7671f9a367db4f77f2202" => :mavericks
    sha256 "21fc5caf99fbaf5d041f5861bb881c3be25d001ae92cf230981109b8e4361d23" => :mountain_lion
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
