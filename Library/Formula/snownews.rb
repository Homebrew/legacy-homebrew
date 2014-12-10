require 'formula'

class Snownews < Formula
  homepage 'https://kiza.eu/software/snownews'
  url 'https://kiza.eu/media/software/snownews/snownews-1.5.12.tar.gz'
  sha1 'b3addaac25c2c093aa5e60b8b89e50e7d7450bcf'

  option 'without-nls', "Build without translations"

  depends_on 'gettext' if build.with? 'nls'

  # Fix zlib linking issue on OS X
  # snownews author assisted on quest creating this working Formula.
  # Author is aware of the issue tackled. However, no statement has been made whether
  # any future release will change to a more (homebrew) robust = cleaner = simpler basis.
  # homebrew reference added on 2013-07-06 to https://kiza.eu/software/snownews/downloading
  patch :DATA

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-nls" if build.without? 'nls'

    system "./configure", *args
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags}", "CC=#{ENV.cc}"
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
