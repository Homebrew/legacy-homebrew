require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.3.1.tar.bz2'
  sha1 'b8c8e12e7163d7bacf9be0ea4aaa7b8c32e8c72c'

  bottle do
    revision 1
    sha1 'c31a3b3ede3835046c7d85eb8ae34c5b2a95666c' => :mountain_lion
    sha1 'bc8c4d71c2f26bd0606f6d5adfe3f0a6089e4581' => :lion
    sha1 '25d62121d1b07921cc49f618eb62d70cca087516' => :snow_leopard
  end

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
    # SConstruct merges in gssapi linkflags using scons's MergeFlags,
    # but that discards duplicate values - including the duplicate
    # values we want, like multiple -arch values for a universal build.
    # Passing 0 as the `unique` kwarg turns this behaviour off.
    inreplace 'SConstruct', 'unique=1', 'unique=0'

    ENV.universal_binary if build.universal?
    # scons ignores our compiler and flags unless explicitly passed
    args = %W[PREFIX=#{prefix} GSSAPI=/usr CC=#{ENV.cc}
              CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}]
    system "scons", *args
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
