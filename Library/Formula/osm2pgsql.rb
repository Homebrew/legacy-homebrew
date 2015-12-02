class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.88.1.tar.gz"
  sha256 "08ec33c833768dec9856f537bbf4416ad45837ee0851eeeab0081c7bbed3449e"
  revision 1

  bottle do
    sha256 "7f388ee56a6bf0d685434823d238ebbd8ca01e74320c862892e61e21b24b9a08" => :el_capitan
    sha256 "17c80db14f36b5831b03a4026d3d970ae29c782344c11c5fbec9cf19716a3e6d" => :yosemite
    sha256 "ef2655f802ca66c3cb137d80be9fcbe9fae64743c0f67c0b0e3944faddbc8913" => :mavericks
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
