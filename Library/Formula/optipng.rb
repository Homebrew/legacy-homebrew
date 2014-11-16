require 'formula'

class Optipng < Formula
  homepage 'http://optipng.sourceforge.net/'
  head 'http://optipng.hg.sourceforge.net/hgweb/optipng/optipng'
  url 'https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.5/optipng-0.7.5.tar.gz'
  sha1 '30b6c333d74fc0f5dc83004aace252fa3321368b'

  # Fix compilation on 10.10
  # http://sourceforge.net/p/optipng/bugs/47/
  patch :DATA

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/src/optipng/osys.c b/src/optipng/osys.c
index d816ef7..610250b 100644
--- a/src/optipng/osys.c
+++ b/src/optipng/osys.c
@@ -518,7 +518,7 @@ osys_copy_attr(const char *src_path, const char *dest_path)
     if (chmod(dest_path, sbuf.st_mode) != 0)
         result = -1;
 
-#ifdef AT_FDCWD
+#if defined(AT_FDCWD) && !defined(__APPLE__) && !defined(__SVR4) && !defined(__sun)
     {
         struct timespec times[2];
 
