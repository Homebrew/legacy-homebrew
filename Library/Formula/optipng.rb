class Optipng < Formula
  desc "PNG file optimizer"
  homepage "http://optipng.sourceforge.net/"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.5/optipng-0.7.5.tar.gz"
  sha256 "74e54b798b012dff8993fb8d90185ca83f18cfa4935f4a93b0bcfc33c849619d"

  # Fix compilation on 10.10
  # http://sourceforge.net/p/optipng/bugs/47/
  patch :DATA

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
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
 
