class Osm2pgsql < Formula
  desc "Convert OpenStreetMap data to postGIS-enabled PostgreSQL db"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.88.0.tar.gz"
  sha256 "45a6768e680a50c416fdae72cf4b26091644947a7ead44c8b7484f2276b2f119"
  revision 1

  bottle do
    sha256 "6b1bc9ca723e3c8bf23c9bb5704fa99205a1037085d408102050da03ac703a5c" => :yosemite
    sha256 "2835cacfecdbca3f00255cfc5b95107d54fa640e1eb1ca728520f4c252da983f" => :mavericks
    sha256 "63c279201caf3f6c0359dbe27eb1c2e2a144cdf0cfd130ef6d218b95a9d009fe" => :mountain_lion
  end

  depends_on :postgresql
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-proj=#{Formula["proj"].opt_prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-zlib=/usr",
      "--with-bzip2=/usr",
      # Related to the patch, remove this line when upgrading
      "--without-lockfree",
    ]
    puts args
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula["protobuf-c"].opt_prefix}"
    end
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
