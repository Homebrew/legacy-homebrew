require 'formula'

class Qca < Formula
  homepage 'http://delta.affinix.com/qca/'
  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.3.tar.bz2'
  sha1 '9c868b05b81dce172c41b813de4de68554154c60'

  depends_on 'qt'

  # Fix for clang adhering strictly to standard, see http://clang.llvm.org/compatibility.html#dep_lookup_bases
  # fixed upstream: http://quickgit.kde.org/?p=qca.git&a=commitdiff&h=312b693de046380d9ca4230fb0bb3a6ed2569ab3
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-tests"
    system "make install"
  end
end

__END__
--- a/src/botantools/botan/botan/secmem.h
+++ b/src/botantools/botan/botan/secmem.h
@@ -191,15 +191,15 @@
    {
    public:
       MemoryVector<T>& operator=(const MemoryRegion<T>& in)
-         { if(this != &in) set(in); return (*this); }
+         { if(this != &in) this->set(in); return (*this); }
 
       MemoryVector(u32bit n = 0) { MemoryRegion<T>::init(false, n); }
       MemoryVector(const T in[], u32bit n)
-         { MemoryRegion<T>::init(false); set(in, n); }
+         { MemoryRegion<T>::init(false); this->set(in, n); }
       MemoryVector(const MemoryRegion<T>& in)
-         { MemoryRegion<T>::init(false); set(in); }
+         { MemoryRegion<T>::init(false); this->set(in); }
       MemoryVector(const MemoryRegion<T>& in1, const MemoryRegion<T>& in2)
-         { MemoryRegion<T>::init(false); set(in1); append(in2); }
+         { MemoryRegion<T>::init(false); this->set(in1); append(in2); }
    };
 
 /*************************************************
@@ -210,15 +210,15 @@
    {
    public:
       SecureVector<T>& operator=(const MemoryRegion<T>& in)
-         { if(this != &in) set(in); return (*this); }
+         { if(this != &in) this->set(in); return (*this); }
 
       SecureVector(u32bit n = 0) { MemoryRegion<T>::init(true, n); }
       SecureVector(const T in[], u32bit n)
-         { MemoryRegion<T>::init(true); set(in, n); }
+         { MemoryRegion<T>::init(true); this->set(in, n); }
       SecureVector(const MemoryRegion<T>& in)
-         { MemoryRegion<T>::init(true); set(in); }
+         { MemoryRegion<T>::init(true); this->set(in); }
       SecureVector(const MemoryRegion<T>& in1, const MemoryRegion<T>& in2)
-         { MemoryRegion<T>::init(true); set(in1); append(in2); }
+         { MemoryRegion<T>::init(true); this->set(in1); append(in2); }
    };
 
 /*************************************************
@@ -229,14 +229,14 @@
    {
    public:
       SecureBuffer<T,L>& operator=(const SecureBuffer<T,L>& in)
-         { if(this != &in) set(in); return (*this); }
+         { if(this != &in) this->set(in); return (*this); }
 
       SecureBuffer() { MemoryRegion<T>::init(true, L); }
       SecureBuffer(const T in[], u32bit n)
          { MemoryRegion<T>::init(true, L); copy(in, n); }
    private:
       SecureBuffer<T, L>& operator=(const MemoryRegion<T>& in)
-         { if(this != &in) set(in); return (*this); }
+         { if(this != &in) this->set(in); return (*this); }
    };
 
 }
