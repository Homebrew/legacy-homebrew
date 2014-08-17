require "formula"

class HaskellPlatform < Formula
  homepage "http://hackage.haskell.org/platform/"
  url "http://lambda.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz"
  sha1 "8669bb5add1826c0523fb130c095fb8bf23a30ce"
  bottle do
    sha1 "87ee98c01e11b63903074285749c284ae50f1b6a" => :mavericks
    sha1 "03b7b5b66c02af03fac4ce5e8d305377997d19da" => :mountain_lion
    sha1 "95d3a37c87a96ba0703dd4f9065661583fa9b902" => :lion
  end

  revision 1

  depends_on "ghc"

  conflicts_with "cabal-install"

  def install
    # libdir doesn't work if passed to configure, needs to be set in the environment
    system "./configure", "--prefix=#{prefix}"
    ENV["EXTRA_CONFIGURE_OPTS"] = "--libdir=#{lib}/ghc"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add cabal binaries to your PATH:
      export PATH=~/.cabal/bin:$PATH

    Run `cabal update` to initialize the package list.

    If you are replacing a previous version of haskell-platform, you may want
    to unregister packages belonging to the old version. You can find broken
    packages using:
      ghc-pkg check --simple-output
    You can uninstall them using:
      ghc-pkg check --simple-output | xargs -n 1 ghc-pkg unregister --force
    EOS
  end
end
