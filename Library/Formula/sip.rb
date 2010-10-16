require 'formula'

class Sip <Formula
  url 'http://www.riverbankcomputing.co.uk/hg/sip/archive/4.11.1.tar.gz'
  md5 'dbafd7101a4e7caee6f529912a1356e5'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'

  unless ARGV.include? '--HEAD'
    def patches
      DATA
    end
  end

  def install
    # Force building against System python, because we need a Framework build.
    # See: http://github.com/mxcl/homebrew/issues/issue/930
    system "/usr/bin/python", "build.py", "prepare"
    system "/usr/bin/python", "configure.py",
                              "--destdir=#{lib}/python",
                              "--bindir=#{bin}",
                              "--incdir=#{include}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula won't function until you amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
    EOS
  end
end
__END__
Patch to allow the SIP build.py script to generate a reasonable version number
without the .hg directory from the Mercurial repository.

diff --git a/build.py b/build.py
index 927d7f1..fdf13a3 100755
--- a/build.py
+++ b/build.py
@@ -179,7 +179,7 @@ def _get_release():
         changelog = None
         name = os.path.basename(_RootDir)
 
-        release_suffix = "-unknown"
+        release_suffix = ""
         version = None
 
         parts = name.split('-')
@@ -192,7 +192,7 @@ def _get_release():
 
     # Format the results.
     if version is None:
-        version = (0, 1, 0)
+        version = (4, 11, 1)
 
     major, minor, micro = version
 
