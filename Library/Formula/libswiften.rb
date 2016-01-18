class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  revision 2

  stable do
    url "https://swift.im/downloads/releases/swift-2.0/swift-2.0.tar.gz"
    sha256 "cbcdbe527dc4d112a38f3cdec5f1051d3beba0b97f8082f90debd04a5b45a41f"

    # Patch to include lock from boost. Taken from
    # http://comments.gmane.org/gmane.linux.redhat.fedora.extras.cvs/957411
    patch :DATA

    # boost 1.56 compatibility
    # backported from upstream HEAD at
    # https://swift.im/git/swift/commit/?id=381b22fc365c27b9cd585f4b78f53ebc698d9f54 and
    # https://swift.im/git/swift/commit/?id=dc48cc3f34e3e229172202717520e77233c37ed7
    patch do
      url "https://gist.githubusercontent.com/tdsmith/278e6bdaa5502bc5a5f3/raw/0ca7358786751e1e6b5298f3831c407bdfb4b509/libswiften-boost-156.diff"
      sha256 "70f0263d9cd1d8be87c2a034c5b9046f74f20c7bf38e6ac7a1d09f87acc42436"
    end
  end

  bottle do
    sha256 "b6f7b332a5b37a0923ef0dbd5a31575637971c269f3b0361ce3f246cd5b7234f" => :el_capitan
    sha256 "9c261c398d124474d4d574caebf3de90d2fed5d6d5efbd9dd85285e259225e4d" => :yosemite
    sha256 "057cf8764fa8688615b8e925519c1155b1bdb8ba3c3c8dc18a38a060e4847b33" => :mavericks
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
