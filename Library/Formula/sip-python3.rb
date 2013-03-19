require 'formula'

# NOTE TO MAINTAINERS:
#
# Unless Riverbank policy changes in the future or the Mercurial archive
# becomes unavailable, *do not use* the SIP download URL from the Riverbank
# website. This URL will break as soon as a new version of SIP is released
# which causes panic and terror to flood the Homebrew issue tracker.

class SipPython3 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://sourceforge.net/projects/pyqt/files/sip/sip-4.14.3/sip-4.14.3.tar.gz'
  sha1 '51b913205e1a31e65eea154437438b9c9b5c36d8'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  
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

    system "python#{python_version}", "configure.py",
    "--destdir=#{lib}/python#{python_version}/site-packages",
    "--bindir=#{bin}",
    "--incdir=#{include}",
    "--sipdir=#{share}/sip-python#{python_version}",
    "CFLAGS=#{ENV.cflags}",
    "LFLAGS=#{ENV.ldflags}"

    system "make install"
  end

  def python_version
    `python3 -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{python_version}/site-packages:$PYTHONPATH
    EOS
  end

end


__END__
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
 

