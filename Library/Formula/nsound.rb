require 'formula'


class Nsound < Formula
  depends_on 'scons' => :build
  depends_on 'swig' => :build
  homepage 'http://nsound.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/nsound/nsound/nsound-0.8.1/nsound-0.8.1.tar.gz'
  md5 'f12384b0bde5200153a47554a60caa01'


  def patches
    # HACK: remove satanic line endings so patch will work
    inreplace 'SConstruct' do |s|
      s.gsub! /\r/, ''
    end

    # fix SConstruct bugs
    DATA
  end

  def install
    # build C++ lib
    ENV['CXXFLAGS'] = "-fno-strict-aliasing -fwrapv -O2"
    system "scons"

    # generate Nsound.h
    system "scons", "disable-python=1" "src/Nsound/Nsound.h"
    # generate setup.py
    system "scons", "setup.py"
    # build Python module
    system "python", "setup.py", "build"

    # install!
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    system "python", "-c", "'from Nsound import *; b=Buffer(); assert str(b) == \"Nsound.Buffer holding 0 samples\"'"
  end
end

__END__
diff --git a/NsoundConfig_Mac.py b/NsoundConfig_Mac.py
index 1d0e79d..e0faa56 100644
--- a/NsoundConfig_Mac.py
+++ b/NsoundConfig_Mac.py
@@ -78,8 +78,8 @@ class NsoundConfig_Mac(NsoundConfig):
 
                 self.env.Append(
                     CCFLAGS = "-I%s" % self.python_include_dir,
-                    LIBPATH = self.python_lib_dir,
-                    LIBS = self.python_lib)
+                    LIBPATH = [self.python_lib_dir],
+                    LIBS = [self.python_lib])
 
                 self.env["LINKFLAGS"] = [
                     "-Wl,-Z"]
diff --git a/SConstruct b/SConstruct
index c4583d9..8daad5a 100755
--- a/SConstruct
+++ b/SConstruct
@@ -484,7 +484,7 @@ if not nsound_config.env.GetOption("help"):
         dict["PACKAGE_NAME"]    = PACKAGE_NAME
         dict["PACKAGE_VERSION"] = PACKAGE_VERSION
 
-        if "src" not in nsound_config.env["CPPPATH"]:
+        if "src" not in nsound_config.env.get("CPPPATH", []): # CPPPATH may not be there at all
             nsound_config.env.AppendUnique(CPPPATH = ["src"])
 
         # CPPPATH
