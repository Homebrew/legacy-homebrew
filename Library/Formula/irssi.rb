require 'formula'

class Irssi < Formula
  homepage 'http://irssi.org/'
  url 'http://irssi.org/files/irssi-0.8.15.tar.bz2'
  md5 '1dcb3f511b88df94b0c996f36668c7da'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  # Don't strip, to allow dynamic loading of modules
  skip_clean 'bin'

  def patches
    # Fix Perl path and path in man page
    DATA
  end

  def install
    ENV.append 'ARCHFLAGS', ' ' # wtf?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-perl=yes",
                          "--with-perl-lib=#{lib}/perl5/site_perl",
                          "--with-bot",
                          "--with-proxy",
                          "--enable-ssl",
                          "--enable-ipv6",
                          "--with-socks"
    # 'make' and 'make install' must be done separately on some systems
    system "make"
    system "make install"
  end
end

__END__
--- a/configure	2009-12-03 19:35:07.000000000 -0800
+++ b/configure	2009-12-03 19:35:33.000000000 -0800
@@ -27419,7 +27419,7 @@
 	if test -z "$perlpath"; then
 		perl_check_error="perl binary not found"
 	else
-		PERL_CFLAGS=`$perlpath -MExtUtils::Embed -e ccopts 2>/dev/null`
+		PERL_CFLAGS=`$perlpath -MExtUtils::Embed -e ccopts 2>/dev/null | $SED -e 's/-arch [^ ]\{1,\}//g'`
 	fi
 
 	if test "x$ac_cv_c_compiler_gnu" = "xyes" -a -z "`echo $host_os|grep 'bsd\|linux'`"; then
@@ -27437,7 +27437,7 @@
 $as_echo "not found, building without Perl" >&6; }
 		want_perl=no
 	else
-		PERL_LDFLAGS=`$perlpath -MExtUtils::Embed -e ldopts 2>/dev/null`
+		PERL_LDFLAGS=`$perlpath -MExtUtils::Embed -e ldopts 2>/dev/null | $SED -e 's/-arch [^ ]\{1,\}//g'`
 
 		if test "x$DYNLIB_MODULES" = "xno" -a "$want_perl" != "static"; then
 						want_perl=static

diff --git a/docs/irssi.1 b/docs/irssi.1
index 62c2844..482cd96 100644
--- a/docs/irssi.1
+++ b/docs/irssi.1
@@ -65,10 +65,10 @@ display brief usage message.
 .SH SEE ALSO
 .B Irssi
 has been supplied with a huge amount of documentation. Check /help or look
-at the files contained by /usr/share/doc/irssi*
+at the files contained by HOMEBREW_PREFIX/share/doc/irssi*
 .SH FILES
 .TP
-.I /etc/irssi.conf
+.I HOMEBREW_PREFIX/etc/irssi.conf
 Global configuration file
 .TP
 .I ~/.irssi/config
@@ -83,13 +83,13 @@ Default irssi theme
 .I ~/.irssi/away.log
 Logged messages in away status
 .TP
-.I /usr/share/irssi/help/
+.I HOMEBREW_PREFIX/share/irssi/help/
 Directory including many help files
 .TP
-.I /usr/share/irssi/scripts/
+.I HOMEBREW_PREFIX/share/irssi/scripts/
 Global scripts directory
 .TP
-.I /usr/share/irssi/themes/
+.I HOMEBREW_PREFIX/share/irssi/themes/
 Global themes directory
 .TP
 .I ~/.irssi/scripts/
