class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 1

  bottle do
    cellar :any
    revision 3
    sha256 "04fe74a5874c032551caf96caaa2a774275f0407ebb60069f54ad5d1504ac1e3" => :yosemite
    sha256 "e95be3a6d986f77bbbbcaefc1b93777b8ae75e56aa84ea98810d8b62f272e81c" => :mavericks
    sha256 "7191f68b36d07b7e7a541449fa19ff98ff33f6826d12a2be0b9a164db4dd10f4" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libgeotiff"
  depends_on "libspatialite"
  depends_on "sqlite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
