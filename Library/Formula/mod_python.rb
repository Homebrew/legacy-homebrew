require 'formula'

class ModPython <Formula
  url 'http://www.ibiblio.org/pub/mirrors/apache/httpd/modpython/mod_python-3.3.1.tgz'
  homepage 'http://www.modpython.org/'
  md5 'a3b0150176b726bd2833dac3a7837dc5'

  def caveats
    <<-EOS.undent
      To use mod_python, you must manually edit /etc/apache2/httpd.conf to load:
        #{libexec}/mod_python.so

      Note also that mod_python is deprecated, with mod_wsgi the recommended
      replacement. See:
        http://blog.dscpl.com.au/2010/05/modpython-project-soon-to-be-officially.html
    EOS
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
    archs.delete :ppc7400
    archs.delete :ppc64
    ENV.append_to_cflags archs.collect{ |a| "-arch #{a}" }.join(' ')

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
