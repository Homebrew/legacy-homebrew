require 'formula'

class Cpuburn < Formula
  homepage 'http://packages.debian.org/stable/misc/cpuburn'
  url 'http://ftp.de.debian.org/debian/pool/main/c/cpuburn/cpuburn_1.4a.orig.tar.gz'
  sha256 'eb191ce9bfbf453d30c218c3419573df102a3588f96c4a43686c84bb9da4bed6'

  patch :DATA

  def install
    ENV.m32

    # GNU assembler syntax requires .p2align parameter format for .align pseudo-op
    # in i386 assembly but author uses .balign parameter format
    Dir.glob("*.S") do |file|
      inreplace file, '.align', '.balign'
    end

    system "make"

    bin.install "burnP5", "burnP6", "burnK6", "burnK7", "burnBX", "burnMMX"
    doc.install "README"
  end

  def caveats
    <<-EOS.undent % doc
      cpuburn is dangerous for your system!
      This program is designed to heavily load CPU chips. Undercooled,
      overclocked or otherwise weak systems may fail causing data loss
      (filesystem corruption) and possibly permanent damage to electronic
      components. Use at your own risk.

      For more information, see %s/README.
    EOS
  end
end

__END__
diff --git a/Makefile b/Makefile
index c86f1a8..fd22457 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,4 @@
+CFLAGS := -s -m32 -static -e _start -nostdlib
 all : burnP5 burnP6 burnK6 burnK7 burnBX burnMMX
 .S:
-	gcc -s -nostdlib -o $@ $<
+	$(CC) $(CFLAGS) -o $@ $<
