require "formula"

class RxvtUnicode < Formula
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.20.tar.bz2"
  sha1 "6214c7893a8c968936103e255a1d3d1e9868abf9"

  option "disable-iso14755", "Disable ISO 14775 Shift+Ctrl hotkey"

  depends_on "pkg-config" => :build
  depends_on :x11

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 removes an extra 10% font width that urxvt adds.
  #   http://aur.archlinux.org/packages.php?ID=44649
  # Patch 4 fixes `make install` target on case-insensitive filesystems
  patch :DATA

  fails_with :llvm do
    build 2336
    cause "memory fences not defined for your architecture"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
    ]

    args << "--disable-perl" if ENV.compiler == :clang
    args << "--disable-iso14755" if build.include? "disable-iso14755"

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index c756724..5e94907 100755
--- a/configure
+++ b/configure
@@ -7847,8 +7847,8 @@ $as_echo_n "checking for $PERL suitability... " >&6; }
 
      save_CXXFLAGS="$CXXFLAGS"
      save_LIBS="$LIBS"
-     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts`"
-     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts`"
+     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
      cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
@@ -7884,8 +7884,8 @@ $as_echo "#define ENABLE_PERL 1" >>confdefs.h
 
         IF_PERL=
         PERL_O=rxvtperl.o
-        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts`"
-        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts`"
+        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
         PERLPRIVLIBEXP="`$PERL -MConfig -e 'print $Config{privlibexp}'`"
      else
         as_fn_error $? "no, unable to link" "$LINENO" 5
diff --git a/src/rxvtfont.C b/src/rxvtfont.C
index 3ff0b04..ecf8196 100644
--- a/src/rxvtfont.C
+++ b/src/rxvtfont.C
@@ -1265,12 +1265,21 @@ rxvt_font_xft::load (const rxvt_fontprop &prop, bool force_prop)
           XGlyphInfo g;
           XftTextExtents16 (disp, f, &ch, 1, &g);
 
+/*
+ * bukind: don't use g.width as a width of a character!
+ * instead use g.xOff, see e.g.: http://keithp.com/~keithp/render/Xft.tutorial
+
           g.width -= g.x;
 
           int wcw = WCWIDTH (ch);
           if (wcw > 0) g.width = (g.width + wcw - 1) / wcw;
 
           if (width    < g.width       ) width    = g.width;
+ */
+          int wcw = WCWIDTH (ch);
+          if (wcw > 1) g.xOff = g.xOff / wcw;
+          if (width < g.xOff) width = g.xOff;
+
           if (height   < g.height      ) height   = g.height;
           if (glheight < g.height - g.y) glheight = g.height - g.y;
         }
diff --git a/Makefile.in b/Makefile.in
index eee5969..c230930 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -31,6 +31,7 @@ subdirs = src doc
 
 RECURSIVE_TARGETS = all allbin alldoc tags clean distclean realclean install
 
+.PHONY: install
 #-------------------------------------------------------------------------
 
 $(RECURSIVE_TARGETS):
