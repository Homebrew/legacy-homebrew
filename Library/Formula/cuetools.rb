require "formula"

class Cuetools < Formula
  homepage "https://github.com/svend/cuetools"
  url "https://github.com/svend/cuetools/archive/1.4.0.tar.gz"
  sha1 "2954eb1b33ed7c22ce5201f69ec5480560d650ad"

  head "https://github.com/svend/cuetools.git"

  bottle do
    cellar :any
    sha1 "9e4a137755218db67958c1dd0d700a0a5f8f05d2" => :mavericks
    sha1 "4ef7bdce473feaa1fe4d3e5ea1b71b8d2d43f627" => :mountain_lion
    sha1 "c21d19db598c92f1829c6b92bdafa0215cd33a6f" => :lion
  end

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
