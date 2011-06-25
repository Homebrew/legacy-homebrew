require 'formula'

class Libwpd < Formula
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.0.tar.bz2'
  md5 '86e390f015e505dd71a66f0123c62f09'
  homepage 'http://libwpd.sourceforge.net/'

  depends_on "glib"
  depends_on "libgsf"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
