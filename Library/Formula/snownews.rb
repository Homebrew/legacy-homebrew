require 'formula'

class Snownews < Formula
  homepage 'https://kiza.eu/software/snownews'
  url 'https://kiza.eu/media/software/snownews/snownews-1.5.12.tar.gz'
  sha1 'b3addaac25c2c093aa5e60b8b89e50e7d7450bcf'

  depends_on 'gettext'

  option 'without-nls', "Build without translations"

  # Fix zlib linking issue on OS X
  def patches
    DATA
  end

  def install
    args = %W[--prefix=#{prefix}]

    if build.without? 'nls'
      args << "--disable-nls"
    end

    system "./configure", *args

    system "make", "install"
  end

end
__END__
diff --git a/configure b/configure
index a752cd6..296a282 100755
--- a/configure
+++ b/configure
@@ -33,7 +33,7 @@ if (lc($os) eq "linux") {
 	if ($use_nls == 1) {
 		$ldflags .= ' -lintl ';
 	}
-	$ldflags .= ' -liconv';
+	$ldflags .= ' -liconv -lz';
 } elsif (lc($os) =~ /cygwin/) {
 	print "Configuring for a Cygwin system... ";
 	$cflags = $cflags.' -DSTATIC_CONST_ICONV -I/usr/include/libxml2';
