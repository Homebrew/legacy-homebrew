require 'formula'

class Dgtal < Formula
  homepage 'http://libdgtal.org'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.8.0-Source.tar.gz'
  sha1 '61c8d4b7db2c31daed9456ab65b0158d0a0e1bab'
  head 'https://github.com/DGtal-team/DGtal.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp' => :optional
  depends_on 'cairo' => :optional
  depends_on 'libqglviewer' => :optional
  depends_on 'graphicsmagick' => :optional
  depends_on 'eigen' => :optional
  depends_on "cgal" => [:optional, "with-eigen3"]

  deprecated_option 'with-magick' => 'with-graphicsmagick'
  deprecated_option 'with-qglviewer' => 'with-libqglviewer'

  # Allows to compile with boost 1.57: https://github.com/DGtal-team/DGtal/issues/936
  patch :DATA
  
  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DDGTAL_BUILD_TESTING=OFF"

    args << "-DWITH_GMP=true" if build.with? 'gmp'
    args << "-DWITH_CAIRO=true" if build.with? 'cairo'
    args << "-DWITH_QGLVIEWER=true" if build.with? 'libqglviewer'
    args << "-DWITH_EIGEN=true" if build.with? 'eigen'
    args << "-DWITH_MAGICK=true" if build.with? 'graphicsmagick'
    args << "-DWITH_EIGEN=true -DWITH_GMP=true -DWITH_CGAL=true" if build.with? 'cgal'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

__END__
diff --git a/src/DGtal/base/Common.h b/src/DGtal/base/Common.h
index 0a524f6..bcd20a3 100644
--- a/src/DGtal/base/Common.h
+++ b/src/DGtal/base/Common.h
@@ -51,6 +51,7 @@
 #include <iostream>
 #include <exception>
 #include <algorithm>
+#include <boost/version.hpp>
 #include <boost/concept_check.hpp>
 #include <boost/static_assert.hpp>
 #include <boost/concept/assert.hpp>
diff --git a/src/DGtal/base/IteratorCirculatorTraits.h b/src/DGtal/base/IteratorCirculatorTraits.h
index 729d608..9858f38 100644
--- a/src/DGtal/base/IteratorCirculatorTraits.h
+++ b/src/DGtal/base/IteratorCirculatorTraits.h
@@ -246,20 +246,39 @@ struct ToDGtalCategory<boost::random_access_traversal_tag> {
     typedef  RandomAccessCategory Category;
 };
 
-template <>
-struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::forward_traversal_tag> > {
-    typedef  ForwardCategory Category;
-};
 
-template <>
-struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::bidirectional_traversal_tag> > {
+
+
+#if (((BOOST_VERSION /100000)==1) && ((BOOST_VERSION / 100 % 1000 )<57))
+  template <>
+  struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::forward_traversal_tag> > {
+    typedef  ForwardCategory Category;
+  };
+  template <>
+  struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::bidirectional_traversal_tag> > {
     typedef  BidirectionalCategory Category;
-};
+  };
 
-template <>
-struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::random_access_traversal_tag> > {
+  template <>
+  struct ToDGtalCategory<boost::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::random_access_traversal_tag> > {
     typedef  RandomAccessCategory Category;
-};
+  };
+#else
+  template <>
+  struct ToDGtalCategory<boost::iterators::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::forward_traversal_tag> > {
+    typedef  ForwardCategory Category;
+  };
+  template <>
+  struct ToDGtalCategory<boost::iterators::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::bidirectional_traversal_tag> > {
+    typedef  BidirectionalCategory Category;
+  };
+  
+  template <>
+  struct ToDGtalCategory<boost::iterators::detail::iterator_category_with_traversal<std::input_iterator_tag,boost::random_access_traversal_tag> > {
+    typedef  RandomAccessCategory Category;
+  };
+#endif
+
