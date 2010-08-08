require 'formula'

class EttercapNg < Formula
  url 'http://prdownloads.sourceforge.net/ettercap/ettercap-NG-0.7.3.tar.gz'
  homepage 'http://ettercap.sourceforge.net/'
  md5 '28fb15cd024162c55249888fe1b97820'

  depends_on 'pcre'
  depends_on 'libnet'

  #
  # Include various macports patches: http://trac.macports.org/export/61709/trunk/dports/net/ettercap-ng/files/
  # I didn't write the macports patches, but they seem to be necessary.
  # Associated discussions:
  #   http://thnetos.wordpress.com/2007/08/10/how-to-compile-ettercap-ng-073-on-mac-osx-when-you-get-that-annoying-pthread-error/
  #   http://thnetos.wordpress.com/2007/11/15/compile-ettercap-ng-073-natively-on-leopard-fix/
  #   http://trac.macports.org/ticket/3031
  #   http://trac.macports.org/ticket/21209
  #
  def patches
    { :p0 => [
      'http://trac.macports.org/export/61709/trunk/dports/net/ettercap-ng/files/patch-configure',
      'http://trac.macports.org/export/61709/trunk/dports/net/ettercap-ng/files/patch-src-interfaces-curses-widgets-wdg.h',
      'http://trac.macports.org/export/61709/trunk/dports/net/ettercap-ng/files/patch-src-Makefile.in',
      'http://trac.macports.org/export/61709/trunk/dports/net/ettercap-ng/files/patch-src__protocols__ec_tcp.c',
      # Fixes missing symbols, libwdg doesn't seem to be linked in otherwise. I'm not even sure the macports package
      # will compile without this, haven't sullied my hands with an attempt though. :)
      DATA
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--disable-gtk",
                          "--disable-plugins",
                          "--with-openssl=/usr",
                          "--with-libpcap=/usr",
                          "--with-libncurses=/usr",
                          "--with-libpcre=#{HOMEBREW_PREFIX}",
                          "--with-libnet=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end

__END__
--- src/Makefile.in	2009-12-20 14:09:50.000000000 -0500
+++ src/Makefile.in.new	2009-12-20 14:10:42.000000000 -0500
@@ -47,7 +47,7 @@
 bin_PROGRAMS = ettercap$(EXEEXT)
 @HAVE_DN_EXPAND_TRUE@am__append_1 = dissectors/ec_dns.c
 @OPENSSL_TRUE@am__append_2 = dissectors/ec_ssh.c
-@NCURSES_TRUE@am__append_3 = interfaces/curses/libec_curses.a 
+@NCURSES_TRUE@am__append_3 = interfaces/curses/libec_curses.a interfaces/curses/widgets/libwdg.a
 @GTK_TRUE@am__append_4 = interfaces/gtk/libec_gtk.a
 subdir = src
 ACLOCAL_M4 = $(top_srcdir)/aclocal.m4
