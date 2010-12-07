require 'formula'

class Aplus <Formula
  url 'http://mirrors.kernel.org/debian/pool/main/a/aplus-fsf/aplus-fsf_4.22.1.orig.tar.gz'
  homepage 'http://www.aplusdev.org/'
  md5 'c45df4f3e816d7fe957deed9b81f66c3'

  def patches
    # need CoreServices.h include to get it to compile.
    # (idea cribbed from fink)
    DATA
  end

  def install
    # replace placeholder w/ actual prefix
    changeme = ["src/lisp.0/aplus.el", "src/lisp.1/aplus.el"]
    chmod 0644, changeme
    changeme.each do |path|
      inreplace path, /_PREFIX_/, prefix
    end
    system "/usr/bin/aclocal -I config"
    system "/usr/bin/glibtoolize --force --copy"
    system "/usr/bin/automake --foreign --add-missing --copy"
    system "/usr/bin/autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "/usr/bin/make"
    # make install breaks with -j option
    system "/usr/bin/make", "install", "MAKEFLAGS="
  end

  def caveats
    return <<-EOS.undent
    This package contains a custom APL font; it doesn't display APL characters
    using the usual Unicode codepoints.  Install it by running

    open #{prefix}/fonts/TrueType/KAPL.TTF

    and clicking on the "Install Font" button.
    EOS
  end
end
__END__
--- a/src/AplusGUI/AplusApplication.C	2010-11-28 17:06:58.000000000 -0800
+++ b/src/AplusGUI/AplusApplication.C	2010-11-28 17:06:31.000000000 -0800
@@ -5,6 +5,7 @@
 //
 //
 ///////////////////////////////////////////////////////////////////////////////
+#include <CoreServices/CoreServices.h>
 #include <MSGUI/MSTextField.H>
 #include <MSGUI/MSWidget.H>
 #include <MSIPC/MSTv.H>
--- a/src/lisp.0/aplus.el	2010-11-28 21:34:09.000000000 -0800
+++ b/src/lisp.0/aplus.el	2010-11-28 21:35:01.000000000 -0800
@@ -5,7 +5,7 @@
 ;;
 (setq load-path
       (append
-       '("/usr/local/aplus-fsf-4.20/lisp.0") load-path
+       '("_PREFIX_/lisp.0") load-path
        )
       )
 ;;
--- a/src/lisp.1/aplus.el	2010-11-28 21:35:52.000000000 -0800
+++ a/src/lisp.1/aplus.el	2010-11-28 21:36:08.000000000 -0800
@@ -32,7 +32,7 @@
 (if aplus-set-load-path
     (setq load-path
	  (append
-	   '("/usr/local/aplus-fsf-4.20/lisp.1") load-path
+	   '("_PREFIX_/lisp.1") load-path
	   )
	  ))
 ;;
