require 'formula'

class Gloox < Formula
  homepage 'http://camaya.net/gloox/'
  url 'http://camaya.net/download/gloox-1.0.9.tar.bz2'
  sha1 '0f408d25b8e8ba8dea69832b4c49ad02d74a6695'

  depends_on 'pkg-config' => :build

  # signed/unsigned conversion error, reported upstream:
  # http://bugs.camaya.net/ticket/?id=223
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-openssl",
                          "--without-gnutls",
                          "--with-zlib"
    system "make install"
  end
end

__END__
diff --git a/src/atomicrefcount.cpp b/src/atomicrefcount.cpp
index 58a3887..599a818 100644
--- a/src/atomicrefcount.cpp
+++ b/src/atomicrefcount.cpp
@@ -76,7 +76,7 @@ namespace gloox
 #if defined( _WIN32 ) && !defined( __SYMBIAN32__ )
       ::InterlockedExchange( (volatile LONG*)&m_count, (volatile LONG)0 );
 #elif defined( __APPLE__ )
-      OSAtomicAnd32Barrier( (int32_t)0, (volatile int32_t*)&m_count );
+      OSAtomicAnd32Barrier( (int32_t)0, (volatile uint32_t*)&m_count );
 #elif defined( HAVE_GCC_ATOMIC_BUILTINS )
       // Use the gcc intrinsic for atomic decrement if supported.
       __sync_fetch_and_and( &m_count, 0 );
