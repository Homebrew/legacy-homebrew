require 'formula'

class OmniorbBindings < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://sourceforge.net/projects/omniorb/files/omniORBpy/omniORBpy-3.6/omniORBpy-3.6.tar.bz2'
  sha1 '2def5ded7cd30e8d298113ed450b7bd09eaaf26f'
end

class Omniorb < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.1.6/omniORB-4.1.6.tar.bz2'
  sha1 '383e3b3b605188fe6358316917576e0297c4e1a6'

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

    if build.with? 'python'
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
