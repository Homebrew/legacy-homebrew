require 'formula'

class Irssi <Formula
  homepage 'http://irssi.org/'
  url 'http://irssi.org/files/irssi-0.8.14.tar.bz2'
  md5 '00efe7638dd596d5930dfa2aeae87b3a'

  depends_on 'pkg-config'
  depends_on 'glib'

  def skip_clean? path
    path == bin+'irssi'
  end

  def patches
    DATA
  end

  def install
    ENV.append 'ARCHFLAGS', ' ' # wtf?

    args = ["--prefix=#{prefix}", "--disable-dependency-tracking",
            "--with-modules", "--enable-ssl", "--enable-ipv6", "--with-perl=yes"]

    system "./configure", *args
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
