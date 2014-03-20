require 'formula'

class Djview4 < Formula
  homepage 'http://djvu.sourceforge.net/djview4.html'
  url 'https://downloads.sourceforge.net/project/djvu/DjView/4.8/djview-4.8.tar.gz'
  sha1 '266d207afb63a1ee63eed054190bf88888fda572'

  depends_on 'pkg-config' => :build
  depends_on 'djvulibre'
  depends_on 'qt'

  # Patch for Qt 4.8 compatibility. See:
  # https://build.opensuse.org/package/view_file?file=djview4-qt-4.8.patch&package=djvulibre-djview4&project=graphics&rev=8c40ae0f91469bb1af80f36c24516251
  # When updating this formula, check if this patch is still needed.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install 'src/djview.app'
  end
end


__END__
Index: djview-4.8/src/qdjvuwidget.cpp
===================================================================
--- djview-4.8.orig/src/qdjvuwidget.cpp
+++ djview-4.8/src/qdjvuwidget.cpp
@@ -153,7 +153,7 @@ all_numbers(const char *s)
 }
 
 template<class T> static inline void 
-swap(T& x, T& y)
+myswap(T& x, T& y)
 {
   T tmp;
   tmp = x;
@@ -173,11 +173,11 @@ ksmallest(T *v, int n, int k)
       /* Sort v[lo], v[m], v[hi] by insertion */
       m = (lo+hi)/2;
       if (v[lo]>v[m])
-        swap(v[lo],v[m]);
+        myswap(v[lo],v[m]);
       if (v[m]>v[hi]) {
-        swap(v[m],v[hi]);
+        myswap(v[m],v[hi]);
         if (v[lo]>v[m])
-          swap(v[lo],v[m]);
+          myswap(v[lo],v[m]);
       }
       /* Extract pivot, place sentinel */
       pivot = v[m];
@@ -191,7 +191,7 @@ ksmallest(T *v, int n, int k)
       do ++l; while (v[l]<pivot);
       do --h; while (v[h]>pivot);
       if (l < h) { 
-        swap(v[l],v[h]); 
+        myswap(v[l],v[h]); 
         goto loop; 
       }
       /* Finish up */
