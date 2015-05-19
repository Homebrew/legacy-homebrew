require 'formula'

class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage 'http://www.gnu.org/software/time/'
  url 'http://ftpmirror.gnu.org/time/time-1.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/time/time-1.7.tar.gz'
  sha1 'dde0c28c7426960736933f3e763320680356cc6a'

  bottle do
    cellar :any
    sha1 "601a630e1fb6892b0c78f75bbfcf92bbc5ddedf3" => :yosemite
    sha1 "1e503175234b796789f2b1b5ea0b12cd40b26997" => :mavericks
    sha1 "cb53342bb927e6977df940b6ca8517d0a2c845f3" => :mountain_lion
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  # Fixes issue with main returning void rather than int
  # http://trac.macports.org/ticket/32860
  # http://trac.macports.org/browser/trunk/dports/sysutils/gtime/files/patch-time.c.diff?rev=88924
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--info=#{info}"
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
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
