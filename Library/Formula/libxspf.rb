class Libxspf < Formula
  desc "C++ library for XSPF playlist reading and writing"
  homepage "http://libspiff.sourceforge.net/"
  url "http://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2"
  sha256 "ba9e93a0066469b074b4022b480004651ad3aa5b4313187fd407d833f79b43a5"

  bottle do
    cellar :any
    revision 1
    sha256 "1d87baedae1c21d2df5bdd91c35be294b7c570e83c5c83fcdf284bce9a985c27" => :yosemite
    sha256 "9f85ead926bf875a18a91db004a04d6aa814c4766a3ab22c3ffa1a0c5371b836" => :mavericks
    sha256 "96a893aa4699d97dc39ef95089d6475f44cc00f7d9a9bea991bec30193e8b005" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"
  depends_on "uriparser"

  # Fix build against clang and GCC 4.7+
  # http://git.xiph.org/?p=libxspf.git;a=commit;h=7f1f68d433f03484b572657ff5df47bba1b03ba6
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/examples/read/read.cpp b/examples/read/read.cpp
index 411f892..b66a25c 100644
--- a/examples/read/read.cpp
+++ b/examples/read/read.cpp
@@ -43,6 +43,7 @@
 #include <cstdio>
 #include <cstdlib> // MAX_PATH
 #include <climits> // PATH_MAX
+#include <unistd.h>
 
 
 #if defined(__WIN32__) || defined(WIN32)
