require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150522/git-annex-5.20150522.tar.gz"
  sha256 "77208899616ed973dca26137534533f03636af6314cbdbfdc3e4e51c5efeec6a"

  bottle do
    cellar :any
    sha1 "fa9fa816e728479b6d4b3e058a6ea3544db4acc2" => :yosemite
    sha1 "be634c33bc9f4aa337404e0f5cf78ec989b45e3b" => :mavericks
    sha1 "bf687c017b26ac5694e466afd8fe996c7ea2c22b" => :mountain_lion
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
    cabal_clean_lib
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
