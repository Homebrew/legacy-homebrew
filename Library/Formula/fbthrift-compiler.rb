require "formula"

class FbthriftCompiler < Formula
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/41f744551ff26b852957e7ac4f01344b2bc761d8.tar.gz"
  version "11.0"
  sha1 "f3f705ae2685cc908d5e6fa73c45674ab7a39251"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "glog"
  depends_on "boost"
  depends_on "folly-minimal"

  def install
    cd "thrift"

    system "autoreconf", "-i"

    system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--without-python",  # it dumps random stuff places
        "--without-cpp"  # requires event libraries, numa, stuff we don't have

    system "make", "install"
  end

  patch :p1, :DATA
end

__END__
--- a/thrift/Makefile.am	2014-10-10 14:54:23.000000000 -0700
+++ b/thrift/Makefile.am	2014-10-10 14:54:27.000000000 -0700
@@ -19,7 +19,7 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = compiler lib
+SUBDIRS = compiler
 
 
 dist-hook:
--- a/thrift/compiler/Makefile.am	2014-10-10 14:39:43.000000000 -0700
+++ b/thrift/compiler/Makefile.am	2014-10-10 14:39:52.000000000 -0700
@@ -25,8 +25,6 @@
 LIBS =
 BUILT_SOURCES =
 
-SUBDIRS = . py
-
 bin_PROGRAMS = thrift1
 
 noinst_LTLIBRARIES = libparse.la libthriftcompilerbase.la
--- a/thrift/compiler/generate/t_rb_generator.cc	2014-10-10 14:36:02.000000000 -0700
+++ b/thrift/compiler/generate/t_rb_generator.cc	2014-10-10 14:37:03.000000000 -0700
@@ -312,7 +312,7 @@
     //Populate the hash
     int32_t value = (*c_iter)->get_value();
 
-    first ? first = false : f_types_ << ", ";
+    if (first) first = false; else f_types_ << ", ";
     f_types_ << value << " => \"" << capitalize((*c_iter)->get_name()) << "\"";
 
   }
@@ -323,7 +323,7 @@
   first = true;
   for (c_iter = constants.begin(); c_iter != constants.end(); ++c_iter) {
     // Populate the set
-    first ? first = false: f_types_ << ", ";
+    if (first) first = false; else f_types_ << ", ";
     f_types_ << capitalize((*c_iter)->get_name());
   }
   f_types_ << "]).freeze" << endl;
