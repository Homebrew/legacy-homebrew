require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.14.0.4/pandoc-1.14.0.4.tar.gz"
  sha256 "01955bfb1f397ec22bbce10e2df7b4f2214b7289bf79bf51eb7ae0e3b427fadf"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "dda5a71f09d869a7c46bf6b2af39a05e79633f125b564fa431109c198832eab2" => :yosemite
    sha256 "f99e53a35876f07687bcf81e10894a482510f735aa54d2b303edce2c8f170aea" => :mavericks
    sha256 "d4edcf75c228b95e96117731bee0a75158f143ea7f604aeb2d38ff5fbd218297" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", testpath/"output.html", prefix/"README"
    assert (testpath/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
