require 'formula'

# NOTE TO MAINTAINERS:
#
# Unless Riverbank policy changes in the future or the Mercurial archive
# becomes unavailable, *do not use* the SIP download URL from the Riverbank
# website. This URL will break as soon as a new version of SIP is released
# which causes panic and terror to flood the Homebrew issue tracker.

class Sip < Formula
  url 'http://www.riverbankcomputing.co.uk/hg/sip/archive/4.12.4.tar.gz'
  md5 '22bc7571fd06f26f0f3d7c27bd1c392a'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'

  def patches
    DATA
  end

  def install
    if ARGV.build_head?
      # Set fallback version to the same value it would have without the patch
      # and link the Mercurial repository into the download directory so
      # buid.py can use it to figure out a version number.
      sip_version = "0.1.0"
      ln_s downloader.cached_location + '.hg', '.hg'
    else
      sip_version = version
    end
    inreplace 'build.py', /@SIP_VERSION@/, (sip_version.gsub '.', ',')

    system "python", "build.py", "prepare"
    system "python", "configure.py",
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
for installing from a Mercurial snapshot without the .hg directory from the
Mercurial repository. The install code hooks on to the @SIP_VERSION@ tag and
inserts a real version tuple

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
+        version = (@SIP_VERSION@)
 
     major, minor, micro = version
 

Patch to remove the seemingly unnecessary framework build requirement
diff --git a/siputils.py b/siputils.py
index 57e8911..1af6152 100644
--- a/siputils.py
+++ b/siputils.py
@@ -1434,8 +1434,8 @@ class ModuleMakefile(Makefile):
             # 'real_prefix' exists if virtualenv is being used.
             dl = getattr(sys, 'real_prefix', sys.exec_prefix).split(os.sep)
 
-            if "Python.framework" not in dl:
-                error("SIP requires Python to be built as a framework")
+            # if "Python.framework" not in dl:
+                # error("SIP requires Python to be built as a framework")
 
             self.LFLAGS.append("-undefined dynamic_lookup")
 
