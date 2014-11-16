require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'
  url 'http://fossies.org/linux/misc/fltk-1.3.2-source.tar.gz'
  sha1 '25071d6bb81cc136a449825bfd574094b48f07fb'
  revision 1

  bottle do
    sha1 "fdd346322d4abd84efcb94947dacc1452a922f7d" => :mavericks
    sha1 "20f8ab2cbc0c9c04c2f86e0e9a405baa48d02831" => :mountain_lion
  end

  option :universal

  depends_on 'libpng'
  depends_on 'jpeg'

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  # First patch is to fix issue with -lpng not found.
  # Based on: https://trac.macports.org/browser/trunk/dports/aqua/fltk/files/patch-src-Makefile.diff
  #
  # Second patch is to fix compile issue with clang 3.4.
  # Based on: http://www.fltk.org/strfiles/3046/fltk-clang3.4-1.patch
  #
  # Third patch is to fix compile issue with OSX 10.10 Yosemite
  # Based on: http://www.fltk.org/str.php?L3141
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index fcad5f0..5a5a850 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -355,7 +355,7 @@ libfltk_images.1.3.dylib: $(IMGOBJECTS) libfltk.1.3.dylib
 		-install_name $(libdir)/$@ \
 		-current_version 1.3.1 \
 		-compatibility_version 1.3.0 \
-		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk
+		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk $(LDFLAGS)
 	$(RM) libfltk_images.dylib
 	$(LN) libfltk_images.1.3.dylib libfltk_images.dylib
 
diff --git a/fluid/Fl_Type.h b/fluid/Fl_Type.h
index fdbe320..bd7e741 100644
--- a/fluid/Fl_Type.h
+++ b/fluid/Fl_Type.h
@@ -36,7 +36,7 @@ void set_modflag(int mf);
 class Fl_Type {

   friend class Widget_Browser;
-  friend Fl_Widget *make_type_browser(int,int,int,int,const char *l=0);
+  friend Fl_Widget *make_type_browser(int,int,int,int,const char *);
   friend class Fl_Window_Type;
   virtual void setlabel(const char *); // virtual part of label(char*)
 
diff --git a/src/Fl_cocoa.mm.o b/src/Fl_cocoa.mm
index 1234567..1234567 100644
--- a/src/Fl_cocoa.mm
+++ b/src/Fl_cocoa.mm
@@ -1322,7 +1322,7 @@
     if (need_new_nsapp) [NSApplication sharedApplication];
     NSAutoreleasePool *localPool;
     localPool = [[NSAutoreleasePool alloc] init]; // never released
-    [NSApp setDelegate:[[FLDelegate alloc] init]];
+    [(NSApplication *)NSApp setDelegate:[[FLDelegate alloc] init]];
     if (need_new_nsapp) [NSApp finishLaunching];
 
     // empty the event queue but keep system events for drag&drop of files at launch
@@ -2231,7 +2231,7 @@
     w->set_visible();
     if ( w->border() || (!w->modal() && !w->tooltip_window()) ) Fl::handle(FL_FOCUS, w);
     Fl::first_window(w);
-    [cw setDelegate:[NSApp delegate]];
+    [(NSFileManager *)cw setDelegate:[NSApp delegate]];
     if (fl_show_iconic) { 
       fl_show_iconic = 0;
       [cw miniaturize:nil];
