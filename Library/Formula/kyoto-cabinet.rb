require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.74.tar.gz'
  sha1 '345358259ec4e58b5986b5d6fa8f82dfe2816c37'

  def patches
    p = []
    if ENV.compiler == :clang
      p << DATA
    end
    p
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end


__END__
diff --git a/kcthread.cc b/kcthread.cc
index d8ee932..6989fda 100644
--- a/kcthread.cc
+++ b/kcthread.cc
@@ -618,7 +618,7 @@ void SlottedMutex::unlock_all() {
 /**
  * Default constructor.
  */
-SpinLock::SpinLock() : opq_(NULL) {
+SpinLock::SpinLock() : opq_(0) {
 #if defined(_SYS_MSVC_) || defined(_SYS_MINGW_)
   _assert_(true);
 #elif _KC_GCCATOMIC
diff --git a/kcthread.h b/kcthread.h
index 7b77bbd..b2af047 100644
--- a/kcthread.h
+++ b/kcthread.h
@@ -239,8 +239,10 @@ class SpinLock {
   SpinLock(const SpinLock&);
   /** Dummy Operator to forbid the use. */
   SpinLock& operator =(const SpinLock&);
-  /** Opaque pointer. */
-  void* opq_;
+  /** Opaque pointer.
+   *  Clang doesn't generate code for atomic operations over pointers
+   */
+  int opq_;
 };
 
