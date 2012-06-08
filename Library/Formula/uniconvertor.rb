require 'formula'

class Uniconvertor < Formula
  homepage 'http://sk1project.org/modules.php?name=Products&product=uniconvertor'
  url 'http://sk1project.org/dc.php?target=uniconvertor-1.1.5.tar.gz'
  sha1 '51ec7c4487048c3357ed95cdb4ab3524018a2c9e'

  depends_on 'sk1libs'

  # make it see it's own and sk1libs modules
  def patches; DATA; end

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    # Explicitly set the arch in CFLAGS so it will build against system Python
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV.append_to_cflags archs.as_arch_flags

    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end
end

__END__
diff --git a/src/uniconvertor b/src/uniconvertor
index 06496de..a21f934 100644
--- a/src/uniconvertor
+++ b/src/uniconvertor
@@ -8,6 +8,9 @@
 # For more info see COPYRIGHTS file in uniconvertor root directory.
 #
 
+import sys
+sys.path.insert(0, '/usr/local/Cellar/uniconvertor/1.1.5/lib/python2.6/site-packages/')
+sys.path.insert(0, '/usr/local/Cellar/sk1libs/0.9.1/lib/python2.6/site-packages/')
 
 from uniconvertor import uniconv_run
-uniconv_run()
\ No newline at end of file
+uniconv_run()

