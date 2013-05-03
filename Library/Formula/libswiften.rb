require 'formula'

class Libswiften < Formula
  homepage 'http://swift.im/swiften'
  url 'http://swift.im/downloads/releases/swift-1.0/swift-1.0.tar.gz'
  sha1 '9f3780e5dca32c0e0a0ad04e36a3f6214400a1ca'

  head "git://swift.im/swift"

  devel do
    url 'http://swift.im/downloads/releases/swift-2.0beta2/swift-2.0beta2.tar.gz'
    version '2.0beta2'
    sha1 '1ad1967f5d1928d1e7ce9a76877912b779e20c8f'
  end

  depends_on 'scons' => :build
  depends_on 'libidn'
  depends_on 'boost'

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
