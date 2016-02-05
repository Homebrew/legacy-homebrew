class Makensis < Formula
  desc "System to create Windows installers"
  homepage "http://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.49/nsis-2.49-src.tar.bz2"
  sha256 "b9777b376e4fc7aae05e89aa6c52a1137fe443952931e15cf0382b3a5d198512"

  bottle do
    cellar :any_skip_relocation
    sha256 "e36c941a8f16e7175b4d1c6de1ec711cf2fec8b91d6c3aecc68e7e5c4f6d091a" => :el_capitan
    sha256 "f0f495b5e44e5be40584ef37b9af44b262106fa23ad2ec7cdcc582010ebeb8f9" => :yosemite
    sha256 "dba4c47a074f8a6c3aa137a8f2117816314e53d1234852ddbfd70b296ec589e2" => :mavericks
  end

  depends_on "scons" => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on OS X are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.49/nsis-2.49.zip"
    sha256 "b7416935d0db6c27b9dfe33e5110456569bbf65ca33cc105fb46ad36226c2eb9"
  end

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "makensis"
    bin.install "build/release/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end
end

__END__
diff --git a/SCons/config.py b/SCons/config.py
index a344456..37c575b 100755
--- a/SCons/config.py
+++ b/SCons/config.py
@@ -1,3 +1,5 @@
+import os
+
 Import('defenv')
 
 ### Configuration options
@@ -440,6 +442,9 @@ Help(cfg.GenerateHelpText(defenv))
 env = Environment()
 cfg.Update(env)
 
+defenv['CC'] = os.environ['CC']
+defenv['CXX'] = os.environ['CXX']
+
 def AddValuedDefine(define):
   defenv.Append(NSIS_CPPDEFINES = [(define, env[define])])
 
