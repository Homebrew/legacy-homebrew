class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.18/gtk+-3.18.0.tar.xz"
  sha256 "7fb8ae257403317d3852bad28d064d35f67e978b1fed8b71d5997e87204271b9"

  bottle do
    sha256 "0688f5f68465a8abe79833403bf30e2a223f07d260ae53817b66991b89274923" => :el_capitan
    sha256 "fccf4080d63cd651e85af9284ec0d48ee2885a6f9810ef5f13d0459b0bbd54f1" => :yosemite
    sha256 "c232edec5f498d704a74cc6e7837e28bcfdd66f16d51d31ebb119cc5df0b539d" => :mavericks
  end

  option :universal
  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "pango"
  depends_on "glib"
  depends_on "hicolor-icon-theme"

  # filed upstream in https://bugzilla.gnome.org/show_bug.cgi?id=755401
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", "#{bin}"
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/testsuite/gtk/Makefile.in b/testsuite/gtk/Makefile.in
index 87cffd6..7de122b 100644
--- a/testsuite/gtk/Makefile.in
+++ b/testsuite/gtk/Makefile.in
@@ -118,7 +118,7 @@ am__EXEEXT_2 = accel$(EXEEXT) accessible$(EXEEXT) action$(EXEEXT) \
	firefox-stylecontext$(EXEEXT) floating$(EXEEXT) focus$(EXEEXT) \
	gestures$(EXEEXT) grid$(EXEEXT) gtkmenu$(EXEEXT) \
	icontheme$(EXEEXT) keyhash$(EXEEXT) listbox$(EXEEXT) \
-	notify$(EXEEXT) no-gtk-init$(EXEEXT) object$(EXEEXT) \
+	no-gtk-init$(EXEEXT) object$(EXEEXT) \
	objects-finalize$(EXEEXT) papersize$(EXEEXT) rbtree$(EXEEXT) \
	recentmanager$(EXEEXT) regression-tests$(EXEEXT) \
	spinbutton$(EXEEXT) stylecontext$(EXEEXT) templates$(EXEEXT) \
@@ -264,11 +264,6 @@ no_gtk_init_OBJECTS = no-gtk-init.$(OBJEXT)
 no_gtk_init_LDADD = $(LDADD)
 no_gtk_init_DEPENDENCIES = $(top_builddir)/gtk/libgtk-3.la \
	$(top_builddir)/gdk/libgdk-3.la $(am__DEPENDENCIES_1)
-notify_SOURCES = notify.c
-notify_OBJECTS = notify.$(OBJEXT)
-notify_LDADD = $(LDADD)
-notify_DEPENDENCIES = $(top_builddir)/gtk/libgtk-3.la \
-	$(top_builddir)/gdk/libgdk-3.la $(am__DEPENDENCIES_1)
 object_SOURCES = object.c
 object_OBJECTS = object.$(OBJEXT)
 object_LDADD = $(LDADD)
@@ -738,7 +733,7 @@ EXTRA_DIST = file-chooser-test-dir/empty \
 TEST_PROGS = accel accessible action adjustment bitmask builder \
	builderparser cellarea check-icon-names clipboard defaultvalue \
	entry expander firefox-stylecontext floating focus gestures \
-	grid gtkmenu icontheme keyhash listbox notify no-gtk-init \
+	grid gtkmenu icontheme keyhash listbox no-gtk-init \
	object objects-finalize papersize rbtree recentmanager \
	regression-tests spinbutton stylecontext templates textbuffer \
	textiter treemodel treepath treeview typename window \
@@ -1145,10 +1140,6 @@ no-gtk-init$(EXEEXT): $(no_gtk_init_OBJECTS) $(no_gtk_init_DEPENDENCIES) $(EXTRA
	@rm -f no-gtk-init$(EXEEXT)
	$(AM_V_CCLD)$(LINK) $(no_gtk_init_OBJECTS) $(no_gtk_init_LDADD) $(LIBS)

-notify$(EXEEXT): $(notify_OBJECTS) $(notify_DEPENDENCIES) $(EXTRA_notify_DEPENDENCIES)
-	@rm -f notify$(EXEEXT)
-	$(AM_V_CCLD)$(LINK) $(notify_OBJECTS) $(notify_LDADD) $(LIBS)
-
 object$(EXEEXT): $(object_OBJECTS) $(object_DEPENDENCIES) $(EXTRA_object_DEPENDENCIES)
	@rm -f object$(EXEEXT)
	$(AM_V_CCLD)$(LINK) $(object_OBJECTS) $(object_LDADD) $(LIBS)
@@ -1251,7 +1242,6 @@ distclean-compile:
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/liststore.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/modelrefcount.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/no-gtk-init.Po@am__quote@
-@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/notify.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/object.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/objects-finalize.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/papersize.Po@am__quote@
