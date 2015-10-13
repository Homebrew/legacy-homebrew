class Hping < Formula
  desc "Command-line oriented TCP/IP packet assembler/analyzer"
  homepage "http://www.hping.org/"
  url "http://www.hping.org/hping3-20051105.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/hping-3.20051105.tar.gz"
  version "3.20051105"
  sha256 "f5a671a62a11dc8114fa98eade19542ed1c3aa3c832b0e572ca0eb1a5a4faee8"

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/fc1d446f/hping/patch-libpcap_stuff.c.diff"
    sha256 "56d3af80a6385bf93257080233e971726283d6555cc244ebe886ea21133e83ad"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/fc1d446f/hping/patch-ars.c.diff"
    sha256 "02138051414e48b9f057a2dd8134c01ccd374aff65593833a799a5aaa36193c4"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/fc1d446f/hping/patch-sendip.c.diff"
    sha256 "e7befff6dd546cdb38b59d9e6d3ef4a4dc09c79af2982f4609b2ea5dadf1a360"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/fc1d446f/hping/patch-Makefile.in.diff"
    sha256 "18ceb30104bdb906b540bb5f6316678ce85fb55f5c086d2d74417416de3792f8"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/fc1d446f/hping/patch-bytesex.h.diff"
    sha256 "7bad5e8b4b5441f72f85d50fa3461857a398b87e2d0cb63bb30985c9457be21d"
  end

  def install
    system "./configure"

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make", "CC=#{ENV.cc}",
                   "COMPILE_TIME=#{ENV.cflags}",
                   "INSTALL_PATH=#{prefix}",
                   "INSTALL_MANPATH=#{man}",
                   "install"
  end
end

__END__
diff --git a/gethostname.c b/gethostname.c
index 3d0ea58..a8a9699 100644
--- a/gethostname.c
+++ b/gethostname.c
@@ -18,8 +18,6 @@
 #include <arpa/inet.h>
 #include <string.h>
 
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 char *get_hostname(char* addr)
 {
 	static char answer[1024];
diff -c -r a/main.c b/main.c
*** a/main.c	2004-06-18 05:53:11.000000000 -0400
--- b/main.c	2014-11-04 19:36:12.000000000 -0500
***************
*** 26,31 ****
--- 26,32 ----
  #include <time.h>
  #include <sys/time.h>
  #include <sys/types.h>
+ #define PCAP_DONT_INCLUDE_PCAP_BPF_H 1
  #include <pcap.h>
  
  #include "hping2.h"
diff -c -r a/script.c b/script.c
*** a/script.c	2004-05-29 02:48:13.000000000 -0400
--- b/script.c	2014-11-04 19:38:05.000000000 -0500
***************
*** 23,28 ****
--- 23,29 ----
  #include <sched.h>
  
  #include <sys/ioctl.h>
+ #define PCAP_DONT_INCLUDE_PCAP_BPF_H 1
  #include <pcap.h>
  #include <net/bpf.h>
  
