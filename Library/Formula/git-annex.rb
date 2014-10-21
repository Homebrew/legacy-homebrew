require "formula"
require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "http://hackage.haskell.org/package/git-annex-5.20141013/git-annex-5.20141013.tar.gz"
  sha1 "db93f75db07862ce85bdc14adfdac5aba6104f90"

  bottle do
    cellar :any
    sha1 "9f353c6f66e8db47bd91a3c0fc65599aca50ad50" => :mavericks
    sha1 "264534752e8d2c26e49c84a77571f34fba4fac35" => :mountain_lion
    sha1 "92c21f66c0518b7daf870d230bdf5a6beed80d05" => :lion
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
      assert !File.file?("bigfile")
      system "git", "annex", "get", "bigfile"
      assert File.file? "bigfile"
    end
    # make test files writable so homebrew can drop them
    chmod_R 0777, testpath
  end
end
