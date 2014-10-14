require 'formula'

class Librasterlite < Formula
  homepage 'https://www.gaia-gis.it/fossil/librasterlite/index'
  url 'http://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz'
  sha1 '87f0abab90600db64a7d468343163e760769f0c7'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "7dcd4ea33188c1f480ccd79ea3b219d0e6f15d88" => :mavericks
    sha1 "b88fb8974a1040cb92ccb3ba625c9ca32d831d72" => :mountain_lion
    sha1 "fb8da1e10de9cde87295c2cac6d7de4732c77f20" => :lion
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
