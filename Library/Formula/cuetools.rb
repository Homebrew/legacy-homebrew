class Cuetools < Formula
  desc "Utilities for .cue and .toc files"
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/1.4.1.tar.gz"
  sha256 "24a2420f100c69a6539a9feeb4130d19532f9f8a0428a8b9b289c6da761eb107"

  head "https://github.com/svend/cuetools.git"

  bottle do
    cellar :any
    sha256 "81d06ef2e3d98061f332a535b810102c1be0505371c1ac1aed711cf2ae8de5a3" => :yosemite
    sha256 "95216c0df3840b2602e61dd3bef7d4c9b65cec0315e5b23ac87329320d9f6be9" => :mavericks
    sha256 "cc5240434bb054a51ebb4e4bb3adc8e97844da66aa425fc667f54ecf53ad9aa6" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # see https://github.com/svend/cuetools/pull/18
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cue").write <<-EOS.undent
      FILE "sampleimage.bin" BINARY
        TRACK 01 MODE1/2352
          INDEX 01 00:00:00
    EOS
    system "cueconvert", testpath/"test.cue", testpath/"test.toc"
    File.exist? "test.toc"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index f54bb92..84ab467 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 AC_INIT([cuetools], [1.4.0], [svend@ciffer.net])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Werror -Wno-extra-portability foreign])
 AC_PROG_CC
 AC_PROG_INSTALL
 AC_PROG_RANLIB
