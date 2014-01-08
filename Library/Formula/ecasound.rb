require 'formula'

class Ecasound < Formula
  homepage 'http://www.eca.cx/ecasound/'
  url 'http://ecasound.seul.org/download/ecasound-2.9.0.tar.gz'
  sha1 'aed604742968085a8e95cdebb21dc62f1d90d2b5'

  option "with-ruby", "Compile with ruby support"

  # 2.9.0 uses clock_gettime which is not available on OS X, patch upstream:
  # http://sourceforge.net/p/ecasound/code/ci/6524048e0717dfbbf7e243edb5b96b40e5983782/tree/kvutils/kvu_threads.cpp?diff=4db2d070691fbabf6af47c68f054a9efcb6d8d47
  def patches; DATA; end

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      clang does not like the fstream imports ecasound uses.
      EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << ("--enable-rubyecasound=" + ((build.with? 'ruby') ? 'yes' : 'no'))
    system "./configure", *args
    system "make install"
  end
end

__END__
--- a/kvutils/kvu_threads.cpp
+++ b/kvutils/kvu_threads.cpp
@@ -122,8 +122,15 @@
 #endif
   }
   else {
+#if defined(CLOCK_REALTIME)
     res = clock_gettime(CLOCK_REALTIME, out);
     out->tv_sec += seconds;
+#else
+    struct timeval tv;
+    res = gettimeofday(&tv, NULL);
+    out->tv_sec = tv.tv_sec + seconds;
+    out->tv_nsec = tv.tv_usec * 1000;
+#endif
   }

   return res;
