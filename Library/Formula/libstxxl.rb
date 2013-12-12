require 'formula'

class Libstxxl < Formula
  homepage 'http://stxxl.sourceforge.net/'
  url 'https://github.com/stxxl/stxxl/archive/1.4.0.tar.gz'
  sha1 '57230314bf136e477d6d96d0f68030af1f652278'

  # issue has been rectified in upstream and future 1.4.0 release
  depends_on 'cmake' => :build

  # compile fixes for 10.7 and 10.8, submitted upstream
  # https://github.com/stxxl/stxxl/pull/2
  def patches; DATA; end if MacOS.version < :mavericks

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release"
      system "make install"
    end
  end
end

__END__
diff --git a/include/stxxl/bits/compat/hash_map.h b/include/stxxl/bits/compat/hash_map.h
index d955b31..8c5c365 100644
--- a/include/stxxl/bits/compat/hash_map.h
+++ b/include/stxxl/bits/compat/hash_map.h
@@ -19,7 +19,7 @@
 #include <stxxl/bits/config.h>
 #include <stxxl/bits/namespace.h>

-#if defined(__GXX_EXPERIMENTAL_CXX0X__)
+#if __cplusplus >= 201103L
  #include <unordered_map>
 #elif STXXL_MSVC
  #include <hash_map>
@@ -34,7 +34,7 @@ STXXL_BEGIN_NAMESPACE

 template <class _Tp>
 struct compat_hash {
-#if defined(__GXX_EXPERIMENTAL_CXX0X__)
+#if __cplusplus >= 201103L
     typedef std::hash<_Tp> result;
 #elif STXXL_MSVC
     typedef stdext::hash_compare<_Tp> result;
@@ -48,7 +48,7 @@ struct compat_hash {

 template <class _Key, class _Tp, class _Hash = typename compat_hash<_Key>::result>
 struct compat_hash_map {
-#if defined(__GXX_EXPERIMENTAL_CXX0X__)
+#if __cplusplus >= 201103L
     typedef std::unordered_map<_Key, _Tp, _Hash> result;
 #elif STXXL_MSVC
     typedef stdext::hash_map<_Key, _Tp, _Hash> result;
diff --git a/include/stxxl/bits/compat/type_traits.h b/include/stxxl/bits/compat/type_traits.h
index 08a519e..8ec51be 100644
--- a/include/stxxl/bits/compat/type_traits.h
+++ b/include/stxxl/bits/compat/type_traits.h
@@ -16,7 +16,7 @@
 #include <stxxl/bits/config.h>
 #include <stxxl/bits/namespace.h>

-#if defined(__GXX_EXPERIMENTAL_CXX0X__)
+#if __cplusplus >= 201103L
-#include <type_traits>
+#include <tr1/type_traits>
 #elif defined(__GNUG__) && (__GNUC__ >= 4)
 #include <tr1/type_traits>
@@ -29,7 +29,7 @@ STXXL_BEGIN_NAMESPACE

 namespace compat {

-#if defined(__GXX_EXPERIMENTAL_CXX0X__)
+#if __cplusplus >= 201103L
 using std::remove_const;
 #elif defined(__GNUG__) && (__GNUC__ >= 4)
 using std::tr1::remove_const;
diff --git a/include/stxxl/bits/compat/unique_ptr.h b/include/stxxl/bits/compat/unique_ptr.h
index 7554a0a..e1ecaf0 100644
--- a/include/stxxl/bits/compat/unique_ptr.h
+++ b/include/stxxl/bits/compat/unique_ptr.h
@@ -24,7 +24,7 @@ STXXL_BEGIN_NAMESPACE

 template <class _Tp>
 struct compat_unique_ptr {
-#if defined(__GXX_EXPERIMENTAL_CXX0X__) && ((__GNUC__ * 10000 + __GNUC_MINOR__ * 100) >= 40400)
+#if __cplusplus >= 201103L  && ((__GNUC__ * 10000 + __GNUC_MINOR__ * 100) >= 40400)
     typedef std::unique_ptr<_Tp> result;
 #else
     // auto_ptr is inherently broken and is deprecated by unique_ptr in c++0x
