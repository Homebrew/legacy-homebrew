require 'formula'

class Gdb < Formula
  url 'ftp://sourceware.org/pub/gdb/releases/gdb-7.3.1.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 'b89a5fac359c618dda97b88645ceab47'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-python"
    system "make"
    system "make install"
  end
  def caveats; <<-EOS
You need to codesign your gdb or run as root:

1) Start Keychain Access application (/Applications/Utilities/Keychain Access.app)

2) Open menu Keychain Access -> Certificate Assistant -> Create a Certificate...

3) Choose a name (gdb-cert), select Code Signing as Certificate Type and also select the Let me override defaults.
   Click several times on continue as the default values are correct.
   Make sure to tore the certificate in the System keychain.

4) Configure the cerificate to be trusted trust this certificate for code signing:
   Using contextual menu Get Info, open the Trust item, and select Always Trust for Code Signing.

5) Back in the terminal:

   codesign -s gdb-cert #{prefix}/bin/gdb
EOS
  end
end
