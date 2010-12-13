require 'formula'

class Libimobiledevice <Formula
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.0.3.tar.bz2'
  homepage 'http://www.libimobiledevice.org/'
  md5 '68e68b5c2bea3ad99917add839d32cb2'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'usbmuxd'
  depends_on 'libplist'
  depends_on 'gnutls'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--without-swig"
    system "make install"
  end
end
