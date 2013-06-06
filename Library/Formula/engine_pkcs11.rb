require 'formula'

class EnginePkcs11 < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki/OpenSSL-engine-for-PKCS%2311-modules'
  url 'http://sourceforge.net/projects/opensc/files/engine_pkcs11/engine_pkcs11-0.1.8.tar.gz'
  sha1 '25f3c29c7f47da5f2c0bec1534aceec9651cfed3'

  head 'https://github.com/OpenSC/engine_pkcs11.git'

  depends_on 'pkg-config' => :build
  depends_on 'libp11'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
