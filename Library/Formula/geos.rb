class Geos < Formula
  desc "GEOS Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.4.2.tar.bz2"
  sha256 "15e8bfdf7e29087a957b56ac543ea9a80321481cef4d4f63a7b268953ad26c53"

  bottle do
    cellar :any
    revision 1
    sha256 "1cea75a400d62adc42aa891451fc16d89cf25c28594a0877245d9fd4670ea7d3" => :el_capitan
    sha1 "b4143e5f3a051ffbd88286d204fac02db95956a7" => :yosemite
    sha1 "b052b96b44f00ceb6fdc94296c257fa93bf2b0c8" => :mavericks
    sha1 "d1e56b9aa2d39c087bfc4914515954e21b82350d" => :mountain_lion
  end

  option :universal
  option :cxx11
  option "with-php", "Build the PHP extension"
  option "with-python", "Build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  fails_with :llvm

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]

    args << "--enable-php" if build.with?("php")
    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
