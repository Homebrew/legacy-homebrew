require 'formula'

class RxvtUnicode < Formula
  url 'http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.12.tar.bz2'
  homepage 'http://software.schmorp.de/pkg/rxvt-unicode.html'
  md5 '945af37d661c8c45a7cac292160e7c70'

  depends_on 'pkg-config' => :build

  def patches
    # Patch hunks 1 and 2 allow perl support to compile on Intel.
    # Hunk 3 is taken from http://aur.archlinux.org/packages.php?ID=44649
    # which removes an extra 10% font width that urxvt adds.
    DATA
  end

  def options
    [["--disable-iso14755", "Disable ISO 14775 Shift+Ctrl hotkey"]]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--disable-afterimage",
            "--enable-perl",
            "--enable-256-color",
            "--with-term=rxvt-unicode-256color",
            "--with-terminfo=/usr/share/terminfo",
            "--enable-smart-resize"]
    
    args << "--disable-iso14755" if ARGV.include? "--disable-iso14755"

    system "./configure", *args
    system "make"
    # `make` won't work unless we rename this because of HFS's default case-insensitivity
    system "mv INSTALL README.install"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end

__END__
--- a/configure   2010-12-13 11:48:00.000000000 -0500
+++ b/configure   2011-04-13 13:15:00.000000000 -0400
@@ -8255,8 +8255,8 @@

      save_CXXFLAGS="$CXXFLAGS"
      save_LIBS="$LIBS"
-     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts`"
-     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts`"
+     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
      cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */

@@ -8292,8 +8292,8 @@

         IF_PERL=
         PERL_O=rxvtperl.o
-        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts`"
-        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts`"
+        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
         PERLPRIVLIBEXP="`$PERL -MConfig -e 'print $Config{privlibexp}'`"
      else
         as_fn_error $? "no, unable to link" "$LINENO" 5

--- a/src/rxvtfont.C.bukind 2007-11-30 14:36:33.000000000 +0600
+++ b/src/rxvtfont.C  2007-11-30 14:39:29.000000000 +0600
@@ -1262,12 +1262,21 @@
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

