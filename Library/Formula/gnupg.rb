require 'formula'

class GnupgIdea < Formula
  head 'http://www.gnupg.dk/contrib-dk/idea.c.gz', :using  => NoUnzipCurlDownloadStrategy
  md5 '9dc3bc086824a8c7a331f35e09a3e57f'
end

class Gnupg < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.11.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '78e22f5cca88514ee71034aafff539c33f3c6676'

  # Fix from https://bugs.g10code.com/gnupg/issue1292
  # Inline because it is being served w/ a broken cert.
  def patches
    {:p0 => DATA}
  end

  def options
    [
      ["--idea", "Build with (patented) IDEA cipher"],
      ["--8192", "Build with support for private keys up to 8192 bits"],
    ]
  end

  def install
    if ARGV.include? '--idea'
      opoo "You are building with support for the patented IDEA cipher."
      d=Pathname.getwd
      GnupgIdea.new.brew { (d+'cipher').install Dir['*'] }
      system 'gunzip', 'cipher/idea.c.gz'
    end

    inreplace 'g10/keygen.c', 'max=4096', 'max=8192' if ARGV.include? '--8192'

    system "/usr/bin/autoconf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make"
    system "make check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    bin.mkpath
    (libexec+'gnupg').mkpath
    system "make install"
  end

  def caveats
    if ARGV.include? '--idea'
      <<-EOS.undent
        Please read http://www.gnupg.org/faq/why-not-idea.en.html before doing so.
        You will then need to add the following line to your ~/.gnupg/gpg.conf or
        ~/.gnupg/options file:
          load-extension idea
      EOS
    end
  end
end


__END__
Index: configure.ac
===================================================================
--- configure.ac	(revision 5458)
+++ configure.ac	(working copy)
@@ -730,6 +730,17 @@
 [[unsigned char answer[PACKETSZ]; res_query("foo.bar",C_IN,T_A,answer,PACKETSZ); dn_skipname(0,0); dn_expand(0,0,0,0,0);]])],[have_resolver=yes ; need_compat=yes])
        AC_MSG_RESULT($have_resolver)
     fi
+    if test x"$have_resolver" != xyes ; then
+       AC_MSG_CHECKING([whether I can make the resolver usable by linking -lresolv])
+       LIBS="-lresolv $LIBS"
+       AC_LINK_IFELSE([AC_LANG_PROGRAM([#define BIND_8_COMPAT
+#include <sys/types.h>
+#include <netinet/in.h>
+#include <arpa/nameser.h>
+#include <resolv.h>],
+[[unsigned char answer[PACKETSZ]; res_query("foo.bar",C_IN,T_A,answer,PACKETSZ); dn_skipname(0,0); dn_expand(0,0,0,0,0);]])],[have_resolver=yes ; need_compat=yes])
+       AC_MSG_RESULT($have_resolver)
+    fi
   fi

   if test x"$have_resolver" = xyes ; then
Index: ChangeLog
===================================================================
--- ChangeLog	(revision 5458)
+++ ChangeLog	(working copy)
@@ -1,3 +1,7 @@
+2010-10-19  Peter Gerdes <gerdes@invariant.org>
+
+	* configure.ac: Add test to see if -lresolv needs to be added to DNSLIBS to enable DNS resolution on OS X
+
 2010-10-18  Werner Koch  <wk@g10code.com>

 	Release 1.4.11.
