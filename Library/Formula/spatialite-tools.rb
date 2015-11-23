class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.3.0.tar.gz"
  sha256 "f739859bc04f38735591be2f75009b98a2359033675ae310dffc3114a17ccf89"

  bottle do
    cellar :any
    sha256 "dd0b769d4ff1929b0788a80dfcad842fdc92be212efc39d4eb7e20f9251d1f86" => :el_capitan
    sha256 "727464d0362152f24aa75ffb6ad60e7454394a75fbb2a07ba9e1436a6d7ac8dc" => :yosemite
    sha256 "a6bd943c2d1bfed507c8b53aa1d2d8e00ea129ab3da6095b90eebf64c6e3b381" => :mavericks
    sha256 "6dc0983b61eabf074d24acd3bcdc7df675a1abd7caf5069eb4598a81881049d4" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv"
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
