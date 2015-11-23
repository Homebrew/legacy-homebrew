class Geos < Formula
  desc "GEOS Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.4.2.tar.bz2"
  sha256 "15e8bfdf7e29087a957b56ac543ea9a80321481cef4d4f63a7b268953ad26c53"

  bottle do
    cellar :any
    revision 1
    sha256 "1cea75a400d62adc42aa891451fc16d89cf25c28594a0877245d9fd4670ea7d3" => :el_capitan
    sha256 "19f9d18d16d2924b6352707cfa2d3fb95e4edfaee9e602e83f1d2a0bf904bd91" => :yosemite
    sha256 "c38d4b37bbeae1cfa8a5e1f0aa55728597455eb8175d0fa174b247c1613695e7" => :mavericks
    sha256 "56b3f19c50c661db5f0dc98ab89f65052f2d5f6816eaaee1a6e13343a2f1ebbd" => :mountain_lion
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
