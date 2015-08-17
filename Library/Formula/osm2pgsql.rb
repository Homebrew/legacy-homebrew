class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.88.0.tar.gz"
  sha256 "45a6768e680a50c416fdae72cf4b26091644947a7ead44c8b7484f2276b2f119"

  bottle do
    sha256 "ca63b113b0b300a3bb6c0f8b1426185906806a6ba44ef13a68b01642824f6c0b" => :yosemite
    sha256 "063f2103411bcd38fe106296e844fd650d1f23dd889adbf919f5ffc290e3e6a5" => :mavericks
    sha256 "e4cd15756f097fa326e4887027931788a47070a9bc6e574b62eb05085c4dd7e0" => :mountain_lion
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

  # Apply a fix from the 0.88.x branch.
  # This will be in 0.88.1, so won't be needed when that's tagged
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/commit/cb449abc73e5ef076f1f8b6535b7d9641a1237f7.diff"
    sha256 "e0175a3b1de82b67d45adbd50b8194c16673e147401f25dcc22c1c0c8d44aec6"
  end

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
    # This is probably going to be a fatal issue for 0.89 and 0.90 on it, but
    # for now it can be worked around
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
