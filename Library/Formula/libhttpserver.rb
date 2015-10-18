class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    revision 1
    sha256 "c0a9c40d4774fced64f48d12efbb2d2486c0562cf0a6b2975d3ff84e6d9630df" => :yosemite
    sha256 "49e910937e4afb7ceba0186e654102f4bfcc1b408503bfe6c8d8d23190bd5846" => :mavericks
    sha256 "fc8eba8eadd50d18aa3049c627fb91b3cefb7ad389fdf0fb86141a39b18fc5a7" => :mountain_lion
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
