require "formula"
require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20141125/git-annex-5.20141125.tar.gz"
  sha1 "45445bfef32f380624cbf415813a1a69010ecb13"

  bottle do
    cellar :any
    sha1 "dc9c4df9d7eb9f33cacc1e26e4df4d63f2d3c105" => :yosemite
    sha1 "18bc46d6db31fc6e55816272d4b9bb392a182ebf" => :mavericks
    sha1 "e0bba76cda3e7940a3645c68290dd54782e4cef4" => :mountain_lion
  end

  depends_on "gcc" => :build
  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
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
