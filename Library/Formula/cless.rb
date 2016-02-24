require "language/haskell"

class Cless < Formula
  include Language::Haskell::Cabal

  desc "Display file contents with colorized syntax highlighting"
  homepage "https://github.com/tanakh/cless"
  url "https://github.com/tanakh/cless/archive/0.3.0.0.tar.gz"
  sha256 "382ad9b2ce6bf216bf2da1b9cadd9a7561526bfbab418c933b646d03e56833b2"
  revision 1

  # fix compilation with GHC 7.10
  # to be removed once https://github.com/tanakh/cless/pull/2 is merged
  patch :DATA

  bottle do
    sha256 "69b6e6441633e58e2c48483b2bf6122daed6d1dfe3d7ce31525024dc0ce2d4d6" => :el_capitan
    sha256 "49b15946ec65f85e5b94333485ba8a8eee1b7ec6d2f53c4619d894c9aaf3e6a8" => :yosemite
    sha256 "aaa095676d987a4cdfb613ddf4be28fd8ae1eaf4788f85b045fa5711cfecdffb" => :mavericks
    sha256 "8dcb4a2e9c72d22ab96eee8f18ce4f63bd5f28dea6ef586de82865c94cb2fd8a" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/cless", "--help"
    system "#{bin}/cless", "--list-langs"
    system "#{bin}/cless", "--list-styles"
  end
end

__END__
diff --git a/cless.cabal b/cless.cabal
index 0e8913d..105a7c9 100644
--- a/cless.cabal
+++ b/cless.cabal
@@ -19,7 +19,7 @@ source-repository head
 executable cless
   main-is:             Main.hs

-  build-depends:       base >=4.7 && <4.8
+  build-depends:       base >=4.7 && <5
                      , highlighting-kate >=0.5
                      , wl-pprint-terminfo >=3.7
                      , wl-pprint-extras
