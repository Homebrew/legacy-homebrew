require 'formula'

class GnupgPkcs11Scd < Formula
  homepage 'http://gnupg-pkcs11.sourceforge.net'
  url 'https://github.com/alonbl/gnupg-pkcs11-scd/archive/gnupg-pkcs11-scd-0.7.3.tar.gz'
  sha1 '60a3d523f5e814c89eeff69b12f9d0adb0d63937'
  revision 1

  head 'https://github.com/alonbl/gnupg-pkcs11-scd.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libgpg-error'
  depends_on 'libassuan'
  depends_on 'libgcrypt'
  depends_on 'pkcs11-helper'

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libassuan-prefix=#{Formula["libassuan"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/gnupg-pkcs11-scd --help > /dev/null ; [ $? -eq 1 ]"
  end
end
