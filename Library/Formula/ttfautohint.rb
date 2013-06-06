require 'formula'

class Ttfautohint < Formula
  homepage 'http://www.freetype.org/ttfautohint'
  url 'http://download.savannah.gnu.org/releases/freetype/ttfautohint-0.95.tar.gz'
  sha1 '5039cf8af38283a2f70b8912a968dd1abde9836a'

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
