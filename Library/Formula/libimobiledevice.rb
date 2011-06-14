require 'formula'

class Libimobiledevice < Formula
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.0.6.tar.bz2'
  homepage 'http://www.libimobiledevice.org/'
  md5 'bd5cdff5212060ee299481360f67fa24'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'usbmuxd'
  depends_on 'libplist'
  depends_on 'gnutls'
  depends_on 'glib'

  def install
    ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--without-swig"
    system "make install"
  end
end
