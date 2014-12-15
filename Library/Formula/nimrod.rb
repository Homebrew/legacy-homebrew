require 'formula'

class Nimrod < Formula
  homepage "http://nimrod-lang.org/"

  stable do
    url "http://nimrod-lang.org/download/nimrod_0.9.6.zip"
    sha1 "a0be99cd67ca2283c6cf076bb7edee74d2f32dc5"

    # This patch fixes an OS X-specific codegen issue.
    # See http://github.com/Araq/Nimrod/issues/1701
    patch :DATA
  end

  head "https://github.com/Araq/Nimrod.git", :branch => "devel"

  bottle do
    cellar :any
    sha1 "3a42be18ae05f497900cba5ba484314c68f62aa1" => :yosemite
    sha1 "f30db501f57632a4872c0dde84a02ff326b58adb" => :mavericks
    sha1 "af153261facdba0a6be325296e82b7c5707ebac6" => :mountain_lion
  end

  def install
    # For some reason the mingw variable doesn't get passed through,
    # so hardcode it. This is fixed in HEAD.
    inreplace "compiler/nimrod.ini", "${mingw}", "mingw32" unless build.head?

    system "/bin/sh", "build.sh"
    system "/bin/sh", "install.sh", prefix

    if build.stable?
      (prefix/"nimrod").install "compiler"
      bin.install_symlink prefix/"nimrod/bin/nimrod"
    else
      (prefix/"nim").install "compiler"
      bin.install_symlink prefix/"nim/bin/nim"
      bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
    end
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("Hi!")
    EOS
    system "#{bin}/nimrod", "compile", "--run", "hello.nim"
  end
end

__END__
--- a/lib/pure/concurrency/cpuinfo.nim
+++ b/lib/pure/concurrency/cpuinfo.nim
@@ -20,15 +20,15 @@ when defined(linux):
   import linux

 when defined(freebsd) or defined(macosx):
-  {.emit:"#include <sys/types.h>".}
+  {.emit:"#include <sys/types.h>\n".}

 when defined(openbsd) or defined(netbsd):
-  {.emit:"#include <sys/param.h>".}
+  {.emit:"#include <sys/param.h>\n".}

 when defined(macosx) or defined(bsd):
   # we HAVE to emit param.h before sysctl.h so we cannot use .header here
   # either. The amount of archaic bullshit in Poonix based OSes is just insane.
-  {.emit:"#include <sys/sysctl.h>".}
+  {.emit:"#include <sys/sysctl.h>\n".}
   const
     CTL_HW = 6
     HW_AVAILCPU = 25
