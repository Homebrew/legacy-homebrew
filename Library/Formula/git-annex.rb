require "formula"
require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "http://hackage.haskell.org/package/git-annex-5.20140613/git-annex-5.20140613.tar.gz"
  sha1 "45a889114f4687553abffb48b0603c863e1ce816"

  bottle do
    cellar :any
    sha1 "b26da4d239a3bb3cb7f09b34f9272f74d7098cce" => :mavericks
    sha1 "16a56854088be3e0c82463f04d3738dfd24fe458" => :mountain_lion
    sha1 "444f4575cbfa462c737a260cbad9a4ce57d4d77e" => :lion
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
    bin.install_symlink 'git-annex' => 'git-annex-shell'
    system "make", "git-annex.1", "git-annex-shell.1", "git-union-merge.1"
    man1.install "git-annex.1", "git-annex-shell.1", "git-union-merge.1"
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
      assert !File.file?("bigfile")
      system "git", "annex", "get", "bigfile"
      assert File.file? "bigfile"
    end
    # make test files writable so homebrew can drop them
    chmod_R 0777, testpath
  end
end
