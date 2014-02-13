require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'https://launchpad.net/libmemcached/1.0/1.0.17/+download/libmemcached-1.0.17.tar.gz'
  sha1 '1023bc8c738b1f5b8ea2cd16d709ec6b47c3efa8'

  option 'with-sasl', "Build with sasl support"
  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    args = []
    args << "--prefix=#{prefix}"
    args << "--with-memcached-sasl=#{Formula.factory("memcached").bin}/memcached" if build.include? 'with-sasl'

    system "./configure", *args
    system "make install"
  end

  def patches
    if MacOS.version >= :mavericks and ENV.compiler == :clang
      # build fix for tr1 -> std
      DATA
    end
  end

end

__END__
diff --git a/libmemcached-1.0/memcached.h b/libmemcached-1.0/memcached.h
index 3c11f61..dcee395 100644
--- a/libmemcached-1.0/memcached.h
+++ b/libmemcached-1.0/memcached.h
@@ -43,7 +43,11 @@
 #endif

 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
+#  include <cinttypes>
+#else
 #  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #else
