class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/"
  url "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/otf2bdf-3.1.tbz2"
  sha256 "3d63892e81187d5192edb96c0dc6efca2e59577f00e461c28503006681aa5a83"

  depends_on "freetype"

  resource "mkinstalldirs" do
    url "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/mkinstalldirs"
    sha256 "e7b13759bd5caac0976facbd1672312fe624dd172bbfd989ffcc5918ab21bfc1"
  end

  def install
    buildpath.install resource("mkinstalldirs")
    chmod 0755, "mkinstalldirs"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match /MacRoman/, shell_output("#{bin}/otf2bdf -et /System/Library/Fonts/LucidaGrande.ttc")
  end
end
