class Gcab < Formula
  homepage "https://wiki.gnome.org/msitools"
  url "http://ftp.gnome.org/pub/GNOME/sources/gcab/0.6/gcab-0.6.tar.xz"
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
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff -up a/Makefile.in b/Makefile.in
--- a/Makefile.in	2015-03-17 15:11:46.000000000 +0000
+++ b/Makefile.in
@@ -527,7 +527,7 @@ libgcab_1_0_la_CPPFLAGS = \
 libgcab_1_0_la_LIBADD = -lz $(GLIB_LIBS)
 libgcab_1_0_la_LDFLAGS = \
 	-version-info 0:0:0				\
-	-Wl,--version-script=${srcdir}/libgcab.syms	\
+	-Wl						\
 	-no-undefined					\
 	$(NULL)

