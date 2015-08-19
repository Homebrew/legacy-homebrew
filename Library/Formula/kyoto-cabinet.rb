class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "http://fallabs.com/kyotocabinet/"
  url "http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz"
  sha256 "812a2d3f29c351db4c6f1ff29d94d7135f9e601d7cc1872ec1d7eed381d0d23c"

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
    system "make", "install"
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
