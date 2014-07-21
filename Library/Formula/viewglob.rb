require 'formula'

class Viewglob < Formula
  homepage 'http://viewglob.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/viewglob/viewglob/2.0.4/viewglob-2.0.4.tar.gz'
  sha1 'd3173706c4c089d4b1ac99bbe96de805093727f4'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gtk+'

  # Don't include the <sys/stropts.h> header, it's not available on OS X.
  # Fixed upstream for next version.
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    When using viewglob with bash, to modify the prompt string PS1 used by
    the viewglob shell, set the variable in ~/.bashrc (using ~/.profile or
    manually setting the variable does not work).
    EOS
  end
end

__END__
diff --git a/vgseer/ptytty.c b/vgseer/ptytty.c
index e5925bf..7eeefb5 100644
--- a/vgseer/ptytty.c
+++ b/vgseer/ptytty.c
@@ -59,7 +59,7 @@
 #ifdef HAVE_SYS_IOCTL_H
 # include <sys/ioctl.h>
 #endif
-#if defined(PTYS_ARE_PTMX) && !defined(__CYGWIN32__)
+#if defined(PTYS_ARE_PTMX) && !(defined(__CYGWIN32__) || defined(__APPLE__))
 # include <sys/stropts.h>      /* for I_PUSH */
 #endif

