class Gcab < Formula
  homepage "https://wiki.gnome.org/msitools"
  url "http://ftp.acc.umu.se/pub/GNOME/sources/gcab/0.6/gcab-0.6.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gcab/gcab_0.6.orig.tar.xz"
  sha256 "a0443b904bfa7227b5155bfcdf9ea9256b6e26930b8febe1c41f972f6f1334bb"

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  # work around ld not understanding --version-script argument
  # upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=708257
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    touch "file1"
    touch "file2"
    system bin/"gcab", "--zip", "-c", testpath/"out.zip",
           testpath/"file1", testpath/"file2"
    File.exist? testpath/"out.zip"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 2264c17..7782d62 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -474,7 +474,7 @@ libgcab_1_0_la_CPPFLAGS = \
 libgcab_1_0_la_LIBADD = -lz $(GLIB_LIBS)
 libgcab_1_0_la_LDFLAGS = \
 	-version-info 0:0:0				\
-	-Wl,--version-script=${srcdir}/libgcab.syms	\
+	-Wl                                     	\
 	-no-undefined					\
 	$(NULL)
