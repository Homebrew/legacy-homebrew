require 'formula'

class Librasterlite < Formula
  homepage 'https://www.gaia-gis.it/fossil/librasterlite/index'
  url 'http://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz'
  sha1 '87f0abab90600db64a7d468343163e760769f0c7'
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "bc1d50a1363cd3f6827fa512ae5412ace413a1b9" => :yosemite
    sha1 "86cde48b326df5915f2c2efd1b0d335f79b7bcbd" => :mavericks
    sha1 "74b25b3d5ddbeeb8510026a7a8a918193600b9fc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libgeotiff"
  depends_on "libspatialite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula["sqlite"]
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
