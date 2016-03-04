class KalibrateRtl < Formula
  desc "Tool to Kalibrate RTL devices"
  homepage "https://github.com/steve-m/kalibrate-rtl"
  url "https://github.com/steve-m/kalibrate-rtl.git", :revision => "aae11c8a8dc79692a94ccfee39ba01e8c8c05d38"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "fftw"
  depends_on "librtlsdr"

  patch :DATA

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make"
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
