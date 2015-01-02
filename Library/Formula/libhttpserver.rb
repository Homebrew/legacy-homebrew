class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  head "https://github.com/etr/libhttpserver.git"

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
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    share.install "examples"
  end

  test do
    system ENV.cxx, "#{share}/examples/hello_world.cpp",
      "-o", "hello_world", "-lhttpserver", "-lcurl"
    pid = fork { system "./hello_world" }
    sleep 1 # grace time for server start
    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:8080/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
