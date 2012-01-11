require 'formula'

class Ettercap < Formula
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.4-Lazarus/ettercap-0.7.4.tar.gz'
  homepage 'http://ettercap.sourceforge.net'
  md5 'c3a0d91975673c6dfdf8682bcfb661d3'

  depends_on 'pcre'
  depends_on 'libnet'

  # The below DATA patch fixes an issue where the linker doesn't get passed the ettercap-built
  # 'libwdg' archive which is used for the ncurses interface, thus causing a build failure.
  # See https://github.com/mxcl/homebrew/pull/9540
  def patches
    { :p0 => DATA }
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
