require 'formula'

class Libimobiledevice < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.5.tar.bz2'
  sha1 '1c2ce186787fe661d2ef5a1be170ddbe5f85db77'

  head 'http://cgit.sukimashita.com/libimobiledevice.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'gnutls'
  depends_on 'libgcrypt'

  def install
    ENV.append_to_cflags "-std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make install"
  end
end
