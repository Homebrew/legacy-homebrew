require 'formula'

class OmniorbBindings < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-3.7/omniORBpy-3.7.tar.bz2'
  sha1 '71ad9835c2273fe884fd9bd1bc282d40177f4d74'
end

class Omniorb < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.1.7/omniORB-4.1.7.tar.bz2'
  sha1 'e039eba5f63458651cfdc8a67c664c1ce4134540'

  depends_on 'pkg-config' => :build
  depends_on :python => :recommended

  # http://www.omniorb-support.com/pipermail/omniorb-list/2012-February/031202.html
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"

    python do
      OmniorbBindings.new.brew do
        system "./configure", "--prefix=#{prefix}"
        system "make install"
      end
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    system "#{bin}/omniidl", "-h"
    python do
      system python, "-c", %(import omniORB; print 'omniORBpy', omniORB.__version__)
    end
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
