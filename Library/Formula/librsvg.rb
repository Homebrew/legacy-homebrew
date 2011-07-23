require 'formula'

class Librsvg < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.34/librsvg-2.34.0.tar.gz'
  homepage 'http://librsvg.sourceforge.net/'
  md5 '3bf6472d65e15cd13230f886da88e913'

  depends_on 'gtk+'
  depends_on 'libcroco'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-tools=yes",
                          "--enable-pixbuf-loader=yes"
    system "make install"
  end
end
