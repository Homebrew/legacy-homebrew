class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.10.6%20%28Stable%29/asio-1.10.6.tar.bz2"
  sha256 "e0d71c40a7b1f6c1334008fb279e7361b32a063e020efd21e40d9d8ff037195e"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    sha256 "fc6d65ff0bf8fe7c29bd02f2835640ff056346dd6133cceeacd81eec3b9fab75" => :el_capitan
    sha256 "ae6bda66bc2f4412ec3d1b32ba2b0ce02e238aa1b6219d8a9ccbf45523635800" => :yosemite
    sha256 "dd3067c8c0dfb9361f3f479686203506fb1d93586bf4ce16e91f782a01f8a371" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/asio/asio/1.11.0%20%28Development%29/asio-1.11.0.tar.bz2"
    sha256 "4f7e13260eea67412202638ec111cb5014f44bdebe96103279c60236874daa50"
  end

  option "with-boost-coroutine", "Use Boost.Coroutine to implement stackful coroutines"
  option :cxx11

  needs :cxx11 if build.cxx11?

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  if !build.cxx11? || build.with?("boost-coroutine")
    depends_on "boost"
  else
    depends_on "boost" => :optional
  end
  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?
    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-boost=#{(build.with?("boost") || build.with?("boost-coroutine") || !build.cxx11?) ? Formula["boost"].opt_include : "no"}
    ]
    args << "--enable-boost-coroutine" if build.with? "boost-coroutine"

    system "./configure", *args
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    httpserver = pkgshare/"examples/cpp03/http/server/http_server"
    pid = fork do
      exec httpserver, "127.0.0.1", "8080", "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:8080")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
