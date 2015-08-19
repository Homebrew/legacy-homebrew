class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "http://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.1.tar.gz"
  sha256 "acfc76ee19b3d41bb9c7e8b780ca55d413893a96c09f3b27bdb9b2573b41fd23"
  revision 1

  bottle do
    sha256 "cc50df08d046654c4dcdb71dca892522ddbe7f4d08bf76db875843b5278f8c72" => :yosemite
    sha256 "a06efe08c1bd6a4c8c2e17d8081bafb2c6fd7e6a46083d7ff3228f98d3dca7e3" => :mavericks
    sha256 "07efe6adec3e35b7e3d05af18e62a407041d84a96fa91a64757aa1e0b4696fd6" => :mountain_lion
  end

  depends_on "libtiff"
  depends_on "lzlib"
  depends_on "jpeg"
  depends_on "proj"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            "--with-libtiff=#{HOMEBREW_PREFIX}",
            "--with-zlib=#{HOMEBREW_PREFIX}",
            "--with-jpeg=#{HOMEBREW_PREFIX}"]
    system "./configure", *args
    system "make" # Separate steps or install fails
    system "make", "install"
  end
end
