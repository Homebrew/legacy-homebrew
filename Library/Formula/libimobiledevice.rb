require 'formula'

class Libimobiledevice < Formula
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.1.tar.bz2'
  homepage 'http://www.libimobiledevice.org/'
  md5 'cdc13037e822d9ac2e109536701d153a'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'glib'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'

  def install
    ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-swig"
    system "make install"
  end
end
