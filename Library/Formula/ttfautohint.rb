require 'formula'

class Ttfautohint < Formula
  homepage 'http://www.freetype.org/ttfautohint'
  url 'https://downloads.sourceforge.net/project/freetype/ttfautohint/0.97/ttfautohint-0.97.tar.gz'
  sha1 '8e11226a9d6d2f8210c752dc97c614d5b753651a'

  depends_on :freetype

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-qt=no"
    system "make install"
  end

  test do
    system "#{bin}/ttfautohint", "-V"
  end
end
