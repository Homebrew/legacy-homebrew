class Geos < Formula
  homepage "http://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.4.2.tar.bz2"
  sha1 "b8aceab04dd09f4113864f2d12015231bb318e9a"

  bottle do
    cellar :any
    revision 1
    sha1 "b4143e5f3a051ffbd88286d204fac02db95956a7" => :yosemite
    sha1 "b052b96b44f00ceb6fdc94296c257fa93bf2b0c8" => :mavericks
    sha1 "d1e56b9aa2d39c087bfc4914515954e21b82350d" => :mountain_lion
  end

  option :universal
  option :cxx11

  fails_with :llvm

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
