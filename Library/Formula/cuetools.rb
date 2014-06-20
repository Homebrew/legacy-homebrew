require "formula"

class Cuetools < Formula
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/1.4.0.tar.gz"
  sha1 "2954eb1b33ed7c22ce5201f69ec5480560d650ad"

  head "https://github.com/svend/cuetools.git"

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool => :build

  # see https://github.com/svend/cuetools/pull/18
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
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

