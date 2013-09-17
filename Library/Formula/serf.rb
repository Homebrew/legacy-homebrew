require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.3.1.tar.bz2'
  sha1 'b8c8e12e7163d7bacf9be0ea4aaa7b8c32e8c72c'

  option :universal

  depends_on :libtool
  depends_on 'sqlite'
  depends_on 'scons' => :build

  # Patch to use only the major version of the dylib
  # Details: https://code.google.com/p/serf/source/detail?r=2161
  def patches
    { :p0 => DATA }
  end

  def install
    ENV.universal_binary if build.universal?
    system "scons", "PREFIX=#{prefix}"
    system "scons install"
  end
end

__END__
--- SConstruct~ 2013-08-15 11:13:20.000000000 +0200
+++ SConstruct 2013-09-17 22:52:50.000000000 +0200
@@ -401,7 +401,7 @@
   # to a path in the sandbox. The shared library install name (id) should be the
   # final targat path.
   install_shared_path = install_shared[0].abspath
-  target_install_shared_path = os.path.join(libdir, lib_shared[0].name)
+  target_install_shared_path = os.path.join(libdir, '%s.dylib' % LIBNAME)
   env.AddPostAction(install_shared, ('install_name_tool -id %s %s'
                                      % (target_install_shared_path,
                                         install_shared_path)))
