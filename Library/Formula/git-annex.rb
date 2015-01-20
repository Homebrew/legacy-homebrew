require "formula"
require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150113/git-annex-5.20150113.tar.gz"
  sha1 "b45b285ef4b75ffd4fd0fa7d9795c507e8edbcfb"

  bottle do
    cellar :any
    sha1 "275263122dd03a9a7e3a55c2787879c8b79186ff" => :yosemite
    sha1 "60fd29fafdcb8043336be2080bf974b0b376b945" => :mavericks
    sha1 "82da5ad86e926f382e7817a609b05f8a76be6bcd" => :mountain_lion
  end

  depends_on "gcc" => :build
  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  # wget is workaround for http://git-annex.branchable.com/bugs/Build_fails_when_no_wget_avalible/
  depends_on "wget" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "gmp"

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "c2hs"
      # gcc required to build gnuidn
      gcc = Formula["gcc"]
      cabal_install "--with-gcc=#{gcc.bin}/gcc-#{gcc.version_suffix}",
                    "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
    system "make", "git-annex.1", "git-annex-shell.1", "git-union-merge.1"
    man1.install "git-annex.1", "git-annex-shell.1", "git-union-merge.1"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
