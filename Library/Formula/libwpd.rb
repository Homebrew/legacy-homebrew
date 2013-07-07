require 'formula'

class Libwpd < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.8.tar.bz2'
  sha1 '7527d7ec01289c1109551cc58537ca4cf7cf8ba6'

  depends_on 'pkg-config' => :build
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
