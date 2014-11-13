require "formula"

class Nailgun < Formula
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/martylamb/nailgun/archive/nailgun-all-0.9.1.tar.gz"
  sha1 "75f21504e8a6d41f263560b74c33188e91ec1a27"

  bottle do
    cellar :any
    sha1 "79c825aeb76953a793edd71ae902675f5a5b3c68" => :yosemite
    sha1 "cf981b2485dd85508e2b9c4c29813680cfb919c1" => :mavericks
    sha1 "f81acd632ef0bf6e376802180268e37cc425bccd" => :mountain_lion
  end

  resource "nailgun-jar" do
    url "http://central.maven.org/maven2/com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar"
    sha1 "d57ea0a6f6c1bb1b616c5b3b311b3726c6ff35ad"
  end

  # The makefile is not prefix aware: https://github.com/martylamb/nailgun/pull/45
  patch :DATA

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    libexec.install resource("nailgun-jar").files("nailgun-server-#{version}.jar")
    bin.write_jar_script libexec/"nailgun-server-#{version}.jar", "ng-server", "-server"
  end

  test do
    fork { exec "ng-server", "8765" }
    sleep 1 # the server does not begin listening as fast as we can start a background process
    system "ng", "--nailgun-port", "8765", "ng-version"
    Kernel.system "ng", "--nailgun-port", "8765", "ng-stop"
    # ng-stop always returns a non-zero exit code even on successful exit
    true
  end
end

__END__
diff --git a/Makefile b/Makefile
index 21b55e9..e4adfa4 100644
--- a/Makefile
+++ b/Makefile
@@ -10,13 +10,15 @@ WIN32_CC=/usr/bin/i586-mingw32msvc-gcc
 CC=gcc
 CFLAGS=-Wall -pedantic -s -O3
 SRCDIR=nailgun-client
+PREFIX=/usr/local
 
 ng: ${SRCDIR}/ng.c
 	@echo "Building ng client.  To build a Windows binary, type 'make ng.exe'"
 	${CC} ${CFLAGS} -o ng ${SRCDIR}/ng.c
 
 install: ng
-	install ng /usr/local/bin
+	install -d ${PREFIX}/bin
+	install ng ${PREFIX}/bin
 	
 ng.exe: ${SRCDIR}/ng.c
 	${WIN32_CC} -o ng.exe ${SRCDIR}/ng.c -lwsock32 -O3 ${CFLAGS}
