require 'formula'

class Libswiften < Formula
  homepage 'http://swift.im/swiften'

  stable do
    url "http://swift.im/downloads/releases/swift-2.0/swift-2.0.tar.gz"
    sha1 "b04ba098fffb1edc2ef0215957371c249458f0be"

    # Patch to include lock from boost. Taken from
    # http://comments.gmane.org/gmane.linux.redhat.fedora.extras.cvs/957411
    patch :DATA

    # boost 1.56 compatibility
    # backported from upstream HEAD at
    # http://swift.im/git/swift/commit/?id=381b22fc365c27b9cd585f4b78f53ebc698d9f54 and
    # http://swift.im/git/swift/commit/?id=dc48cc3f34e3e229172202717520e77233c37ed7
    patch do
      url "https://gist.githubusercontent.com/tdsmith/278e6bdaa5502bc5a5f3/raw/0ca7358786751e1e6b5298f3831c407bdfb4b509/libswiften-boost-156.diff"
      sha1 "0244938c13fcfa0cfc27f81a4231fe951406e18c"
    end
  end

  bottle do
    revision 2
    sha1 "4304665d17ab82a8b27afa59b3ead18658b504b1" => :yosemite
    sha1 "5534c031b81bb3a031e74d87a7bcf74af721323f" => :mavericks
    sha1 "984038e792a28ef8834ce2d582972c148d0a6533" => :mountain_lion
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
