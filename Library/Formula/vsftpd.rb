require 'formula'

class Vsftpd < Formula
  homepage 'https://security.appspot.com/vsftpd.html'
  url 'https://security.appspot.com/downloads/vsftpd-3.0.2.tar.gz'
  sha1 'f36976bb1c5df25ac236d8a29e965ba2b825ccd0'

  bottle do
    cellar :any
    sha1 "7ad9093e0e863e579cd274fa13a21969d9841534" => :mavericks
    sha1 "bf00933a7a41662814ccf27cf26b25bd960a8cf3" => :mountain_lion
    sha1 "f17c1d98cdca0778e93beebe6022a81a1b3b1267" => :lion
  end

  depends_on 'openssl' => :optional

  # Patch to remove UTMPX dependency, locate OS X's PAM library, and
  #   remove incompatible LDFLAGS. (reported to developer via email)
  patch :DATA

  def install
    if build.with? "openssl"
      inreplace "builddefs.h", "#undef VSF_BUILD_SSL", "#define VSF_BUILD_SSL"
    end

    inreplace "defs.h", "/etc/vsftpd.conf", "#{etc}/vsftpd.conf"
    inreplace "tunables.c", "/etc", etc
    inreplace "tunables.c", "/var", var
    system "make"

    # make install has all the paths hardcoded; this is easier:
    sbin.install "vsftpd"
    etc.install  "vsftpd.conf"
    man5.install "vsftpd.conf.5"
    man8.install "vsftpd.8"
  end

  def caveats
    if build.include? "openssl"
      return <<-EOD.undent
        vsftpd was compiled with SSL support. To use it you must generate a SSL
        certificate and set 'enable_ssl=YES' in your config file.
      EOD
    end
  end
end

__END__
diff --git a/sysdeputil.c b/sysdeputil.c
index 9dc8a5e..66dbe30 100644
--- a/sysdeputil.c
+++ b/sysdeputil.c
@@ -64,6 +64,10 @@
 #include <utmpx.h>
 
 /* BEGIN config */
+#if defined(__APPLE__)
+  #undef VSF_SYSDEP_HAVE_UTMPX
+#endif
+
 #if defined(__linux__)
   #include <errno.h>
   #include <syscall.h>
diff --git a/vsf_findlibs.sh b/vsf_findlibs.sh
index b988be6..68d4a34 100755
--- a/vsf_findlibs.sh
+++ b/vsf_findlibs.sh
@@ -20,6 +20,8 @@ if find_func pam_start sysdeputil.o; then
   locate_library /usr/lib/libpam.sl && echo "-lpam";
   # AIX ends shared libraries with .a
   locate_library /usr/lib/libpam.a && echo "-lpam";
+  # Mac OS X / Darwin shared libraries with .dylib
+  locate_library /usr/lib/libpam.dylib && echo "-lpam";
 else
   locate_library /lib/libcrypt.so && echo "-lcrypt";
   locate_library /usr/lib/libcrypt.so && echo "-lcrypt";
diff --git a/Makefile b/Makefile
index c63ed1b..556519e 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ CFLAGS	=	-O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 \

 LIBS	=	`./vsf_findlibs.sh`
 LINK	=	-Wl,-s
-LDFLAGS	=	-fPIE -pie -Wl,-z,relro -Wl,-z,now
+LDFLAGS	=	-fPIE -pie

 OBJS	=	main.o utility.o prelogin.o ftpcmdio.o postlogin.o privsock.o \
		tunables.o ftpdataio.o secbuf.o ls.o \
