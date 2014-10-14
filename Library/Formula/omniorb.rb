require 'formula'

class Omniorb < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.1.7/omniORB-4.1.7.tar.bz2'
  sha1 'e039eba5f63458651cfdc8a67c664c1ce4134540'

  depends_on 'pkg-config' => :build

  resource 'bindings' do
    url 'https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-3.7/omniORBpy-3.7.tar.bz2'
    sha1 '71ad9835c2273fe884fd9bd1bc282d40177f4d74'
  end

  # http://www.omniorb-support.com/pipermail/omniorb-list/2012-February/031202.html
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"

    resource('bindings').stage do
      system "./configure", "--prefix=#{prefix}"
      system "make install"
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
