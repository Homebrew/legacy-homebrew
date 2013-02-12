require 'formula'

class Libwpd < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.6.tar.bz2'
  sha1 '9219cd728f926299cafe8f3292e8be1b439bf35f'

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
