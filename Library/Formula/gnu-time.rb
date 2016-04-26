class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "http://ftpmirror.gnu.org/time/time-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/time/time-1.7.tar.gz"
  sha256 "e37ea79a253bf85a85ada2f7c632c14e481a5fd262a362f6f4fd58e68601496d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3c998fed1b824483f0fd140a0b12164ebc6bd100371dca11291d3406a26ecc47" => :el_capitan
    sha256 "d0b40a36430314f548ab3e5d362c3695b9ab38e83933a7a459deaccfa705232f" => :yosemite
    sha256 "f69ffe3bd6748843ff7013c016bf69a58efde8fb936251b0f6e9e4a2352e1450" => :mavericks
    sha256 "0b28fad39645760e643d90a93c994df01151d4ff43dc8b3c63efa8d59d17783f" => :mountain_lion
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  # Fixes issue with main returning void rather than int
  # https://trac.macports.org/ticket/32860
  # https://trac.macports.org/browser/trunk/dports/sysutils/gtime/files/patch-time.c.diff?rev=88924
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--info=#{info}"
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gtime", "ruby", "--version"
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
