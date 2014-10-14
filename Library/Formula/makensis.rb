require 'formula'

class Makensis < Formula
  homepage 'http://nsis.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-src.tar.bz2'
  sha1 '2cc9bff130031a0b1d76b01ec0a9136cdf5992ce'

  depends_on 'scons' => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on OS X are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  resource 'nsis' do
    url 'https://downloads.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46.zip'
    sha1 'adeff823a1f8af3c19783700a6b8d9054cf0f3c2'
  end

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "makensis"
    bin.install "build/release/makensis/makensis"
    (share/'nsis').install resource('nsis')
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
 
