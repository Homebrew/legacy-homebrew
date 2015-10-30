class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.0.tar.gz"
  sha256 "746fd55c4ae31b8c2142c9a413a4dacfb47e3db970ec7ea5bc4053525f9c12e0"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    sha256 "64b90de816220a7e02a627678fa588468359ba61a738206946d2eac9c68ba196" => :el_capitan
    sha256 "5c47d4104804d83b950ccf37ca7e0b39c9b9103365f92bd618f8e1f016b455cb" => :yosemite
    sha256 "6a564800bfb635852693969f87d0c3c95980bfb0a054f187e28b8414567a9bf0" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cmake" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "check", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <libmill.h>

      void worker(int count, const char *text) {
          int i;
          for(i = 0; i != count; ++i) {
              printf("%s\\n", text);
              msleep(10);
          }
      }

      int main() {
          go(worker(4, "a"));
          go(worker(2, "b"));
          go(worker(3, "c"));
          msleep(100);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmill", "-o", "test"
    system "./test"
  end
end
