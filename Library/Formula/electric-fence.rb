require 'formula'

class ElectricFence < Formula
  homepage 'http://perens.com/FreeSoftware/ElectricFence/'
  url 'http://perens.com/FreeSoftware/ElectricFence/electric-fence_2.1.13-0.1.tar.gz'
  version '2.1.13-0.1'
  sha1 'e6765bcb1543272040b806eea706fc7ae9b60524'

  # Patch based on this MacPorts port: https://trac.macports.org/ticket/23836
  # Discussion on how to port it to OS X: http://lists.apple.com/archives/xcode-users/2005/Oct/msg00791.html
  patch :DATA

  def install
    system "make"
    lib.install "libefence.a"
    man3.install "libefence.3"
  end

  test do
    (testpath/'test1.c').write <<-EOS.undent
       #include <stdlib.h>
       int main() {
          int *arr = (int*)malloc(sizeof(int) * 10);
          arr[10] = 1000;
          return 0;
       }
    EOS
    #{ENV.cc}, (testpath/'test1.c'), '-lefence'
  end
end

__END__
diff --git a/Makefile b/Makefile
index 660f586..82054b9 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ AR= ar
 INSTALL= install
 MV= mv
 CHMOD= chmod
-CFLAGS= -g
+CFLAGS= -g -DPAGE_PROTECTION_VIOLATED_SIGNAL=SIGBUS
 LIB_INSTALL_DIR= /usr/lib
 MAN_INSTALL_DIR= /usr/man/man3

diff --git a/page.c b/page.c
index 07ac9d5..69374c4 100644
--- a/page.c
+++ b/page.c
@@ -30,7 +30,7 @@
 static caddr_t	startAddr = (caddr_t) 0;

 #if ( !defined(sgi) && !defined(_AIX) )
-extern int	sys_nerr;
+/*extern int	sys_nerr;*/
 /*extern char *	sys_errlist[];*/
 #endif
