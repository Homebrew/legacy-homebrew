class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"

  head "https://github.com/zmap/zmap.git"

  bottle do
    cellar :any
    sha1 "67ee1c3239a4109088a7b5f9d9db4884640c1920" => :mavericks
    sha1 "3d780dc9a1125d96294d7071b1cdc359ccf4f302" => :mountain_lion
    sha1 "b0482d7fedc3063f7218997f4ecdcb93043f898a" => :lion
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
