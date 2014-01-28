require 'formula'

class Libwpd < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'http://downloads.sourceforge.net/libwpd/libwpd-0.9.9.tar.bz2'
  sha1 '74d13c4e5137edc78660059257671b5a1f40224d'

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
