require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150522/git-annex-5.20150522.tar.gz"
  sha256 "77208899616ed973dca26137534533f03636af6314cbdbfdc3e4e51c5efeec6a"

  bottle do
    sha256 "4bae9f9d41e97243371d0adc021922955c353aff37b1b8b2ba247dc16f9d19ce" => :yosemite
    sha256 "796521c204d5da5c2bb149b65bd4685a78798861c4e4da8c7422bfe017e40332" => :mavericks
    sha256 "9421a63dffda734a5ef9f25c51a6bbac8dcead100c6b6c6d166a98151fc7a501" => :mountain_lion
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
    cabal_clean_lib
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
