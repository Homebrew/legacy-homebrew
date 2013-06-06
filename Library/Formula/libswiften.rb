require 'formula'

class Libswiften < Formula
  homepage 'http://swift.im/swiften'
  url 'http://swift.im/downloads/releases/swift-2.0/swift-2.0.tar.gz'
  sha1 'b04ba098fffb1edc2ef0215957371c249458f0be'

  head "git://swift.im/swift"

  depends_on :python => :build
  depends_on 'scons' => :build
  depends_on 'libidn'
  depends_on 'boost'

  # Patch to include lock from boost. Taken from
  # http://comments.gmane.org/gmane.linux.redhat.fedora.extras.cvs/957411
  def patches; DATA; end

  def install
    boost = Formula.factory("boost")
    libidn = Formula.factory("libidn")

    system "scons",
        "-j #{ENV.make_jobs}",
        "V=1", "optimize=1",
        "debug=0",
        "allow_warnings=1",
        "swiften_dll=1",
        "boost_includedir=#{boost.include}",
        "boost_libdir=#{boost.lib}",
        "libidn_includedir=#{libidn.include}",
        "libidn_libdir=#{libidn.lib}",
        "SWIFTEN_INSTALLDIR=#{prefix}",
        prefix
    man1.install 'Swift/Packaging/Debian/debian/swiften-config.1' unless build.stable?
  end

  def test
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
