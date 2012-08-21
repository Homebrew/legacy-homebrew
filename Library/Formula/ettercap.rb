require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.4-Lazarus/ettercap-0.7.4.1.tar.gz'
  sha1 'f4263230a6065af96b33093f39ed9a387453e3b2'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'libnet'

  # Stripping breaks plugin support
  skip_clean 'bin'

  fails_with :clang do
    build '421'
    cause 'Multiple "converts between pointers to integer types with different sign" warnings.'
  end

  # The below DATA patch fixes an issue where the linker doesn't get passed the ettercap-built
  # 'libwdg' archive which is used for the ncurses interface, thus causing a build failure.
  # See https://github.com/mxcl/homebrew/pull/9540
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--disable-gtk",
                          "--enable-plugins",
                          "--with-openssl=/usr",
                          "--with-libpcap=/usr",
                          "--with-libncurses=/usr",
                          "--with-libpcre=#{HOMEBREW_PREFIX}",
                          "--with-libnet=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end

__END__
--- a/src/Makefile.in	2009-12-20 14:09:50.000000000 -0500
+++ b/src/Makefile.in	2009-12-20 14:10:42.000000000 -0500
@@ -47,7 +47,7 @@
 bin_PROGRAMS = ettercap$(EXEEXT)
 @HAVE_DN_EXPAND_TRUE@am__append_1 = dissectors/ec_dns.c
 @OPENSSL_TRUE@am__append_2 = dissectors/ec_ssh.c
-@NCURSES_TRUE@am__append_3 = interfaces/curses/libec_curses.a 
+@NCURSES_TRUE@am__append_3 = interfaces/curses/libec_curses.a interfaces/curses/widgets/libwdg.a
 @GTK_TRUE@am__append_4 = interfaces/gtk/libec_gtk.a
 subdir = src
 ACLOCAL_M4 = $(top_srcdir)/aclocal.m4
