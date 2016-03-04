class Foo < Formula
    head "https://github.com/steve-m/kalibrate-rtl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    depends_on "librtlsdr"
    depends_on "fftw3"

    patch :DATA

    def install
      system "autoreconf", "-fvi"
      system "./configure"
      system "make", "install"
    end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index 4cc39e4..a1dc7ef 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,4 +20,4 @@ kal_SOURCES = \
    version.h
 
 kal_CXXFLAGS = $(FFTW3_CFLAGS) $(LIBRTLSDR_CFLAGS)
-kal_LDADD = $(FFTW3_LIBS) $(LIBRTLSDR_LIBS) -lrt
+kal_LDADD = $(FFTW3_LIBS) $(LIBRTLSDR_LIBS)
