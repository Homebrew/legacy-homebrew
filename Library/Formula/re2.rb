require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  head 'https://re2.googlecode.com/hg'
  url 'https://re2.googlecode.com/files/re2-20131024.tgz'
  sha1 '90a356fb205c5004cc4f08e45e02994b898b592a'

  def patches
    if  MacOS.version >= :mavericks
      DATA
    end
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end

__END__

diff --git a/Makefile b/Makefile
index 4ded8ec..ffdb781 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ all: obj/libre2.a obj/so/libre2.so
 # LDPCRE=-L/usr/local/lib -lpcre

 CXX=g++
-CXXFLAGS=-Wall -O3 -g -pthread  # can override
+CXXFLAGS=-Wall -O3 -g -pthread -std=c++11 -DUSE_CXX0X # can override
 RE2_CXXFLAGS=-Wno-sign-compare -c -I. $(CCPCRE)  # required
 LDFLAGS=-pthread
 AR=ar
diff --git a/libre2.symbols.darwin b/libre2.symbols.darwin
index 93eab3e..bf5964f 100644
--- a/libre2.symbols.darwin
+++ b/libre2.symbols.darwin
@@ -6,6 +6,7 @@ __ZNK3re23RE2*
 __ZN3re211StringPiece*
 __ZNK3re211StringPiece*
 # operator<<(std::ostream&, re2::StringPiece const&)
-__ZlsRSoRKN3re211StringPieceE
+# __ZlsRSoRKN3re211StringPieceE
+__ZlsRNSt3__113basic_ostreamIcNS_11char_traitsIcEEEERKN3re211StringPieceE
 # re2::FilteredRE2*
 __ZN3re211FilteredRE2*