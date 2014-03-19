require 'formula'

class Libswiften < Formula
  homepage 'http://swift.im/swiften'

  stable do
    url "http://swift.im/downloads/releases/swift-2.0/swift-2.0.tar.gz"
    sha1 "b04ba098fffb1edc2ef0215957371c249458f0be"

    # Patch to include lock from boost. Taken from
    # http://comments.gmane.org/gmane.linux.redhat.fedora.extras.cvs/957411
    patch :DATA
  end

  head do
    url 'git://swift.im/swift'
    depends_on 'lua' => :recommended
  end

  depends_on 'scons' => :build
  depends_on 'libidn'
  depends_on 'boost'

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]

    args = %W[
      -j #{ENV.make_jobs}
      V=1
      optimize=1 debug=0
      allow_warnings=1
      swiften_dll=1
      boost_includedir=#{boost.include}
      boost_libdir=#{boost.lib}
      libidn_includedir=#{libidn.include}
      libidn_libdir=#{libidn.lib}
      SWIFTEN_INSTALLDIR=#{prefix}
    ]

    if build.with? "lua"
      lua = Formula["lua"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}"
      args << "lua_libdir=#{lua.lib}"
    end

    args << prefix

    scons *args
    man1.install 'Swift/Packaging/Debian/debian/swiften-config.1' unless build.stable?
  end

  test do
    system "#{bin}/swiften-config"
  end
end

__END__
--- a/Swiften/EventLoop/EventLoop.cpp
+++ b/Swiften/EventLoop/EventLoop.cpp
@@ -12,6 +12,7 @@
 #include <cassert>
 
 #include <Swiften/Base/Log.h>
+#include <boost/thread/locks.hpp>
 
 
 namespace Swift {
