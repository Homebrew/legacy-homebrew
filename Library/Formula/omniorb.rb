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

  option 'python', 'Enable Python mappings'

  depends_on 'pkg-config' => :build

  # http://www.omniorb-support.com/pipermail/omniorb-list/2012-February/031202.html
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}", "PYTHON=#{which 'python'}"]
    system "./configure", *args
    system "make"
    system "make install"

    if  build.include? 'python'
      OmniorbBindings.new.brew do
        system "./configure", *args
        system "make install"
      end
    end
  end

  def caveats
    s = ''
    if build.include? 'python'
      s += <<-EOS.undent
        For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
    return s.empty? ? nil : s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
   system "omniidl", "-h"

   if build.include? 'python'
       system "python", "-c", %(import omniORB; print 'omniORBpy', omniORB.__version__)
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
