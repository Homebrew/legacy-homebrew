class Libswiften < Formula
  homepage "http://swift.im/swiften"
  revision 1

  stable do
    url "http://swift.im/downloads/releases/swift-2.0/swift-2.0.tar.gz"
    sha256 "cbcdbe527dc4d112a38f3cdec5f1051d3beba0b97f8082f90debd04a5b45a41f"

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
    sha256 "d74397a47cfa62924490c7e32a16d3d9f40d1000760e9fac72616082ee26571a" => :yosemite
    sha256 "990b75f7bb7ca9acf8c83ea0b0f4cd16b5e155acc901bdf0cf75632da386e903" => :mavericks
  end

  head do
    url "git://swift.im/swift"
    depends_on "lua" => :recommended
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "openssl"

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
      openssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "lua"
      lua = Formula["lua"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}"
      args << "lua_libdir=#{lua.lib}"
    end

    args << prefix

    scons *args
    man1.install "Swift/Packaging/Debian/debian/swiften-config.1" unless build.stable?
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
