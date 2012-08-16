require 'formula'

class Libwpd < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.4.tar.bz2'
  sha1 '8562b179863d8cecbe42b5135e9ed2acc98d418b'

  depends_on "glib"
  depends_on "libgsf"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make install"
  end
end
