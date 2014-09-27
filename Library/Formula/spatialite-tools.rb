require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url "http://www.gaia-gis.it/gaia-sins/spatialite-tools-4.2.0.tar.gz"
  sha1 "de07042afa734b17c840318fa8772466f53f1831"

  bottle do
    cellar :any
    revision 1
    sha1 "88327209bbaa7771ab7229776e212e25b6c903d9" => :mavericks
    sha1 "a5080c103bcc55bb670bbfbd3f0f6a3503f1bc4d" => :mountain_lion
    sha1 "bd3ea917dfdeee795af8119303baf318a395a411" => :lion
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
