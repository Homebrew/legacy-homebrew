require 'formula'

class Libplist < Formula
  url 'http://cgit.sukimashita.com/libplist.git/snapshot/libplist-1.6.tar.bz2'
  homepage 'http://cgit.sukimashita.com/libplist.git/'
  md5 '78fe4b8fb50e0bad267ffc6e77081cbe'

  depends_on 'cmake' => :build
  depends_on 'libxml2'

  def patches
    # Disable Python bindings.
    # Fix compile error with Clang, non-void function 'int node_insert()' should return a value.
    # Fix compile error with Clang, non-void function 'unsigned char *base64decode()' should return a value.
    # Fix compile error with Clang, non-void function 'unsigned char *base64decode()' should return a value.
    DATA
  end

  def install
    ENV.deparallelize # make fails on an 8-core Mac Pro

    system "cmake #{std_cmake_parameters} -DCMAKE_INSTALL_NAME_DIR=#{lib} ."
    system "make install"

    # Remove 'plutil', which duplicates the system-provided one. Leave the versioned one, though.
    rm (bin+'plutil')
  end
end

__END__
--- a/CMakeLists.txt	2011-06-24 18:00:48.000000000 -0700
+++ b/CMakeLists.txt	2012-01-26 13:58:02.000000000 -0800
@@ -17,7 +17,8 @@
 
 FIND_PACKAGE( LibXml2 REQUIRED )
 
-OPTION(ENABLE_PYTHON "Enable Python bindings (needs Swig)" ON)
+# Disabled Python Bindings
+#OPTION(ENABLE_PYTHON "Enable Python bindings (needs Swig)" ON)
 
 IF(ENABLE_PYTHON)
 	FIND_PACKAGE( SWIG )
--- a/libcnary/node.c	2011-06-24 18:00:48.000000000 -0700
+++ b/libcnary/node.c	2012-01-26 13:59:51.000000000 -0800
@@ -104,7 +104,7 @@
 
 int node_insert(node_t* parent, unsigned int index, node_t* child)
 {
-	if (!parent || !child) return;
+	if (!parent || !child) return 0;
 	child->isLeaf = TRUE;
 	child->isRoot = FALSE;
 	child->parent = parent;
--- a/src/base64.c	2011-06-24 18:00:48.000000000 -0700
+++ b/src/base64.c	2012-01-26 14:01:21.000000000 -0800
@@ -104,9 +104,9 @@
 
 unsigned char *base64decode(const char *buf, size_t *size)
 {
-	if (!buf) return;
+	if (!buf) return NULL;
 	size_t len = strlen(buf);
-	if (len <= 0) return;
+	if (len <= 0) return NULL;
 	unsigned char *outbuf = (unsigned char*)malloc((len/4)*3+3);
 
 	unsigned char *line;
