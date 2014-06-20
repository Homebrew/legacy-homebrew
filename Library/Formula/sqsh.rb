require 'formula'

class Sqsh < Formula
  homepage 'http://www.cs.washington.edu/~rose/sqsh/sqsh.html'
  url 'https://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.5/sqsh-2.5.16.1.tgz'
  sha1 '1bdbab03ab96f53d0a0a279ba2518643225c6460'

  option "enable-x", "Enable X windows support"

  depends_on :x11 if build.include? "enable-x"
  depends_on 'freetds'
  depends_on 'readline'

  # this patch fixes detection of freetds being instaled, it was reported
  # upstream via email and should be fixed in the next release
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-readline
    ]

    readline = Formula["readline"]
    ENV['LIBDIRS'] = readline.opt_lib
    ENV['INCDIRS'] = readline.opt_include

    if build.include? "enable-x"
      args << "--with-x"
      args << "--x-libraries=#{MacOS::X11.lib}"
      args << "--x-includes=#{MacOS::X11.include}"
    end

    ENV['SYBASE'] = Formula["freetds"].opt_prefix
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end
end

__END__
diff -Naur sqsh-2.5-orig/configure sqsh-2.5/configure
--- sqsh-2.5-orig/configure	2014-06-08 11:10:37.000000000 +0200
+++ sqsh-2.5/configure	2014-06-08 13:46:17.000000000 +0200
@@ -3937,12 +3937,12 @@
		# Assume this is a FreeTDS build
		#
			SYBASE_VERSION="FreeTDS"
-			if [ "$ac_cv_bit_mode" = "64" -a -f $SYBASE_OCOS/lib64/libct.so ]; then
+			if [ "$ac_cv_bit_mode" = "64" -a -f $SYBASE_OCOS/lib64/libct.a ]; then
				SYBASE_LIBDIR="$SYBASE_OCOS/lib64"
			else
				SYBASE_LIBDIR="$SYBASE_OCOS/lib"
			fi
-			if [ ! -f $SYBASE_LIBDIR/libct.so ]; then
+			if [ ! -f $SYBASE_LIBDIR/libct.a ]; then
				{ $as_echo "$as_me:${as_lineno-$LINENO}: result: fail" >&5
 $as_echo "fail" >&6; }
				as_fn_error $? "No properly installed FreeTDS or Sybase environment found in ${SYBASE_OCOS}." "$LINENO" 5
