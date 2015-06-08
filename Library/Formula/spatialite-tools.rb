class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url "http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.2.0.tar.gz"
  sha1 "de07042afa734b17c840318fa8772466f53f1831"
  revision 1

  bottle do
    cellar :any
    sha256 "29e85fb2516194c888c1c743847b0a8d2393adb66799546689df3ab18506b50b" => :yosemite
    sha256 "5064182ba11aef660e964ce80b7f81da64e7c97f964456eee24aa85e82f88246" => :mavericks
    sha256 "fdf30d2303fe335c581d509dfb72e616b63b02507cc1992655f7aa771096c270" => :mountain_lion
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
