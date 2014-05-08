require "formula"
require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "http://hackage.haskell.org/package/git-annex-5.20140421/git-annex-5.20140421.tar.gz"
  sha1 "f818164eaddf2887a15c0c4c745a1cb8174152dc"

  bottle do
    cellar :any
    sha1 "e5c3a794a3f7dab64af2cab5f098cf01e945f95b" => :mavericks
    sha1 "3600a0a622e9d76bd99d4f50a14e41fb8c77df85" => :mountain_lion
    sha1 "7e73036ef978314ccc28cd25f0e101d728f2e2c1" => :lion
  end

  depends_on "gcc" => :build
  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "gmp"

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "c2hs"
      # gcc required to build gnuidn
      cabal_install "--with-gcc=#{Formula["gcc"].bin}/gcc-4.8", "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    system "make", "git-annex.1", "git-annex-shell.1"
    man1.install "git-annex.1", "git-annex-shell.1"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path 'PATH', bin
    # create a first git repository with an annex
    mkdir "my_annex" do
      system "git", "init"
      system "git", "annex", "init", "my_annex"
      cp bin/"git-annex", "bigfile"
      system "git", "annex", "add", "bigfile"
      system "git", "commit", "-am", "big file added"
      assert File.symlink? "bigfile"
    end
    # and propagate its content to another
    system "git", "clone", "my_annex", "my_annex_clone"
    Dir.chdir "my_annex_clone" do
      assert (not File.file? "bigfile")
      system "git", "annex", "get", "bigfile"
      assert File.file? "bigfile"
    end
    # make test files writable so homebrew can drop them
    chmod_R 0777, testpath
  end
end
