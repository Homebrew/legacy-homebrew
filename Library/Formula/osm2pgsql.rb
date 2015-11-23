class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.88.1.tar.gz"
  sha256 "08ec33c833768dec9856f537bbf4416ad45837ee0851eeeab0081c7bbed3449e"

  bottle do
    sha256 "367d2eb028e4c9e90d9c9806ced4c4663088d7d9bd53779b4fbcc851d6a1628a" => :el_capitan
    sha256 "007bc7c7cb4a662ada92f7654209be84c95ee3b0f6636e41b1a3bd9e5c2461af" => :yosemite
    sha256 "57b8e4e8440802ea6de3ae4cdb1a687c2c4bfcf8b20b31300a9a1854a6b13ad7" => :mavericks
    sha256 "0bc4e07736a3ec197e82934ae570e87d22b78564589182aafa33b3a30af3d1df" => :mountain_lion
  end

  depends_on :postgresql
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :recommended
  depends_on "lua" => :recommended

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-proj=#{Formula["proj"].opt_prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-zlib=/usr",
      "--with-bzip2=/usr"
    ]
    puts args
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula["protobuf-c"].opt_prefix}"
    end
    # Mountain Lion has some problems with C++11.
    # This is probably going to be a fatal issue for 0.89 and 0.90, but
    # for now it can be worked around.
    args << "--without-cxx11" if MacOS.version < :mavericks
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}",
      shell_output("#{bin}/osm2pgsql -h 2>&1", 1)
  end
end
