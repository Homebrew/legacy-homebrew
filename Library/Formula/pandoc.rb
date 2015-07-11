require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.0.5/pandoc-1.15.0.5.tar.gz"
  sha256 "424aa157ec5189c84fbb193c3403aa17340d53e79cb4d2b5f60614bca799434b"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "5114d7bd4a120905cc1f0448f7481644f9d11777bc81479df41e640a07c00616" => :yosemite
    sha256 "8af66294f92021e34229180d0e3323e027b2181c27de70c1504bafb5b6659698" => :mavericks
    sha256 "d5f32b584d366a51f7c21a854b40d69bab178c16192fb281acbc3e741650417c" => :mountain_lion
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
