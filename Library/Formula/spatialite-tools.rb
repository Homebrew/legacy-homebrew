require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url "http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.2.0.tar.gz"
  sha1 "de07042afa734b17c840318fa8772466f53f1831"

  bottle do
    cellar :any
    revision 2
    sha1 "a046197bb1056ed281f8ce1da6adf09f1b8dbc2e" => :yosemite
    sha1 "13509dbd47966b057ddd592dfdacc2c241f02193" => :mavericks
    sha1 "47880ebb7714b3c5f1693f5a29f51096d46233d6" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libspatialite'
  depends_on 'readosm'

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append 'LDFLAGS', '-liconv'
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_lib}"
    ENV.append 'CFLAGS', "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spatialite --version"
  end
end
