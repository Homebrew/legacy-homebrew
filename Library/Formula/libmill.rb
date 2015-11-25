class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.1.tar.gz"
  sha256 "146add8283cb88f3d42418e4666211d4a085f57c317a24a56e9afab8167db77d"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    cellar :any
    sha256 "f5b5974a8cdc1d8701e184a412c8438f9ad1f13665b33db30a52439287d626cc" => :el_capitan
    sha256 "652e19d0eea9b7bd9ea009eb03c025ed5a3a393d5ba899e375109aad3bf06b73" => :yosemite
    sha256 "c8bc0246d358809bc9c429b8f91ed01b44c60ebe1720a2d83a735a50f6239df3" => :mavericks
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
