require 'formula'

class GnuTime < Formula
  homepage 'http://www.gnu.org/software/time/'
  url 'http://ftpmirror.gnu.org/time/time-1.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/time/time-1.7.tar.gz'
  md5 'e38d2b8b34b1ca259cf7b053caac32b3'

  # Fixes issue with main returning void rather than int
  # http://trac.macports.org/ticket/32860
  # http://trac.macports.org/browser/trunk/dports/sysutils/gtime/files/patch-time.c.diff?rev=88924
  def patches
    DATA
  end

  def install
    system "./configure", "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--info=#{info}"
    system "make install"
  end
end

__END__
diff --git a/time.c b/time.c
index 9d5cf2c..97611f5 100644
--- a/time.c
+++ b/time.c
@@ -628,7 +628,7 @@ run_command (cmd, resp)
   signal (SIGQUIT, quit_signal);
 }
 
-void
+int
 main (argc, argv)
      int argc;
      char **argv;
