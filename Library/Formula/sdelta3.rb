require 'formula'

class Sdelta3 <Formula
  url 'ftp://ftp.berlios.de//pub/sdelta/files/sdelta3-20100323.tar.bz2'
  homepage 'http://sdelta.berlios.de/'
  md5 'f419f4e7ade7751cf2feacbebfbc8aa9'
  version '20100323'

  def patches; DATA; end

  def install
    # Sdelta3 code is not 64-bit clean
    ENV.m32

    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    # fix verbatim references to /usr
    inreplace 'sd3', "/usr/share", "#{HOMEBREW_PREFIX}/share"

    # fix incorrect help message referencing LICENSE file in sdelta3.c:
    # Makefile installs LICENSE into /usr/share/sdelta3, not into /usr/doc/sdelta
    inreplace 'sdelta3.c', "/usr/doc/sdelta", "#{HOMEBREW_PREFIX}/share/#{name}"

    system "make install"
  end
end

__END__
diff --git a/input.h b/input.h
index 64c67bb..04d1b6e 100644
--- a/input.h
+++ b/input.h
@@ -11,6 +11,8 @@
 #include <sys/user.h>
 #elif defined(__NetBSD__)
 #include <sys/vmparam.h>
+#elif defined(__MACH__)
+#include <mach/mach.h>
 #else
 #include <sys/param.h>
 #if (defined(sun) || defined(__sun)) && !defined(PAGE_SIZE)
