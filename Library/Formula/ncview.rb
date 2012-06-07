require 'formula'

class Ncview < Formula
  url 'ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.1.tar.gz'
  homepage 'http://meteora.ucsd.edu/~pierce/ncview_home_page.html'
  md5 '34e25f5949af342a1783542799f51bed'

  depends_on :x11
  depends_on "netcdf"

  # Disable a block in configure that tries to pass an RPATH to the compiler.
  # The code guesses wrong which causes the linking step to fail.
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end

__END__
Don't try to mess with the compiler rpath. Just not a good idea.

diff --git a/configure b/configure
index b80ae96..a650f6f 100755
--- a/configure
+++ b/configure
@@ -8672,29 +8672,6 @@ if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then
 	exit -1
 fi
 
-#----------------------------------------------------------------------------------
-# Construct our RPATH flags.  Idea here is that we have LDFLAGS that might look,
-# for example, something like this:
-#	LIBS="-L/usr/local/lib -lnetcdf -L/home/pierce/lib -ludunits"
-# We want to convert this to -rpath flags suitable for the compiler, which would
-# have this format:
-#	"-Wl,-rpath,/usr/local/lib -Wl,-rpath,/home/pierce/lib"
-#
-# As a safety check, I only do this for the GNU compiler, as I don't know if this
-# is anything like correct syntax for other compilers.  Note that this *does* work
-# for the Intel icc compiler, but also that the icc compiler sets $ac_compiler_gnu
-# to "yes".  Go figure.
-#----------------------------------------------------------------------------------
-if test x$ac_compiler_gnu = xyes; then
-	RPATH_FLAGS=""
-	for word in $UDUNITS2_LDFLAGS $NETCDF_LDFLAGS; do
-		if test `expr $word : -L/` -eq 3; then
-			RPDIR=`expr substr $word 3 999`;
-			RPATH_FLAGS="$RPATH_FLAGS -Wl,-rpath,$RPDIR"
-		fi
-	done
-
-fi
 
 
 ac_config_files="$ac_config_files Makefile src/Makefile"
