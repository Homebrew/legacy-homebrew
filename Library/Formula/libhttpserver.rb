class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "71463901b58cbb162cabbf81086825314369549247a3fb2f5442eefa6b325659" => :yosemite
    sha256 "bfe56ef562125166dad3629672fc942082e5a8a2aaab491a0e39fc2ddf3dfbb1" => :mavericks
    sha256 "6c39a1be1de1a374313414acf8bea92c5afdedd34622a85ca82ba4fbbb224bd8" => :mountain_lion
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
