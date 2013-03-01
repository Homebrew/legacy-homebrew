require 'formula'

class Ttfautohint < Formula
  homepage 'http://www.freetype.org/ttfautohint'
  url 'http://download.savannah.gnu.org/releases/freetype/ttfautohint-0.92.tar.gz'
  sha1 'c1d169cae2cf71ca39fe108815844574846113c5'

  depends_on :freetype

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-qt=no"
    system "make install"
  end

  def test
    system "#{bin}/ttfautohint -V"
  end
end
