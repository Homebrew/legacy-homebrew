require 'formula'

class MegaSdk < Formula
  homepage 'http://mega.co.nz'
  url 'https://mega.co.nz/sdk.zip'
  version '20130928'
  sha1 '8e2cd6391e6a166cf6c9700ac4c0b54a55900d98'

  depends_on 'berkeley-db'
  depends_on 'cryptopp'
  depends_on 'readline'
  depends_on 'freeimage'
  depends_on 'curl'

  # Adapt for OSX
  def patches; DATA end

  def install
    system "make"
    bin.install "megaclient"
    doc.install "readme.txt"
  end

  def caveats; <<-EOS
    Disclamer:
    You must accept Mega SDK usage agreement before using this software:
    1. Register at http://www.mega.co.nz.
    2. Visit https://mega.co.nz/#sdk, read and accept the agreement.
       Note, agreement will be shown only once and it's tuff!
       In short YOU ARE responsible for all content processed by your instance of this application.
       Including 3rParty/Indirect damages/claims!
    3. Each MEGA client application needs a valid key to access the API.
       Please use a separate key for each of your applications.
       To do so visit https://mega.co.nz/#sdk

    You must accept all above, otherwise, uninstall now!!!
    EOS
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 CXX=g++
-CFLAGS=-g -Wall -isystem /usr/include/cryptopp
+CFLAGS=-g -Wall -isystem /usr/local/include/cryptopp -D_DARWIN_C_SOURCE -I/usr/local/opt/readline/include
 LIB=-lcryptopp -lfreeimage -lreadline -ltermcap -lcurl -ldb_cxx
-LDFLAGS=
+LDFLAGS=-L/usr/local/opt/readline/lib
 SOURCES=megaposix.cpp megacli.cpp megaclient.cpp megacrypto.cpp megabdb.cpp
 OBJECTS=$(SOURCES:.cpp=.o)
 PROGS=megaclient
