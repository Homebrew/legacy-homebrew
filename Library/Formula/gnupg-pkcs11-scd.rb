require 'formula'

class GnupgPkcs11Scd < Formula
   homepage 'http://gnupg-pkcs11.sourceforge.net'
   url 'https://github.com/alonbl/gnupg-pkcs11-scd/archive/gnupg-pkcs11-scd-0.7.3.tar.gz'
   sha1 '60a3d523f5e814c89eeff69b12f9d0adb0d63937'

   head 'https://github.com/alonbl/gnupg-pkcs11-scd.git'

   depends_on 'automake' => :build
   depends_on 'libtool' => :build
   depends_on 'pkg-config' => :build
   depends_on 'libgpg-error'
   depends_on 'libassuan'
   depends_on 'libgcrypt'
   depends_on 'pkcs11-helper'

   def install
      # Compatibility with Automake 1.13+
      inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'

      system "autoreconf", "--verbose", "--install", "--force"
      system "./configure", "--disable-dependency-tracking",
                            "--with-libgpg-error-prefix=#{HOMEBREW_PREFIX}",
                            "--with-libassuan-prefix=#{HOMEBREW_PREFIX}",
                            "--with-libgcrypt-prefix=#{HOMEBREW_PREFIX}",
                            "--prefix=#{prefix}"
      system "make install"
   end

   test do
     system "#{bin}/gnupg-pkcs11-scd --help > /dev/null ; [ $? -eq 1 ]"
   end
end
