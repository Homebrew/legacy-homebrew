class Makensis < Formula
  desc "System to create Windows installers"
  homepage "http://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.50/nsis-2.50-src.tar.bz2"
  sha256 "3fb674cb75e0237ef6b7c9e8a8e8ce89504087a6932c5d2e26764d4220a89848"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fe7c4c515178d9f03d41c1cdae529b757a4dc0677590878af36c5ad18139da2" => :el_capitan
    sha256 "dfb81426bb147fe471cb314647c91862e45f27a7a72773685e20421d504ac6c4" => :yosemite
    sha256 "df608eed02642d4f9dfbc230e175e460e9769d351acbd9411455ad4333cf1282" => :mavericks
  end

  depends_on "scons" => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on OS X are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.50/nsis-2.50.zip"
    sha256 "36bebcd12ad8ec6b94920b46c4c5a7a9fccdaa5e9aececb9e89aecfdfa35e472"
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
 
