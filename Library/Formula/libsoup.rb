require 'formula'

class Libsoup <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/libsoup/2.4/libsoup-2.4.1.tar.gz'
  homepage 'http://www.gnome.org/'
  md5 'd8deba0b01b7d97e4dc6c435ff427138'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
