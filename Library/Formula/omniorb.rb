class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "http://omniorb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.0/omniORB-4.2.0.tar.bz2"
  sha256 "74c273fc997c2881b128feb52182dbe067acfecc4cf37475f43c104338eba8bc"

  bottle do
    sha256 "8575f53c6de3426c4f640c97fbc966b220869dada8e636494f4a1fe5c1769990" => :yosemite
    sha256 "2245722bc7b21cecee0bfc4b145d3bab51d79979bfbf9e6cb1a0211b4c166e85" => :mavericks
    sha256 "0a5e41a4e19fbe4d685822b2da354d8dd9f5bd32e02376d74d7dfed9e9b9f767" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.0/omniORBpy-4.2.0.tar.bz2"
    sha256 "c82b3bafacbb93cfaace41765219155f2b24eb3781369bba0581feb1dc50fe5e"
  end

  # http://www.omniorb-support.com/pipermail/omniorb-list/2012-February/031202.html
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end

__END__
diff --git a/include/omniORB4/CORBA_sysdep.h b/include/omniORB4/CORBA_sysdep.h
index 3ff1f22..e3b8d3c 100644
--- a/include/omniORB4/CORBA_sysdep.h
+++ b/include/omniORB4/CORBA_sysdep.h
@@ -231,6 +231,11 @@
 #endif


+#if defined(__clang__)
+#  define OMNI_NO_INLINE_FRIENDS
+#endif
+
+
 //
 // Windows DLL hell
 //
