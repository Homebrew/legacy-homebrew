require 'formula'

class Libwpd < Formula
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.4.tar.bz2'
  sha1 '8562b179863d8cecbe42b5135e9ed2acc98d418b'
  homepage 'http://libwpd.sourceforge.net/'

  depends_on "glib"
  depends_on "libgsf"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"

    # Needs a serialized install
    ENV.deparallelize
    system "make install"
  end
end
