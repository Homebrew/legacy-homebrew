require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org/products/ntop/"
  url "https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-1.2.1.tgz"
  sha1 "e90a8cc045fb4d65d57d029908a9b029d801490c"

  bottle do
    sha1 "9746b5fe9c4635a927ea494707ae7848b0183d2e" => :mavericks
    sha1 "521a62da3a4d1168bf5212297b9aeb7b597b69a4" => :mountain_lion
    sha1 "a7ff0f827998936719f6c4e04060f73939f7bc48" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "wget" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build
  depends_on "luajit" => :build
  depends_on "libsodium" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "geoip"
  depends_on "redis"

  # This seems to require a Libsodium (???) dep, usually provided by zeromq.
  # However ot fails to find libsodium even when zeromq is compiled with it.
  # So we patch the libs list to deliberately seek out the libsodium lib.
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure","--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-h"
  end
end

__END__

diff --git a/Makefile.in b/Makefile.in
index 738bc08..06c3657 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -73,7 +73,7 @@ EWH_HOME=third-party/EWAHBoolArray
 EWH_INC=$(EWH_HOME)/headers
 ######
 TARGET = ntopng
-LIBS = $(NDPI_LIB) $(LIBPCAP) $(LUAJIT_LIB) $(LIBRRDTOOL_LIB) $(ZEROMQ_LIB) $(JSON_LIB) @HIREDIS_LIB@ @SQLITE_LIB@ @LINK_OPTS@ @GEOIP_LIB@ @LDFLAGS@ -lm -lpthread
+LIBS = $(NDPI_LIB) $(LIBPCAP) $(LUAJIT_LIB) $(LIBRRDTOOL_LIB) $(ZEROMQ_LIB) $(JSON_LIB) @HIREDIS_LIB@ @SQLITE_LIB@ @LINK_OPTS@ @GEOIP_LIB@ @LDFLAGS@ -lm -lpthread -lsodium
 CPPFLAGS = -g @CFLAGS@ @HIREDIS_INC@ $(MONGOOSE_INC) $(JSON_INC) $(NDPI_INC) $(LUAJIT_INC) $(LIBRRDTOOL_INC) $(ZEROMQ_INC) @CPPFLAGS@ -I$(HTTPCLIENT_INC) -I$(EWH_INC) -DDATA_DIR='"$(datadir)"'  # -D_GLIBCXX_DEBUG
 ######
 # ntopng-1.0_1234.x86_64.rpm
