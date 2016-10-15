require "formula"

class Stoken < Formula
  homepage "http://stoken.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.6.tar.gz"
  sha1 "44753445a48c8e17caf69a3e78e3338d74108621"

  depends_on 'gtk+' => :optional
  depends_on 'pkg-config' => :build
  depends_on 'libtomcrypt'

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    if build.without? 'gtk+'
      args << "--without-gtk"
    else
      args << "--with-gtk"
    end
    system "./configure", *args
    system "make install"
  end

  # Fix build issues issue on OS X.
  # upstream bug: https://github.com/cernekee/stoken/issues/9
  patch :p0, :DATA

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
__END__
--- Makefile.in.orig	2014-08-07 20:24:47.000000000 +0200
+++ Makefile.in	2014-08-07 20:24:59.000000000 +0200
@@ -334,8 +334,7 @@
 libstoken_la_SOURCES = src/library.c src/securid.c src/sdtid.c \
 	$(am__append_1)
 libstoken_la_CFLAGS = $(AM_CFLAGS) $(am__append_2)
-libstoken_la_LDFLAGS = -version-number @APIMAJOR@:@APIMINOR@ \
-	-Wl,--version-script,@srcdir@/libstoken.map
+libstoken_la_LDFLAGS = -version-number @APIMAJOR@:@APIMINOR@
 libstoken_la_LIBADD = $(TOMCRYPT_LIBS) $(LIBXML2_LIBS)
 libstoken_la_DEPENDENCIES = libstoken.map
 include_HEADERS = src/stoken.h
