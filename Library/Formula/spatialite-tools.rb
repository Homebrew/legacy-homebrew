require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url "http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.2.0.tar.gz"
  sha1 "de07042afa734b17c840318fa8772466f53f1831"

  bottle do
    cellar :any
    revision 3
    sha1 "4598206e95a93f76ec379b928e539ab037db3927" => :yosemite
    sha1 "67d0c0113b0723b3cab1e893ac57668f75d7ad7c" => :mavericks
    sha1 "ad61069c865b7c11fa04b0fcbcf105a3f95edacd" => :mountain_lion
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
