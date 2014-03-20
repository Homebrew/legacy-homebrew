require 'formula'

class Imake < Formula
  homepage 'http://xorg.freedesktop.org'
  url 'http://xorg.freedesktop.org/releases/individual/util/imake-1.0.6.tar.bz2'
  sha1 'a54c025d7ac9894b6bc919d13454c6adb12ae140'

  depends_on 'pkg-config' => :build
  depends_on :x11

  resource 'xorg-cf-files' do
    url 'http://xorg.freedesktop.org/releases/individual/util/xorg-cf-files-1.0.5.tar.bz2'
    sha1 'ae22eb81d56d018f0b3b149f70965ebfef2385fd'
  end

  # Remove cpp whitespace check and add "-" to pass the cpp -undef test.
  # These are needed to support superenv (which uses clang)
  patch :DATA

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

    resource('xorg-cf-files').stage do
      # Fix for different X11 locations.
      inreplace "X11.rules", "define TopXInclude	/**/",
                "define TopXInclude	-I#{MacOS::X11.include}"
      system "./configure", "--with-config-dir=#{lib}/X11/config",
                            "--prefix=#{HOMEBREW_PREFIX}"
      system "make install"
    end
  end
end

__END__
diff --git a/configure b/configure
index d4c46f0..4a31a8a 100755
--- a/configure
+++ b/configure
@@ -10581,7 +10581,7 @@ cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 Does cpp redefine unix ?
 _ACEOF
-if test `${RAWCPP} < conftest.$ac_ext | grep -c 'unix'` -eq 1 ; then
+if test `${RAWCPP} - < conftest.$ac_ext | grep -c 'unix'` -eq 1 ; then
	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
 $as_echo "no" >&6; }
 else
@@ -10600,27 +10600,6 @@ $as_echo "yes, with -ansi" >&6; }
 fi
 rm -f conftest.$ac_ext

-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking if $RAWCPP requires -traditional" >&5
-$as_echo_n "checking if $RAWCPP requires -traditional... " >&6; }
-cat confdefs.h - <<_ACEOF >conftest.$ac_ext
-/* end confdefs.h.  */
-Does cpp preserve   "whitespace"?
-_ACEOF
-if test `${RAWCPP} < conftest.$ac_ext | grep -c 'preserve   \"'` -eq 1 ; then
-	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
-$as_echo "no" >&6; }
-else
-	if test `${RAWCPP} -traditional < conftest.$ac_ext | grep -c 'preserve   \"'` -eq 1 ; then
-		RAWCPPFLAGS="${RAWCPPFLAGS} -traditional"
-		{ $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
-$as_echo "yes" >&6; }
-	else
-		as_fn_error $? "${RAWCPP} does not preserve whitespace with or without -traditional.  I don't know what to do." "$LINENO" 5
-	fi
-fi
-rm -f conftest.$ac_ext
-
-
 CPP_PROGRAM=${RAWCPP}
