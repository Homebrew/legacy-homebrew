require 'formula'

class Gconf <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/GConf/2.22/GConf-2.22.0.tar.gz'
  homepage 'http://projects.gnome.org/gconf/'
  md5 'b9634a0b6f87376b63439160761cc67b'

  depends_on 'orbit2'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
