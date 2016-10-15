class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-0.16-beta.tar.gz"
  sha256 "c6d68d8291dadf2ee111f6ceed057f2fd267e7dc334bef8d15b6316c35b6a0ca"
  head "https://github.com/sustrik/libmill.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cmake" => :build

  def install
    # Issue 21 at https://github.com/sustrik/libmill/issues/21
    # Due to a bug in Clang's optimizer, -O2 and above will
    # use the same address for mill_val in distinct and seperate coroutines,
    # which breaks everything.
    ENV.O1 if ENV.compiler == :clang

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
