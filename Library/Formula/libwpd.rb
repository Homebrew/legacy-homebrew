require 'formula'

class Libwpd < Formula
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.2.tar.bz2'
  md5 '8d265a592619166f29c4672ea54812b7'
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
