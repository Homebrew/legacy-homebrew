require 'formula'

class Nimrod < Formula
  homepage "http://nimrod-lang.org/"

  stable do
    url "https://github.com/Araq/Nimrod/archive/v0.9.6.tar.gz"
    sha1 "5052ef6faada272392cec415d9cd64cb530724b9"
  end

  head "https://github.com/Araq/Nimrod.git"

  resource "csources" do
    url "https://github.com/nimrod-code/csources.git"
  end

  # This patch fixes an OS X-specific codegen issue.
  # See http://github.com/Araq/Nimrod/issues/1701
  patch :DATA unless build.head?

  def install
    resource("csources").stage do
      pathname = Pathname.pwd

      buildpath.install pathname => "csources"
      mkdir pathname
    end

    cd "csources" do
      system "/bin/sh", "./build.sh"
    end

    system "./bin/nimrod", "c", "koch"
    system "./koch", "boot", "-d:release"

    # For some reason the mingw variable doesn"t get passed through,
    # so hardcode it until upstream fixes it. In some ways the mingw
    # variable is unneeded because it is always mingw32.
    inreplace "compiler/nimrod.ini", "${mingw}", "mingw32" unless build.head?

    system "./koch", "install", prefix
    (prefix/"nimrod").install "compiler"
    bin.install_symlink prefix/"nimrod/bin/nimrod"
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
