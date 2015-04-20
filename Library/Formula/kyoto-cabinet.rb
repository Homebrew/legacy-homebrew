require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz'
  sha1 'a4ec70d08ca6c8f510dbc329d5c27b55030d3521'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Kyoto-cabinet relies on GCC atomic intrinsics, but Clang does not
      implement them for non-integer types.
    EOS
  end

  patch :DATA if MacOS.version >= :mavericks

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
