require 'formula'

class ModPython <Formula
  url 'http://www.ibiblio.org/pub/mirrors/apache/httpd/modpython/mod_python-3.3.1.tgz'
  homepage 'http://www.modpython.org/'
  md5 'a3b0150176b726bd2833dac3a7837dc5'

  def caveats
    " * You must manually edit /etc/apache2/httpd.conf to load mod_python.so"
  end

  def patches
    # patch-src-connobject.c.diff from MacPorts
    { :p0 => DATA }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    
    # Explicitly set the arch in CFLAGS so the PSPModule will build against system Python
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")

    arch_flags = ""
    arch_flags += " -arch i386" if archs.include?(:i386)
    arch_flags += " -arch x86_64" if archs.include?(:x86_64)

    ENV.append_to_cflags arch_flags

    inreplace 'Makefile' do |s|
      # Don't install to the system Apache libexec folder
      s.change_make_var! "LIBEXECDIR", libexec
    end

    system "make"
    system "make install"
  end
end

__END__
--- src/connobject.c	2006-12-03 05:36:37.000000000 +0100
+++ src/connobject.c	2008-07-30 12:30:10.000000000 +0200
@@ -139,7 +139,7 @@
     bytes_read = 0;
 
     while ((bytes_read < len || len == 0) &&
-           !(b == APR_BRIGADE_SENTINEL(b) ||
+           !(b == APR_BRIGADE_SENTINEL(bb) ||
              APR_BUCKET_IS_EOS(b) || APR_BUCKET_IS_FLUSH(b))) {
 
         const char *data;
