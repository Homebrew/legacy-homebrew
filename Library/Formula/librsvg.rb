require 'formula'

class Librsvg <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.32/librsvg-2.32.1.tar.gz'
  homepage 'http://librsvg.sourceforge.net/'
  md5 'd7a242ca43e33e1b63d3073f9d46a6a8'

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
