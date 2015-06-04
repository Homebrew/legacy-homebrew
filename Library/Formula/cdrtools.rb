class Cdrtools < Formula
  homepage "http://cdrecord.org/"

  stable do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.00.tar.bz2"
    sha256 "7f9cb64820055573b880f77b2f16662a512518336ba95ab49228a1617973423d"

    patch :p0 do
      url "https://trac.macports.org/export/104091/trunk/dports/sysutils/cdrtools/files/patch-include_schily_sha2.h"
      sha256 "59a62420138c54fbea6eaa10a11f69488bb3fecf4f954fda47a3b1e424671d61"
    end
  end

  bottle do
    sha1 "497614205a68d26bcbefce88c37cbebd9e573202" => :yosemite
    sha1 "d5041283713c290cad78f426a277d376a9e90c49" => :mavericks
    sha1 "434f1296db4fb7c082bed1ba25600322c8f31c78" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.01a29.tar.bz2"
    sha256 "3ad98ea911a4ee7811ecfc433b70dac3a3b9671eb71a55da9f4a7e08cb6fc247"

    patch :p0, :DATA
  end

  depends_on 'smake' => :build

  conflicts_with 'dvdrtools',
    :because => 'both dvdrtools and cdrtools install binaries by the same name'

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    (lib/"profiled").rmtree
    man5.rmtree
  end

  test do
    system "#{bin}/cdrecord", "-version"
    system "#{bin}/cdda2wav", "-version"
    (testpath/"testfile.txt").write("testing mkisofs")
    system "#{bin}/mkisofs", "-r", "-o", "test.iso", "testfile.txt"
    assert (testpath/"test.iso").exist?
  end
end

__END__
--- include/schily/sha2.h.orig	2010-08-27 10:41:30.000000000 +0000
+++ include/schily/sha2.h
@@ -104,10 +104,12 @@
 
 #ifdef	HAVE_LONGLONG
 extern void SHA384Init		__PR((SHA2_CTX *));
+#ifndef HAVE_PRAGMA_WEAK
 extern void SHA384Transform	__PR((UInt64_t state[8],
 					const UInt8_t [SHA384_BLOCK_LENGTH]));
 extern void SHA384Update	__PR((SHA2_CTX *, const UInt8_t *, size_t));
 extern void SHA384Pad		__PR((SHA2_CTX *));
+#endif
 extern void SHA384Final		__PR((UInt8_t [SHA384_DIGEST_LENGTH],
 					SHA2_CTX *));
 extern char *SHA384End		__PR((SHA2_CTX *, char *));
