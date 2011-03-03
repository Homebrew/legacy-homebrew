require 'formula'

class RxvtUnicode < Formula
  url 'http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-9.07.tar.bz2'
  homepage 'http://software.schmorp.de/pkg/rxvt-unicode.html'
  md5 '49bb52c99e002bf85eb41d8385d903b5'

  def patches
    # Add 256 color support
    {:p1 => ["doc/urxvt-8.2-256color.patch", DATA]}
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-afterimage",
                          "--enable-perl",
                          "--enable-256-color",
                          "--with-term=rxvt-256color"
    system "make"
    # `make` won't work unless we rename this
    system "mv INSTALL README.install"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end

__END__
--- a/configure	2009-12-30 07:13:23.000000000 +0100
+++ b/configure	2010-07-12 20:36:58.000000000 +0200
@@ -11810,8 +11810,8 @@
 
      save_CXXFLAGS="$CXXFLAGS"
      save_LIBS="$LIBS"
-     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts`"
-     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts`"
+     CXXFLAGS="$CXXFLAGS `$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+     LIBS="$LIBS `$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
      cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
@@ -11874,8 +11874,8 @@
 
         IF_PERL=
         PERL_O=rxvtperl.o
-        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts`"
-        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts`"
+        PERLFLAGS="`$PERL -MExtUtils::Embed -e ccopts|sed -E 's/ -arch [^ ]+//g'`"
+        PERLLIB="`$PERL -MExtUtils::Embed -e ldopts|sed -E 's/ -arch [^ ]+//g'`"
         PERLPRIVLIBEXP="`$PERL -MConfig -e 'print $Config{privlibexp}'`"
      else
         { { echo "$as_me:$LINENO: error: no, unable to link" >&5
