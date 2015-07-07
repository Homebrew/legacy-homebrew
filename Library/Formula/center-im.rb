class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "http://www.centerim.org/index.php/Main_Page"
  url "http://www.centerim.org/download/releases/centerim-4.22.10.tar.gz"
  sha1 "46fbac7a55f33b0d4f42568cca21ed83770650e5"
  revision 1

  bottle do
    sha1 "e5787bc7881f9f8ff841aba8884f2e75a5bf53de" => :yosemite
    sha1 "6652a637a3a2cf79e79a721bda64a833f1ffcf0d" => :mavericks
    sha1 "a53626fb4f16e7ba8266ab275070e5218c5e4213" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"
  depends_on "jpeg" => :optional

  # Fix build with clang; 4.22.10 is an outdated release and 5.0 is a rewrite,
  # so this is not reported upstream
  patch :DATA
  patch :p0 do
    url "https://trac.macports.org/export/113135/trunk/dports/net/centerim/files/patch-libjabber_jconn.c.diff"
    sha1 "70bf1cb777e086fb773d99aadbcaa8db77b19bec"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-msn"
    system "make", "install"

    # /bin/gawk does not exist on OS X
    inreplace bin/"cimformathistory", "/bin/gawk", "/usr/bin/awk"
  end

  test do
    assert_match /trillian/, shell_output("#{bin}/cimconv")
  end
end

__END__
diff --git a/libicq2000/libicq2000/sigslot.h b/libicq2000/libicq2000/sigslot.h
index b7509c0..024774f 100644
--- a/libicq2000/libicq2000/sigslot.h
+++ b/libicq2000/libicq2000/sigslot.h
@@ -82,6 +82,7 @@
 #ifndef SIGSLOT_H__
 #define SIGSLOT_H__
 
+#include <cstdlib>
 #include <set>
 #include <list>
 
