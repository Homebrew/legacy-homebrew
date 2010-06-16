require 'formula'

class Libimobiledevice <Formula
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.0.1.tar.bz2'
  homepage 'http://www.libimobiledevice.org/'
  md5 '684edcf0946f5a8db95bfcced7626dbe'

  depends_on 'pkg-config'
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
