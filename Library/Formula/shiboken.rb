require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://download.qt-project.org/official_releases/pyside/shiboken-1.2.1.tar.bz2'
  mirror 'https://distfiles.macports.org/py-shiboken/shiboken-1.2.1.tar.bz2'
  sha1 'f310ac163f3407109051ccebfd192bc9620e9124'

  head 'git://gitorious.org/pyside/shiboken.git'

  depends_on 'cmake' => :build
  depends_on 'qt'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  # This fixes issues with libc++ and its lack of the tr1 namespace.
  # Upstream ticket: https://bugreports.qt-project.org/browse/PYSIDE-200
  # Patch is currently under code review at: https://codereview.qt-project.org/#change,69324
  patch :DATA

  def install
    # As of 1.1.1 the install fails unless you do an out of tree build and put
    # the source dir last in the args.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        # if not System Python
        python_framework = "#{Formula[python].prefix}/Frameworks/Python.framework/Versions/#{version}"
        if version.to_s[0,1] == "2" && Formula["python"].installed?
          args << "-DPYTHON_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
        elsif version.to_s[0,1] == "3"
          args << "-DPYTHON3_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON3_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
          args << "-DUSE_PYTHON3:BOOL=ON"
        end
        args << ".."
        system "cmake", *args
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import shiboken"
    end
  end
end

__END__
diff --git a/ext/sparsehash/google/sparsehash/sparseconfig.h b/ext/sparsehash/google/sparsehash/sparseconfig.h
index 44a4dda..5073639 100644
--- a/ext/sparsehash/google/sparsehash/sparseconfig.h
+++ b/ext/sparsehash/google/sparsehash/sparseconfig.h
@@ -13,6 +13,16 @@
     #define HASH_NAMESPACE stdext
     /* The system-provided hash function including the namespace. */
     #define SPARSEHASH_HASH  HASH_NAMESPACE::hash_compare
+/* libc++ does not implement the tr1 namespce, instead the
+ * equivalient functionality is placed in namespace std,
+ * so use when it targeting such systems (OS X 10.7 onwards) */
+#elif defined(_LIBCPP_VERSION)
+    /* the location of the header defining hash functions */
+    #define HASH_FUN_H <functional>
+    /* the namespace of the hash<> function */
+    #define HASH_NAMESPACE std
+    /* The system-provided hash function including the namespace. */
+    #define SPARSEHASH_HASH HASH_NAMESPACE::hash
 #else
     /* the location of the header defining hash functions */
     #define HASH_FUN_H <tr1/functional>
