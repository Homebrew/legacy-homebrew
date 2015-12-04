class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"

  head "https://github.com/zmap/zmap.git"

  bottle do
    cellar :any
    sha256 "4bec1849985c6754abe0facfb20a0d847470bc6f66623e98104176b45932d42a" => :yosemite
    sha256 "e543e77553615624b232d1feac4dbe20c3eb24d0403f6e679c9a704ce21da33b" => :mavericks
    sha256 "85fff9d320b123e6637980f4777e89b5fb7957dd5c75154d2c8aa2f3505aa471" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "byacc" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libdnet"
  depends_on "json-c"
  depends_on "hiredis" => :optional
  depends_on "mongo-c" => :optional

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in" ], "/etc", etc

    args = std_cmake_args
    args << "-DENABLE_DEVELOPMENT=OFF"
    args << "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    args << "-DWITH_REDIS=ON" if build.with? "hiredis"
    args << "-DWITH_MONGO=ON" if build.with? "mongo-c"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
    assert_match /redis-csv/, `#{sbin}/zmap --list-output-modules` if build.with? "hiredis"
    assert_match /mongo/, `#{sbin}/zmap --list-output-modules` if build.with? "mongo-c"
  end
end
