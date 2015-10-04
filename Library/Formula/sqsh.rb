class Sqsh < Formula
  desc "Sybase Shell"
  homepage "https://sourceforge.net/projects/sqsh/"
  url "https://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.5/sqsh-2.5.16.1.tgz"
  sha256 "d6641f365ace60225fc0fa48f82b9dbed77a4e506a0e497eb6889e096b8320f2"

  deprecated_option "enable-x" => "with-x11"

  depends_on :x11 => :optional
  depends_on "freetds"
  depends_on "readline"

  # this patch fixes detection of freetds being installed, it was reported
  # upstream via email and should be fixed in the next release
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-readline
    ]

    readline = Formula["readline"]
    ENV["LIBDIRS"] = readline.opt_lib
    ENV["INCDIRS"] = readline.opt_include

    if build.with? "x11"
      args << "--with-x"
      args << "--x-libraries=#{MacOS::X11.lib}"
      args << "--x-includes=#{MacOS::X11.include}"
    end

    ENV["SYBASE"] = Formula["freetds"].opt_prefix
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    assert_equal "sqsh-#{version}", shell_output("#{bin}/sqsh -v").chomp
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
