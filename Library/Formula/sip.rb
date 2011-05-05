require 'formula'

class Sip < Formula
  url 'http://www.riverbankcomputing.co.uk/static/Downloads/sip4/sip-4.12.2.tar.gz'
  md5 '9df80f88e0e4022cdd8a8891c6c38048'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'

  unless ARGV.include? '--HEAD'
    def patches
      DATA
    end
  end

  def install
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
 
