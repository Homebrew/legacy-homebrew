require 'formula'

class Librsvg <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.32/librsvg-2.32.0.tar.gz'
  homepage 'http://librsvg.sourceforge.net/'
  md5 'b84bd1d13b3f6b7e6cfda3ddcb9b4819'

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
