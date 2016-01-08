class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  head "https://github.com/etr/libhttpserver.git"
  revision 1

  bottle do
    cellar :any
    sha256 "ee7c3025c9678a97f326c69a8a9faa4963eefc8f972c78096b3f237cf7368945" => :el_capitan
    sha256 "d6ec883a992e348d69b90c37b3c0f1ab2329cc9bae3cb8d1f1db7d112ca65200" => :yosemite
    sha256 "aec3bba3f8db0cb1e9fd99d66aafb1f2ed399197f11af43654f911205b62d5ee" => :mavericks
  end

  option :universal

  depends_on "libmicrohttpd"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp",
      "-o", "hello_world", "-lhttpserver", "-lcurl"
    pid = fork { exec "./hello_world" }
    sleep 1 # grace time for server start
    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:8080/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
