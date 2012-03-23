require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.37/libsoup-2.37.1.tar.bz2'
  md5 '15c7863568034ca68aa6677de34ab996'

  depends_on 'glib-networking'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-gnome"
    system "make install"
  end
end
