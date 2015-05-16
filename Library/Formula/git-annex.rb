require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150205/git-annex-5.20150205.tar.gz"
  sha1 "5df6114cb029531e429e2b423f5ae7f755ffa390"

  bottle do
    cellar :any
    sha1 "fa9fa816e728479b6d4b3e058a6ea3544db4acc2" => :yosemite
    sha1 "be634c33bc9f4aa337404e0f5cf78ec989b45e3b" => :mavericks
    sha1 "bf687c017b26ac5694e466afd8fe996c7ea2c22b" => :mountain_lion
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
  depends_on "quvi"

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "c2hs"
      # gcc required to build gnuidn
      gcc = Formula["gcc"]
      cabal_install "--with-gcc=#{gcc.bin}/gcc-#{gcc.version_suffix}",
                    "--only-dependencies",
                    "--constraint=utf8-string==0.3.8" # use older utf8-string until 'feed' is updated
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
