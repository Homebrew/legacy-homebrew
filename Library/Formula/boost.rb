require 'formula'

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.48.0/boost_1_48_0.tar.bz2'
  md5 'd1e9a7a7f532bb031a3c175d86688d95'
  head 'http://svn.boost.org/svn/boost/trunk', :using => :svn

  # Bottle built on 10.7.2 using XCode 4.2
  bottle do
    url 'https://downloads.sourceforge.net/project/machomebrew/Bottles/boost-1.48.0-bottle.tar.gz'
    sha1 'c7871ddd020a24e3b0cfd3c9a352a1210b68b372'
  end

  def patches
    # https://svn.boost.org/trac/boost/ticket/6131
    #
    # #define foreach BOOST_FOREACH causes weird compile error in certain
    # circumstances with boost 1.48
    #
    # #define foreach BOOST_FOREACH causes compile error "'boost::BOOST_FOREACH'
    # has not been declared" on its line if it appears after #include
    # <boost/foreach.hpp> and before certain other boost headers.
    DATA unless ARGV.build_head?
  end

  def options
    [
      ["--with-mpi", "Enable MPI support"],
      ["--universal", "Build universal binaries"],
      ["--without-python", "Build without Python"]
    ]
  end

  # Both clang and llvm-gcc provided by XCode 4.1 compile Boost 1.47.0 properly.
  # Moreover, Apple LLVM compiler 2.1 is now among primary test compilers.
  if MacOS.xcode_version < "4.1"
    fails_with_llvm "LLVM-GCC causes errors with dropped arguments to functions when linking with boost"
  end

  def install
    if ARGV.build_universal? and not ARGV.include? "--without-python"
      archs = archs_for_command("python")
      unless archs.universal?
        opoo "A universal build was requested, but Python is not a universal build"
        puts "Boost compiles against the Python it finds in the path; if this Python"
        puts "is not a universal build then linking will likely fail."
      end
    end

    # Adjust the name the libs are installed under to include the path to the
    # Homebrew lib directory so executables will work when installed to a
    # non-/usr/local location.
    #
    # otool -L `which mkvmerge`
    # /usr/local/bin/mkvmerge:
    #   libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #
    # becomes:
    #
    # /usr/local/bin/mkvmerge:
    #   /usr/local/lib/libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/lib/libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV['CXX']} ;\n"
      file.write "using mpi ;\n" if ARGV.include? '--with-mpi'
    end

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi",
            "install"]

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if ARGV.include? "--universal"
    args << "--without-python" if ARGV.include? "--without-python"

    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "./bjam", *args
  end
end
__END__
Index: /boost/foreach_fwd.hpp
===================================================================
--- /boost/foreach_fwd.hpp  (revision 62661)
+++ /boost/foreach_fwd.hpp  (revision 75540)
@@ -15,4 +15,6 @@
 #define BOOST_FOREACH_FWD_HPP

+#include <utility> // for std::pair
+
 // This must be at global scope, hence the uglified name
 enum boost_foreach_argument_dependent_lookup_hack
@@ -26,4 +28,7 @@
 namespace foreach
 {
+    template<typename T>
+    std::pair<T, T> in_range(T begin, T end);
+
     ///////////////////////////////////////////////////////////////////////////////
     // boost::foreach::tag
@@ -47,4 +52,22 @@
 } // namespace foreach

+// Workaround for unfortunate https://svn.boost.org/trac/boost/ticket/6131
+namespace BOOST_FOREACH
+{
+    using foreach::in_range;
+    using foreach::tag;
+
+    template<typename T>
+    struct is_lightweight_proxy
+      : foreach::is_lightweight_proxy<T>
+    {};
+
+    template<typename T>
+    struct is_noncopyable
+      : foreach::is_noncopyable<T>
+    {};
+
+} // namespace BOOST_FOREACH
+
 } // namespace boost

Index: /boost/foreach.hpp
===================================================================
--- /boost/foreach.hpp  (revision 75077)
+++ /boost/foreach.hpp  (revision 75540)
@@ -166,5 +166,5 @@
 //   at the global namespace for your type.
 template<typename T>
-inline boost::foreach::is_lightweight_proxy<T> *
+inline boost::BOOST_FOREACH::is_lightweight_proxy<T> *
 boost_foreach_is_lightweight_proxy(T *&, BOOST_FOREACH_TAG_DEFAULT) { return 0; }

@@ -191,5 +191,5 @@
 //   at the global namespace for your type.
 template<typename T>
-inline boost::foreach::is_noncopyable<T> *
+inline boost::BOOST_FOREACH::is_noncopyable<T> *
 boost_foreach_is_noncopyable(T *&, BOOST_FOREACH_TAG_DEFAULT) { return 0; }

