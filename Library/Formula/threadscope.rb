require "language/haskell"

class Threadscope < Formula
  include Language::Haskell::Cabal

  homepage "https://wiki.haskell.org/ThreadScope"
  url "https://hackage.haskell.org/package/threadscope-0.2.6/threadscope-0.2.6.tar.gz"
  sha256 "ca3b3a8f57315f47f7f6787e5d92ca26c216fb67562192ae37a8cb37dceecc5f"

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on :x11
  depends_on "glib"
  depends_on "cairo"
  depends_on "pango"
  depends_on "gettext"
  depends_on "fontconfig"
  depends_on "gtk+"
  depends_on "freetype"

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy"
      cabal_install "--only-dependencies", "ghc-events"
      cabal_install "--prefix=#{prefix}", "ghc-events"
      cabal_install_tools "gtk2hs-buildtools"
      cabal_install "glib", "gio", "cairo", "pango", "gtk"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "#{bin}/threadscope", "--version"
  end
end
