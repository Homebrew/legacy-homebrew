class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"

  head "https://github.com/zmap/zmap.git"

  bottle do
    cellar :any
    sha256 "829eb6548654b367cffb7eefeaf04ed41425e97c4f276043c0a6bba467a2d68e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "byacc" => :build
  depends_on "gmp"
  depends_on "libdnet"
  depends_on "json-c"
  depends_on "hiredis" => :optional
  depends_on "mongo-c" => :optional

  def install
    zmap_etc = "#{etc}/zmap"
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in" ], "/etc", etc

    args = std_cmake_args
    args << "-DENABLE_DEVELOPMENT=OFF"
    args << "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    args << "-DWITH_REDIS=ON" if build.with? "hiredis"
    args << "-DWITH_MONGO=ON" if build.with? "mongo-c"

    system "cmake", *args, "."
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
    assert_match /redis-csv/, `#{sbin}/zmap --list-output-modules` if build.with? "hiredis"
    assert_match /mongo/, `#{sbin}/zmap --list-output-modules` if build.with? "mongo-c"
  end
end
