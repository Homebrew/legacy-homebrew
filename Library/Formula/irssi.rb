require "formula"

class Irssi < Formula
  homepage "http://irssi.org/"
  url "http://irssi.org/files/irssi-0.8.17.tar.bz2"
  sha1 "3bdee9a1c1f3e99673143c275d2c40275136664a"

  bottle do
    sha1 "cf15f3d0cadb37218e164250c44d78b4c892d177" => :mavericks
    sha1 "c57f169abb6818eec4fce7581bb0f85a79ce55b2" => :mountain_lion
    sha1 "7bd34bbdc9f67dd9bdaed0b7e84e29c1518b07f1" => :lion
  end

  option "without-perl", "Build without perl support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl" => :optional

  # Fix Perl build flags and paths in man page
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-ipv6
      --enable-true-color
      --with-socks
      --with-ncurses=#{MacOS.sdk_path}/usr
    ]

    if build.with? "perl"
      args << "--with-perl=yes"
      args << "--with-perl-lib=#{lib}/perl5/site_perl"
    else
      args << "--with-perl=no"
    end

    args << "--enable-ssl" if build.with? "openssl"

    system "./configure", *args

    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
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
